classdef city<matlab.mixin.Heterogeneous
    %to enable polymorphism type the upper statement of inheritance
    properties (Access = public)
        r(1,1) double {mustBeReal, mustBeFinite};
        population(1,1) int64 {mustBeReal, mustBeNonnegative, mustBeFinite};
        migration_cities city;
    end

    properties (Dependent)
        pullfactor
    end 

    methods 
        %Constructor
        function thisCity = city(r, population)
            thisCity.r = r;
            thisCity.population = population;
        end

        %Functions
        function value = get.pullfactor(city)
            if city.population < 20000
                value = 0.01;
            elseif city.population < 1E6
                value = 0.05;
            else 
                value = 0.1;
            end
        end 
    end

    methods (Access = public)

        function natural_growth = naturalGrowth(thisCity)
            natural_growth =  double(horzcat(thisCity.population)).*horzcat(thisCity.r);
        end 

        function net_migration = migration(thisCity, thisCity_two)
            net_pull = thisCity.pullfactor - horzcat(thisCity_two.pullfactor);
            population_array = horzcat(thisCity_two.population);
            population_array(net_pull<0) = thisCity.population;
            value = net_pull.*double(population_array);
            net_migration = sum(value);
        end

        function thisCity = updatePop(thisCity)
            newpop = double(horzcat(thisCity.population)) + horzcat(thisCity.naturalGrowth) +... 
            horzcat(thisCity.migration(horzcat(thisCity.migration_cities)));
            newpop = num2cell(newpop);
            [thisCity.population] = deal(newpop{:});
        end
    end
end

