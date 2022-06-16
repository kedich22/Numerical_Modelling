classdef lake < matlab.mixin.SetGet

    properties (Access = public)
        time datetime
        precipitation(:,1) double {mustBeReal, mustBeNonnegative, mustBeFinite}
        evaporation(:,1) double {mustBeReal, mustBeFinite}
        inflow(:,1) double
        outflow(:,1) double
        level(:,1) double {mustBeReal, mustBeNonnegative, mustBeFinite}
    end

    properties (Constant)
        area = 6.83e10
    end

    properties (Dependent)
        precip_cumsum(:,1) double
        balance_prec_evapor(:,1) double
    end

    methods
        %Constructor
        function obj = lake(time, precip)
            obj.precipitation = precip; % in mm
            obj.time = time;
            obj.evaporation = transpose(normrnd(3.8, 1, 1,height(obj.precipitation))); % in mm
        end
        %Getter methods
        function value = get.precipitation(obj)
            value = obj.precipitation;
        end
        function value = get.evaporation(obj)
            value = obj.evaporation;
        end
        %Setter methods
        function set.inflow(obj, value)
            obj.inflow = value;
        end 
        function set.outflow(obj, value)
            obj.outflow = value;
        end 
        function set.level(obj, value)
            obj.level = value;
        end 
        %Getters for dependent properties cumulative precipitation and
        %precipitation - evaporation
        function value = get.precip_cumsum(lake)
            value = zeros(length(lake.precipitation), 1);
            for i = 6:length(lake.precipitation)
                value(i) = sum(lake.precipitation((i-5):i)); %in mm
            end
        end

        function value = get.balance_prec_evapor(lake)
            value = zeros(length(lake.evaporation), 1);
            for i = 1:length(lake.evaporation)
                value(i) = lake.precipitation(i) - lake.evaporation(i); %in mm
            end
        end
        
        %function that calculates the outflow based on the lake level
        function value = lake_outflow(lake, i)
            value = 66.3 * (lake.level(i-1) - 7.96)^2.01; % in m3
        end 
        
        %function that calculated the water balance
        function value = water_balance(lake, i)
            % evaporation - precipitation is divided by 1000 to convert to
            % m, inflow and outflow is in cubic m initially so there is no
            % need in changes
            value = lake.level(i) + lake.balance_prec_evapor(i)/1000 +... 
            ((lake.inflow(i) - (66.3 * (lake.level(i) - 7.96)^2.01))/lake.area);
        end
    end
end

