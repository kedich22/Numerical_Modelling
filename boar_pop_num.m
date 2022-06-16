function population = boar_pop_num(N0, dt, tfinal, r)
Nsteps = round(tfinal/dt);
bearpop = [N0, zeros(1,Nsteps)];
for j = 1:Nsteps
    bearpop(j+1) = bearpop(j) + (dt*r*bearpop(j));
end
population = bearpop;
end