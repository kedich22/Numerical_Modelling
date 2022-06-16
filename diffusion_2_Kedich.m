clearvars; 
close all

%Initializing initial conditions
% physics
D = 25; %diffusivity of the rocks

%Initial sill and surface temperature
Tinit = 1000;
Tsur = 0;

%Time initializing
time = 0;

%Thickness of sill
thick = 0.1; 

% Thinkness above and below the sill
thick_ab = 0.2;
thick_bel = 0.2;

% overall thickness
Lx = thick_ab + thick + thick_bel;

% numerical parameters
dx = 0.001; % in km
x = 0:dx:Lx;
nt = 10000;
nout = 1000;
 
% initial condition
for i=1:length(x)
    if (x(i)>thick_ab) && (x(i)<thick_ab+thick)
        T(i)=Tinit;
    else
        T(i)=0;
    end
end
%% Plotting initial condition

plot(T,x, LineWidth=1.5, Color='r')
grid on
ylabel('Thickness of layer, km')
xlabel('Temperature, C')
xlim([0 1200])
title(time + " Ma")
drawnow

%% Implementation of diffusion 
% impose a condition on the time step (use the above described rule)
% dt should be smaller thatn dx^2/D, here we take half of it
dt = 0.5*dx^2/D;

% initial conditions / tp - previous step / it number of iterations
tp=T; it=0; 

% loop initialization
% as a stop parameters we use when central value reach 100 temperature
while (T(round(length(x)/2)) > 100)
    it = it+1;

    %update time
    time = time+dt;
    
    %the cycle to calculate next value
    for i = 2:length(T)-1
        T(i)=tp(i)+D*(dt/dx^2)*(tp(i+1)-2*tp(i)+tp(i-1));
    end

    %boundary condtions
    T(1)=0; 
    T(length(T))=0;
    tp = T;

    %plotting the steps
    if (mod(it,nout)==0)
        plot(T,x, LineWidth=1.5, Color='r')
        grid on
        ylabel('Thickness, km')
        xlabel('Temperature, C')
        xlim([0 1200])
        title(time + " Ma")
        drawnow
    end
end