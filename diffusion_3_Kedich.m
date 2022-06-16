%Diffusion advection equation
clearvars; 
close all

% physics
D = 25; %diffusivity of the earth crust

% Temperature initialization
Tsurf = 10;
Tdepth = 700;

time = 0; % initial time
thick = 25; %thickness of crust in km
dx = 0.1; % in km
x = 0:dx:thick; %discretized space
nt = 10000;
nout = 1000;
T = linspace(Tsurf, Tdepth, length(x)); %discretized time 
%% Plot initial conditions

plot(T,-x, LineWidth=1.5, Color='r')
grid on
xlabel('Thickness, km')
ylabel('Temperature, C')
title(time + " Ma")
drawnow

%% Implementation of advection diffusion equation

% impose a condition on the time step
% the same rule as in previous exercises
dt = 0.5*dx^2/D;

% initial condtions tp - previous step
% res - starting conditions for improvement
% it - iteration, 
tp=T; it=0; 
res=1e6;

u = 10; %u*dt/dx should be < 1

%until defined threshold is passed we implement the loop
while (res > 1e-3)

    it = it+1;

    %update time
    time = time+dt;

    for i = 2:length(T)-1
        T(i)=tp(i)+D*(dt/dx^2)*(tp(i+1)-2*tp(i)+tp(i-1))+u*(dt/dx)*(tp(i)-tp(i-1)); 
    end
    
    %boundary conditions
    T(1)=10; 
    T(length(T))=700;

    res = sum(abs(tp-T)); %estimate the improvement
    tp = T;

    %plotting steps
    if (mod(it,nout)==0)
        plot(T,-x, LineWidth=1.5, Color='r')
        grid on
        xlabel('Temperature, C')
        ylabel('Thickness, km')
        title(time + " Ma")
        drawnow
    end
end

