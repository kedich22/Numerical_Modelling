%% Plotting
%Practicing plots

x = linspace(-1,1,100);
sinewave = sin(2*pi*x);

figure(1);
plot(x, sinewave, "linewidth", 2);
hold off;
xlim([-1,1]);
legend({'$\sin(2 \ pi x)$'},'fontsize', 14, 'interpreter', 'latex');
xlabel('$x$', 'interpreter', 'latex', 'fontSize', 14);
title('Example of sine wave');

time = [0:1:5000];
Result = PopFromTime(50000, time, 0.48);
Result2 = PopFromTime(50000, time, 0.2);

figure(2)
plot(time, Result, 'k:', 'linewidth', 2)
hold on
plot(time, Result2, 'r', 'linewidth', 2)
ylim([0,30e6])
legend({'$growth rate \ 0.48$', '$growth rate \ 0.2$'},'fontsize', 14, 'interpreter', 'latex');
title('Bear popultation increse with different frowth rates');
xlabel('$time, years$', 'interpreter', 'latex', 'fontSize', 14);
ylabel('$population, mln$', 'interpreter', 'latex', 'fontSize', 14);
hold off

Result3 = PopFromTime(50000, time, 0.1);
Result4 = PopFromTime(50000, time, 0.2);
Result5 = PopFromTime(50000, time, 0.3);
Result6 = PopFromTime(50000, time, 0.4);

figure(3);
subplot(2,2,1)
plot(time, Result3, 'linewidth', 2)
xlabel('$time, years$', 'interpreter', 'latex', 'fontSize', 8);
ylabel('$population, mln$', 'interpreter', 'latex', 'fontSize', 8);
title('$Subplot \ 1$', 'interpreter', 'latex', 'fontSize', 10)
legend({'$growth rate \ 0.1$'},'fontsize', 8, 'interpreter', 'latex');
ylim([0,30e5])

subplot(2,2,2)
plot(time, Result4, 'linewidth', 2)
xlabel('$time, years$', 'interpreter', 'latex', 'fontSize', 8);
ylabel('$population, mln$', 'interpreter', 'latex', 'fontSize', 8);
legend({'$growth rate \ 0.2$'},'fontsize', 8, 'interpreter', 'latex');
title('$Subplot \ 2$', 'interpreter', 'latex', 'fontSize', 10)
ylim([0,30e5])

subplot(2,2,3)
plot(time, Result5, 'linewidth', 2)
xlabel('$time, years$', 'interpreter', 'latex', 'fontSize', 8);
ylabel('$population, mln$', 'interpreter', 'latex', 'fontSize', 8);
legend({'$growth rate \ 0.3$'},'fontsize', 8, 'interpreter', 'latex');
title('$Subplot \ 3$', 'interpreter', 'latex', 'fontSize', 10)
ylim([0,30e5])

subplot(2,2,4)
plot(time, Result6, 'linewidth', 2)
xlabel('$time, years$', 'interpreter', 'latex', 'fontSize', 8);
ylabel('$population, mln$', 'interpreter', 'latex', 'fontSize', 8);
legend({'$growth rate \ 0.4$'},'fontsize', 8, 'interpreter', 'latex');
title('$Subplot \ 4$', 'interpreter', 'latex', 'fontSize', 10)
ylim([0,30e5])
set(gcf, 'color', 'w')
hold off
%saveas(gcf, 'bears_subplot.png')
%last line used to save figures

%3d plot
x = linspace(1,5,5);
y = 1:10;
Y = y'; %transpose
[V, W] = meshgrid(x,Y);
H=V+W;
figure(4);
mesh(x,Y,H);

%% Meshgrid plots boars
%boars on a meshfrid
rates = 0.1:0.1:0.5; %different rates
time = linspace(0,15,1000);

beargrid = [ PopFromTime(50000, time, rates(1)); ...
    PopFromTime(50000, time, rates(2)); ...
    PopFromTime(50000, time, rates(3)); ...
    PopFromTime(50000, time, rates(4)); ...
    PopFromTime(50000, time, rates(5))]; 

figure(5);
mesh(time, rates, beargrid);
shading interp;
xlabel('$time, years$', 'interpreter', 'latex', 'fontSize', 12);
ylabel('$Rate, growth \ per \ year$', 'interpreter', 'latex', 'fontSize', 12);
zlabel('$population, mln$', 'interpreter', 'latex', 'fontSize', 12);

%% Loop practice
% loops
% numerical solutions for dif equations, approximation
% just selection of very small delta t instead of limit

N0 = 50000;
r = 0.48;
tfinal = 15; % years
dt = 1; % dt smaller, more precise
Nsteps = round(tfinal/dt);
bearpop = [N0, zeros(1,Nsteps)]; % vector concatenation

%small delta t, calculations step by step
%dt = 1
for j = 1:Nsteps
    bearpop(j+1) = bearpop(j) + (dt*r*bearpop(j));
end

%dt = 2
dt_two = 2;
bearpop_two = [N0, zeros(1,Nsteps)];

for j = 1:Nsteps
    bearpop_two(j+1) = bearpop_two(j) + (dt_two*r*bearpop_two(j));
end

%analytical solution
time = linspace(0, tfinal, length(bearpop));
bearpop_analytical = PopFromTime(N0, time, r);

%% Comparison of solutions
%make a plot to compare
figure(6)
plot(time, bearpop_analytical, LineWidth=2)
hold on
plot(time, bearpop, LineWidth=2)
hold off
legend({'Analytical solution', 'Numerical solution'}, ...
    'Interpreter','latex', 'FontSize',14)
xlabel('Time (years)', 'Interpreter','latex', 'FontSize', 14)
ylabel('Boar population', 'Interpreter','latex', 'FontSize', 14)

%% Numerical solution
% funtion to calculate numerically bear_pop_num

popul = boar_pop_num(50000, 1, 15, 0.48);
popul_two = boar_pop_num(50000, 2, 15, 0.48);

%analytical solution
time = linspace(0, tfinal, length(bearpop));
bearpop_analytical = PopFromTime(N0, time, r);

%RMSE calculation
RMSD_one = sqrt(sum((bearpop_analytical - popul).^2)/15);









