%%
Kampala = capital(0.2, 1.507E6);
Masaka = city(0.22, 103829);
Jinja = city(0.21, 72931);
Kamuli = city(0.15, 17725);

Kamuli.migration_cities = [Kampala, Jinja];
Masaka.migration_cities = Kampala;
Jinja.migration_cities = Kampala;

city_network = [Masaka, Jinja, Kamuli];
Kampala.migration_cities = city_network;


time_range = 2015:2100;

for t = 1:numel(time_range)
N_Kampala(t)=Kampala.population;
N_Masaka(t)=Masaka.population;
N_Jinja(t) = Jinja.population;
N_Kamuli(t) = Kamuli.population;

Kampala = Kampala.updatePop();
Kamuli = Kamuli.updatePop();
Masaka = Masaka.updatePop();
Jinja = Masaka.updatePop();
end 

semilogy(time_range,N_Kampala)
xlabel('Year')
ylabel('Population')
hold on
semilogy(time_range,N_Masaka)
semilogy(time_range, N_Jinja)
semilogy(time_range, N_Kamuli)
legend("Kampala","Masaka", "Jinja", "Kamuli")
hold off 
%}

