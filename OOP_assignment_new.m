%% Dowloading files
tic
clearvars
catchments = shaperead('D:\Study_2021-2022\Numerical Modelling\assignment\LakeVictoria_Data\Victoria_Catchments.shp');
precip = readtable('D:\Study_2021-2022\Numerical Modelling\assignment\LakeVictoria_Data\precipitation_obs.csv');

[lc_tif, ~] = readgeoraster('D:\Study_2021-2022\Numerical Modelling\assignment\LakeVictoria_Data\lc_Victoria.tif', 'OutputType','uint8');
[soil_tif, ~] = readgeoraster('D:\Study_2021-2022\Numerical Modelling\assignment\LakeVictoria_Data\soil_Victoria.tif');
[catchments_tif, ~] = readgeoraster('D:\Study_2021-2022\Numerical Modelling\assignment\LakeVictoria_Data\Catchments_Rasterized.tif', 'OutputType','uint8');

format long
%% Creation of river objects
river_array = river.empty(30,0);

for i = 1:length(catchments)
    field = struct2cell(catchments(i));
    field{3} = rmmissing(field{3});
    field{4} = rmmissing(field{4});
    river_array(i) = river(field{5},field{3}, field{4}, field{6}, ...
               field{7}, field{8}, field{9}, field{10}, field{11});
end 
clear field i catchments
%% Creation of lake object
precip(:,2) = fillmissing(precip(:,2), 'linear'); %remove nans and fill with values
Victoria = lake(table2array(precip(:,1)), movmean(table2array((precip(:,2))), 10)); %smoothern precipitation with moving average 10
%% Creation of environment object
Victoria_env = environment(lc_tif, soil_tif, catchments_tif);
clear soil_tif lc_tif precip
%% Calculation of inflow for first 5 days based on Q

%matrix with runoff for all rivers for every day created
%will be filled with only first 5 days
%we need first days river-by-river for lag calculation
lake_inflow_matrix = zeros(length(Victoria.precipitation), 30);

% Calculation for the first 5 days inflow
const_runoff = zeros(30, 1);

for i = 1:(length(river_array))
    if get(river_array(i), "riv_id") ~= 32
    const_runoff(get(river_array(i), "riv_id")) = get(river_array(i), "riv_q");
    end
end

for k = 1:5
    value = 0;
    lake_inflow_matrix(k,:) = const_runoff;
    for i = 1:length(river_array)
        value = value + river_array(i).stable_inflow(lake_inflow_matrix);
    end
    Victoria.inflow(k, 1) = value; %.stable_inflow(river_array, lake_inflow_matrix);
end  
%inflow for first 5 days calculated

clear const_runoff i k
%% Caclulation the inflow matrix without time lag
for m = 6:length(Victoria.time)
        Soil_retention = Victoria_env.define_SoilRetention(Victoria, m);
        runoff_overtime = river.calculate_runoff(Soil_retention, Victoria, m);
        rfcm_time = river.rf_catchment(catchments_tif, runoff_overtime);
        for k = 2:length(river_array)
           rfcm_time(get(river_array(k), "riv_id")) = river_array(k).water_use(rfcm_time);
        end 
        lake_inflow_matrix(m, :) = rfcm_time;
        lake_inflow_matrix(m, :) = river.non_stableinflow(river_array, lake_inflow_matrix, m);
        Victoria.inflow(m) = river.inflow_sum(river_array, lake_inflow_matrix(m, :));
end 

Victoria.inflow = fillmissing(Victoria.inflow, 'linear');

clear Soil_retention runoff_overtime rfcm_time catchments_tif lake_inflow_matrix
%% Victoria level retrieval
Victoria.level(1) = 1135;
for i = 2:length(Victoria.time)
    Victoria.level(i) = Victoria.water_balance(i-1);
    Victoria.outflow(i) = Victoria.lake_outflow(i);
end

%% Plotting figures 
figure(1)
plot(get(Victoria, "time"), get(Victoria, "level"), "LineWidth", 1.3)
grid("on")
ylabel("Lake level [m]")
title("Modelled Victoria lake level")

rel_level = zeros(length(Victoria.level),1);
for i = 1:length(Victoria.level)
    rel_level(i) = (Victoria.level(i)) - 1135;
end 

figure(2)
plot(Victoria.time, (cumsum((Victoria.inflow/6.83e10))),'DisplayName','Inflow', Color=[0.4940 0.1840 0.5560])
hold on
plot(Victoria.time, (cumsum(Victoria.precipitation)/1000), 'g','DisplayName','Precipitation', Color=[0 0.4470 0.7410])
hold on
plot(Victoria.time, -(cumsum(Victoria.evaporation)/1000),'DisplayName','Evaporation', Color=[0.8500 0.3250 0.0980])
hold on
plot(Victoria.time, rel_level, 'black','DisplayName','Lake level change')
hold on
plot(Victoria.time, -(cumsum((Victoria.outflow/6.83e10))), 'r','DisplayName','Outflow', Color=[0.6350 0.0780 0.1840])
grid("on")
legend('Location','northwest')
ylabel("Lake level equivalent [m]")

time_taken=toc;
disp("Time: " + time_taken)