classdef environment < matlab.mixin.SetGet

    properties (Access = private)
        landcover {mustBeReal, mustBeFinite, mustBeLessThanOrEqual(landcover,110)}
        soil {mustBeReal, mustBeFinite, mustBeLessThanOrEqual(soil,12)}
        catchments {mustBeReal, mustBeFinite, mustBeLessThanOrEqual(catchments,32)}
    end

    properties (Dependent, Access = private)
        soil_reclass {mustBeReal, mustBeFinite, mustBeLessThanOrEqual(soil_reclass,4)}
        cn1
        cn2
        cn3
    end

    methods
        %Constructor
        function env = environment(landcover, soil, catchments)
            env.landcover = landcover;
            env.soil = soil;
            env.catchments = catchments;
        end
        %Getter fucntions
        function value = get.landcover(obj)
            value = obj.landcover;
        end
        function value = get.soil(obj)
            value = obj.soil;
        end
        function value = get.catchments(obj)
            value = obj.riv_sed;
        end
        %Calculation of dependent properties soil_reclass, cn1, cn2, cn3
        function value = get.soil_reclass(environment)
            value = environment.soil;
            soil_table = table2array(table([1;2;3;4;5;6;7;8;9;10;11;12], [4;4;4;4;4;3;2;2;1;1;1;1]));
            for i = 1 : length(soil_table)
                value(environment.soil == soil_table(i,1)) = soil_table(i,2);
            end
        end
        function value = get.cn2(environment)
            %Iniital reclassification table for obtaining curve number soil class 2
            soil_2_table = double(table2array(table([60; 20; 30; 40; 50; 10; 80; 90], [74; 56; 69; 74; 86; 60; 100; 86])));
            CN_soil2 = environment.landcover;
            for i = 1:length(soil_2_table)
                CN_soil2(CN_soil2 == soil_2_table(i,1)) = soil_2_table(i,2);
            end

            %Iniital reclassification table for obtaining curve number soil class 1
            soil_1_table = double(table2array(table([10; 20; 30; 40; 50; 60; 80; 90], [36; 35; 49; 64; 77; 59; 100; 77])));
            CN_soil1 = environment.landcover;
            for i = 1:length(soil_1_table)
                CN_soil1(CN_soil1 == soil_1_table(i,1)) = soil_1_table(i,2);
            end


            %Iniital reclassification table for obtaining curve number soil class 3
            soil_3_table = double(table2array(table([10; 20; 30; 40; 50; 60; 80; 90], [73; 70; 79; 81; 91; 82; 100; 91])));
            CN_soil3 = environment.landcover;
            for i = 1:length(soil_3_table)
                CN_soil3(CN_soil3 == soil_3_table(i,1)) = soil_3_table(i,2);
            end

            %Iniital reclassification table for obtaining curve number soil class 4
            soil_4_table = double(table2array(table([10; 20; 30; 40; 50; 60; 80; 90], [79; 77; 84; 85; 94; 86; 100; 94])));
            CN_soil4 = environment.landcover;
            for i = 1:length(soil_3_table)
                CN_soil4(CN_soil4 == soil_4_table(i,1)) = soil_4_table(i,2);
            end

            cn_value = environment.soil_reclass;

            for i = 1:height(cn_value)
                for k = 1:width(cn_value)
                    if cn_value(i, k) == 1
                        cn_value(i, k) = CN_soil1(i,k);
                    elseif cn_value(i, k) == 2
                        cn_value(i, k) =  CN_soil2(i,k);
                    elseif cn_value(i,k) == 3
                        cn_value(i, k) =  CN_soil3(i,k);
                    elseif cn_value(i,k) == 4
                        cn_value(i, k) =  CN_soil4(i,k);
                    end
                end
            end
            value = cn_value;
        end

        function value = get.cn1(environment)
            value = environment.cn2./(0.427 + 0.00573.*environment.cn2);
        end

        function value = get.cn3(environment)
            value = environment.cn2./(2.281 - 0.01281.*environment.cn2);
        end
        
        % Method to obtain soil retention raster for certain day i
        function soilret = define_SoilRetention(env, lake, i)
                if lake.precip_cumsum(i) < 12.5
                    CN = env.cn1;
                elseif lake.precip_cumsum(i) > 27.5
                    CN = env.cn3;
                else
                    CN = env.cn2;
                end
            soilret = (1000./CN - 10) * 25.4;
        end

    end
end