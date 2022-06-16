N = 1000;
r = 0.48;
car_capacity = 1e6;
boarlog = N;
changetol = 40;
dt = 1;

%creation of first step
growthspeed = (car_capacity - boarlog(end)) / car_capacity;
newpop = boarlog(end) + (dt*growthspeed*boarlog(end));
boarlog = [boarlog, newpop];

%loop to calculate the logistic, changing growthspeed
while abs(boarlog(end-1)) - boarlog > changetol
    growthspeed = r*(car_capacity-boarlog(end)) / capacity;
    newpop = boarlog(end)+(dt*growthspeed*boarlog(end));
    boarlog = [boarlog, newpop];
end 

%numerical solution
%exercise 1.
%Logistic model run
growthrate = 0.48;
NO = 1000;
capacity = 1e6;
dt = 1;
tfinal = 30;
Nsteps = round(tfinal/dt);
logistic30 = [NO, ones(1,Nsteps)];

%Loop
for i = 1:Nsteps
    growthspeed = growthrate*(capacity-logistic30(i)) / capacity;
    logistic30(i+1) = logistic30(i) + (dt*growthspeed*logistic30(i));
end


%for 500 years
growthrate = 0.02;
tfinal = 500;
Nsteps = round(tfinal/dt);
logistic500 = [NO, ones(1,Nsteps)];

for i = 1:Nsteps
    growthspeed = growthrate*(capacity-logistic500(i)) / capacity;
    logistic500(i+1) = logistic500(i) + (dt*growthspeed*logistic500(i));
end
%% 
%analytical solution
time30 = linspace(0,30,length(logistic30));
logana30 = PopAtTlog(time30, NO, 0.48, capacity);

time500 = linspace(0,500,length(logistic500));
logana500 = PopAtTlog(time500, NO, 0.02, capacity);

%% 
%Hunting exercise
N0 = 50000;
gr = 0.48;
hunting = 0.2;

time = 100;
dt = 0.1;
Nsteps = round(time/dt);

%calculation
boarshunitng = [N0, zeros(1,Nsteps)];

for i = 1:Nsteps
    boarshunitng(i+1) = boarshunitng(i) + dt*(gr-hunting)*boarshunitng(i);
end
%% 
figure(1)
time = linspace(0, time, length(boarshunitng));
plot(time, boarshunitng)
%% 
%Lotka Volterra model wolves and boars 
r = 0.48;
c = 0.01;
d = 0.24;
e = 0.005;

Nb = 100;
Nw = 25;

tfinal = 50;
dt = 0.1;
Nsteps = round(tfinal/dt);

boars = [Nb, zeros(1,Nsteps)];
wolves = [Nw, zeros(1,Nsteps)];

%wolves population
%system of dif equations

for i = 1:Nsteps
    boars(i+1) = boars(i) + dt*(r - c*wolves(i))*boars(i);
    wolves(i+1) = wolves(i) + dt*(e*boars(i)-d)  *wolves(i);
end

figure(1)
time_line = linspace(0, tfinal, length(boars));
plot(time_line, wolves, LineWidth=2)
hold on
plot(time_line, boars, LineWidth=2)
hold off
legend({'Wolves', 'Boars'}, ...
    'Interpreter','latex', 'FontSize',14)
xlabel('Time (years)', 'Interpreter','latex', 'FontSize', 14)
ylabel('Population', 'Interpreter','latex', 'FontSize', 14)


%% 

%insert hunting of 0.5 boar population every year - hunting effort
%check photos again 
%only one thing changed, r - hunting (in comparison to previous one)
h = 0.1;
% h = 0.5;

for i = 1:Nsteps
    boars(i+1) = boars(i) + dt*(r - c*wolves(i) - h)*boars(i);
    wolves(i+1) = wolves(i) + dt*(e*boars(i)-d)  *wolves(i);
end

figure(1)
time_line = linspace(0, tfinal, length(boars));
plot(time_line, wolves, LineWidth=2)
hold on
plot(time_line, boars, LineWidth=2)
hold off
legend({'Wolves', 'Boars'}, ...
    'Interpreter','latex', 'FontSize',14)
xlabel('Time (years)', 'Interpreter','latex', 'FontSize', 14)
ylabel('Population', 'Interpreter','latex', 'FontSize', 14)

%%
%home exercise
%add second prey
%also work with the exisiting data from file on toledo
%two for loops for growth rate and for init pop, for selected period
r = 0.48;
c = 0.01;
d = 0.24; %mortality of the wolves
e = 0.005;

r2 = 0.48;
c2 = 0.01;
e2 = 0.005;

Nb = 100;
Nd = 80;
Nw = 25;

tfinal = 50;
dt = 0.1;
Nsteps = round(tfinal/dt);

boars = [Nb, zeros(1,Nsteps)];
wolves = [Nw, zeros(1,Nsteps)];
deers = [Nd, zeros(1,Nsteps)];

%without hunting
for i = 1:Nsteps
    deers(i+1) = deers(i) + dt*(r - c2*wolves(i))*deers(i);
    boars(i+1) = boars(i) + dt*(r - c*wolves(i))*boars(i);
    wolves(i+1) = wolves(i) + dt*(e*boars(i)+e2*deers(i)-d) *wolves(i);
end

figure(3)
time_line = linspace(0, tfinal, length(boars));
plot(time_line, wolves, LineWidth=2)
hold on
plot(time_line, boars, LineWidth=2)
plot(time_line, deers, LineWidth=2)
hold off
legend({'Wolves', 'Boars', 'Deers'}, ...
    'Interpreter','latex', 'FontSize',14)
xlabel('Time (years)', 'Interpreter','latex', 'FontSize', 14)
ylabel('Population', 'Interpreter','latex', 'FontSize', 14)

%% 
%add hunting

for i = 1:Nsteps
    deers(i+1) = deers(i) + dt*(r - c2*wolves(i) - 0.2)*deers(i);
    boars(i+1) = boars(i) + dt*(r - c*wolves(i) - 0.15)*boars(i);
    wolves(i+1) = wolves(i) + dt*(e*boars(i)+e2*deers(i)-d) *wolves(i);
end

figure(3)
time_line = linspace(0, tfinal, length(boars));
plot(time_line, wolves, LineWidth=2)
hold on
plot(time_line, boars, LineWidth=2)
plot(time_line, deers, LineWidth=2)
hold off
legend({'Wolves', 'Boars', 'Deers'}, ...
    'Interpreter','latex', 'FontSize',14)
xlabel('Time (years)', 'Interpreter','latex', 'FontSize', 14)
ylabel('Population', 'Interpreter','latex', 'FontSize', 14)

%% 
%Loading the data from the file
data = readtable("Data_exercise.xlsx");

N0 = table2array(data(1,2));
r = 0.5; 

tfinal = height(data) - 1;
dt = 1;
Nsteps = round(tfinal/dt);
boar_pop = table2array(data(:,2));

boars = [N0, zeros(1,tfinal)];

for i = 1:Nsteps
    boars(i+1) = boars(i) + dt*r*boars(i);
end

%RMSE error calculation
RMSE_05 = sqrt(mean((transpose(boar_pop) - boars).^2));

%next try
%just select the smallest r, could be made through cycle till r is less on
%the next step than on the previous one
%we have selected the smallest rmse for r = 0.08
r = 0.08;
for i = 1:Nsteps
    boars(i+1) = boars(i) + dt*r*boars(i);
end

RMSE_008 = sqrt(mean((transpose(boar_pop) - boars).^2));

