clearvars; 
close all

%Initialization of variables
% physics
D = 100;
Lx = 300;
time = 0;
 
% numerics
dx = 0.1;
x = 0:dx:Lx;
nt = 10000;
nout = 1000;
 
% initial condition
for i=1:length(x)
    if (x(i)<Lx/2)
        C(i)=500;
    else
        C(i)=0;
    end
end

%% Plot initial conditions

axes1 = axes('FontSize',10,'FontWeight','bold','Parent',figure);
plot(x,C, LineWidth=1.5, Color='r')
grid on;
xlabel('Horizontal distance')
ylabel('Concentration')
ylim([0 510])
title(time + "sec.")
drawnow
%% Implementation of diffusion equation

% impose a condition on the time step (use the above described rule)
% dt should be smaller thatn dx^2/D, here we take half of it
dt = 0.5*dx^2/D;

% initial conditions / cp - previous step / it number of iterations
% res the value used as a minimum improvement 
cp=C; it=0; res=1e5;

% while loop until certain improvement is not observed
while (res > 1e-4)
    it = it+1;

    %update time
    time = time+dt;
    
    %the cycle to calculate next value
    for i = 2:length(C)-1
        C(i)=cp(i)+D*(dt/dx^2)*(cp(i+1)-2*cp(i)+cp(i-1));
    end

    C(1)=500; %stable boundary, left
    C(length(C))=0; %stable boundary, right

    res = sum(abs(cp-C)); %calculation of absolute improvement
    cp = C;

    %plotting steps
    if (mod(it,nout)==0)
        plot(x,C, LineWidth=1.5, Color='r')
        grid on
        xlabel('Horizontal distance, ')
        ylabel('Concentration')
        title(time + " sec.")
        drawnow
    end

end
