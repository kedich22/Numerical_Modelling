classdef capital<city
    properties (Access = public) 
    tourists
    end

    methods
        %Constructor
        function newCapital = capital(r, population)
            newCapital = newCapital@city(r,population)
            A = (3-0.5).*rand(1,1) + 0.5;
            newCapital.tourists = population * 0.05 * A;
        end
    end
end