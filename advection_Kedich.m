%% Initialuzation of the initial conditions
clearvars
close all
% initialisation of model constants
dx     = 500;       % spatial step in m = .5km
lambda = 100*dx;    % wavelength
nr     = 1e3;       % size of the domain
ampl   = 5;         % amplitude (K)

% initialisation of variables
x = 0:dx:((nr-1)*dx);
b = find(x <= lambda);
c = find(x >  lambda);

y(b) = ampl*sin(x(b)*2*pi/lambda);
y(c) = 0;

%% Plotting initial condition
axes1 = axes('FontSize',10,'FontWeight','bold','Parent',figure);
ylim  (axes1,[-6 6]);
xlabel(axes1,'x (km)');
ylabel(axes1,'T (K)');
box   (axes1,'on');
grid  (axes1,'on');
hold  (axes1,'all');
plot(x/1.E3, y, 'r', 'LineWidth',1.5)

%% Analytical solution
w = 36; %wind speed
dt_h = 5; %4 hours time

shift = w*dt_h; %calculate shift in km
j = find(x/1e3 == shift); %find distance for the shift

y_new = y; % y_new is numerical solution
y_new(2:101) = 0; %change previous position of amplitude with zeros
y_new(j:j+99) = y(2:101); %assign to new interval
%% Numerical solution
%initial conditions
u_new = y; %copy the initial condition
u_p = u_new; % previous step
t= 0;
dt = 25;

nsteps = 18000/25;

for n = 1:nsteps
    for i = 2:length(x)
        u_p(i) = u_new(i) - 10*dt/dx*(u_new(i) - u_new(i-1));
    end 

    t = t+dt;
    u_new = u_p;
    
    %plotting steps
    plot(x, u_new, "LineWidth", 1.5, "Color", "r");
    grid on
    ylim([-6 6])
    xlabel('x, km')
    ylabel('T, K')
    title(n + " step")
    pause(0.01)
end 
%% Comparison between analytical and numerical solutions

axes1 = axes('FontSize',10,'FontWeight','bold','Parent',figure);
ylim  (axes1,[-6 6]);
xlabel(axes1,'x (km)');
ylabel(axes1,'T (K)');
box   (axes1,'on');
grid  (axes1,'on');
hold  (axes1,'all');
plot(x/1.E3, y_new, 'r', 'LineWidth',1.5) % analytical solution - red
hold on
plot(x/1.E3, u_new, 'b', 'LineWidth',1.5) % numerical solution - blue
%hold on
%plot(x/1.E3, u_p(1:1000), 'y', 'LineWidth',1.5) 

%% Negative wind Analytical solution
w_minus = -36; %wind speed
dt_h = 5; %4 hours time

shift = w_minus*dt_h;
shift_x = 500+shift;

j = find(x/1e3 == shift_x);
y_new_minus = y;
y_new_minus(2:101) = 0;
y_new_minus(j:j+99) = y(2:101);
%plot the solution
axes1 = axes('FontSize',10,'FontWeight','bold','Parent',figure);
ylim  (axes1,[-6 6]);
xlabel(axes1,'x (km)');
ylabel(axes1,'T (K)');
box   (axes1,'on');
grid  (axes1,'on');
hold  (axes1,'all');
plot(x/1.E3, y_new_minus, 'r', 'LineWidth',1.5)
%% Negative wind Numerical solution 
%The result goes up to 0 and becomes very small

w_minus = -10;
u_minus = y;
up_minus = u_minus; 
t= 0;
dt = 25;

nsteps = 18000/25;

for n = 1:nsteps

    for i = 2:length(x)-1
        up_minus(i) = u_minus(i) + 10*dt/dx*(-u_minus(i) + u_minus(i+1));
        up_minus(end) = u_minus(2); % transition to other side
    end 
    
    t = t+dt;
    u_minus = up_minus;

    plot(x, u_minus, 'b', "LineWidth", 1.5);
    ylim([-6 6])
    grid on
    title(n + " step")
    pause(0.01)
end 
%% Numerical solution with time step 200
v = 10; %velocity
nl = (x(end)+dx) / dx; %the number of spatial points +1 and -1
time = 18000; %5 hours in seconds
dt = 200; %time step
nt = time/dt; %time steps

cr = 10*200/500; %courant number

t=linspace(0, time, nt+1);

u_new_200 = y;
for j=2:nt+1
    u_new_200(2:end) = (1-cr)*u_new_200(2:end) + cr*u_new_200(1:end-1);
    u_new_200(1)=0;
    u_new_200(end)=0;
    plot(x,u_new_200,'r*:');
xlabel('x'); ylabel('U(x,t)');
title(['t=',num2str(t(j))]);
pause(0.001);
end

% we could state that with this time step the numerical solution cannot be
% obtained
%% Numerical solution (leapfrog)

%initial conditions
u_new = y;
u_p_1 = u_new;
u_p_2 = u_new;
N = 999;
t= 0;
dt = 25;
nsteps = 18025/25; %one more time step to filter application

%second step is calculated with upwind technique
    for i = 2:N+1
        u_p_2(i) = u_new(i) - 10*dt/dx*(u_new(i) - u_new(i-1));
    end 

up_matrix = zeros(1000, nsteps);
up_matrix(:,1) = u_p_1;
up_matrix(:,2) = u_p_2;

%starting the third step we use leapfrog approach
for n = 3:nsteps
    for i = 2:N
        up_matrix(i,n) = up_matrix(i, n-2) - 10*dt/dx*(up_matrix(i+1,n-1) - up_matrix(i-1,n-1));
    end 
    t = t+dt;
end 

plot(x, up_matrix(:,720), 'black', 'LineWidth',1.5)
grid on
xlabel('x, km')
ylabel('T, K')

%% Apllication of filter
%initial conditions
u_new = y;

unp_1 = u_new;
unp_2 = u_new;

t= 0;
dt = 25;
nsteps = 18025/25; %one more time step to filter application

%second step is calculated using upwind strategy
    for i = 2:length(x)
        unp_2(i) = u_new(i) - 10*dt/dx*(u_new(i) - u_new(i-1));
    end 

matrix_filter = zeros(1000, nsteps);
matrix_filter(:,1) = unp_1;
matrix_filter(:,2) = unp_2;

for n = 3:nsteps

    for i = 2:N
        matrix_filter(i,n) = matrix_filter(i, n-2) - 10*dt/dx*(matrix_filter(i+1,n-1) - matrix_filter(i-1,n-1));
    end 

    matrix_filter(:,n-1) = matrix_filter(:,n-1) + 0.15*(matrix_filter(:,n) - ...
    2*matrix_filter(:,n-1)+matrix_filter(:,n-2));
    
    t = t+dt;
end 

%% Comparison on a graph

plot(x, up_matrix(:,720), 'r', "LineWidth", 1.5) %without filter
hold on
plot(x, matrix_filter(:,720), 'b', "LineWidth", 1.5) %with filter
grid on
xlabel('x, km')
ylabel('T, K')

