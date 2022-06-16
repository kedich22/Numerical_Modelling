classdef river < matlab.mixin.SetGet
    
    properties (Access = private)
       catchment_X double
       catchment_Y double
       riv_length(1,1) double {mustBeReal, mustBeNonnegative, mustBeFinite}
    end 
    properties (Access = public)
       name char {mustBeFinite}
       riv_sed(1,1) double {mustBeReal, mustBeNonnegative, mustBeFinite}
       riv_use(1,1) double {mustBeReal, mustBeNonnegative, mustBeFinite}
       riv_q(1,1) double {mustBeReal, mustBeNonnegative, mustBeFinite}
       flows_in char {mustBeFinite}
       riv_id(1,1) int8 {mustBeReal, mustBeNonnegative, mustBeFinite, mustBeNonmissing, mustBeInteger}
    end

    properties (Dependent)
        catchment_area int32
        flow_into_lake int
    end 
    
    methods
        %getter methods
        function value = get.riv_sed(obj)
            value = obj.riv_sed;
        end
        function value = get.riv_use(obj)
            value = obj.riv_use;
        end
        function value = get.riv_q(obj)
            value = obj.riv_q;
        end
        function value = get.flows_in(obj)
            value = obj.flows_in;
        end
        function value = get.riv_id(obj)
            value = obj.riv_id;
        end
        %Constructor
        function catchment = river(name, catchment_X, catchment_Y, riv_length, ...
                riv_sed, riv_use, riv_q, flows_in, riv_id)
            catchment.name = name;
            catchment.catchment_X = catchment_X;
            catchment.catchment_Y = catchment_Y;
            catchment.riv_length = riv_length;
            catchment.riv_sed = riv_sed;
            catchment.riv_use = riv_use / 100; % transefer from percents
            catchment.riv_q = riv_q*60*60*24; %transfer to values per day
            catchment.flows_in = flows_in;
            catchment.riv_id = riv_id;
        end
        %Getters for dependent properties
        function value = get.catchment_area(river)
            value = polyarea(river.catchment_X, river.catchment_Y);
        end 
        
        function value = get.flow_into_lake(river)
            if strcmp(river.flows_in, 'Victoria') 
                value = 1;
            elseif strcmp(river.flows_in, '0')
                value = NaN;
            else
                value = 0;
            end
        end 
        %function to calculate the runoff considering the water use within
        %the catchment
        function value = water_use(River, rfcm)
            value = rfcm(River.riv_id) * (1 - River.riv_use);
        end 
        %The function that calculates the stable inflow without timelag,
        %used for first 5 days
       function value = stable_inflow(river, runoff_time)
            inflow = 0;
                if river.flow_into_lake == 1 
                    inflow = runoff_time(1,river.riv_id);
                end
            value = inflow;
       end


    end 

    methods (Static)
        % The function for the calculation of runoff per each cell in m3

        function value = calculate_runoff(soil_retention, lake, loop)
            runoff = zeros(size(soil_retention, 1), size(soil_retention, 2));
            %looping through the soil retention raster
            for i = 1:size(soil_retention, 1)
                for k = 1:size(soil_retention, 2)
                    if lake.precipitation(loop) < 0.2*soil_retention(i,k)
                        runoff(i,k) = 0;
                    else 
                        %formula to calculate runoff in a cell
                        runoff(i,k) = ((lake.precipitation(loop)-0.2*soil_retention(i,k))^2)/...
                            (lake.precipitation(loop) + 0.8*soil_retention(i,k));
                    end
                end
            end
            % 1 mm per 1m2 is 0.001 m3 per 1 m2
            value = runoff * 1e6 / 1e3 ; %output runoff per cell (10^6 m2) in m3
        end
        
        % sum runoff from cells to catchments
        function value = rf_catchment(catchments, runoff) %runoff per catchment calculation
            sum_runoff = zeros(30, 1);
            %summation of all cells per cathments through the raster
            for i = 1:size(catchments, 1)
                for z = 1:size(catchments, 2)
                    if catchments(i,z) ~= 0 && catchments(i,z) ~= 32
                        sum_runoff(catchments(i,z)) = sum_runoff(catchments(i,z))...
                                + runoff(i,z);
                    end 
                end 
            end
            value = sum_runoff; %output runoff per catchment in m3 
        end

        %time lag implementation
        function value = non_stableinflow(river, runoff, k)
            temp_rf = runoff(k-1:k,:);
            for j = 1:length(river)
                if river(j).flow_into_lake == 0 % check if river does not flow into Victoria 
                    main_river = river(j).flows_in; %get the name of the outlet river
                    for m = 1:length(river) % loop to access the name of the main river
                        if strcmp(main_river, river(m).name)
                            %we add to the value from previous row tributaries in a matrix
                            temp_rf(2, river(m).riv_id) = temp_rf(2, river(m).riv_id)...
                                + temp_rf(1, river(j).riv_id);
                        end
                    end
                end
            end
            value = temp_rf(2, :); 
        end

    %sum runoff that flows into the lake directly
    function value = inflow_sum(river, runoff)
            sum_inflow = 0;
            for i = 1:length(river)
                if river(i).flow_into_lake == 1 
                    sum_inflow = (sum_inflow + runoff(i)); 
                end
            end
            value = sum_inflow;
        end

    end


end

