clear vars 


glacier.height = 100;
glacier.equlibrium = 0.5;
% example of structure

%%
Kampala = city(0.22, 1.507E6);
Masaka = city(0.21, 103829);
Jinja = city(0.15, 72931);
cities = [Masaka, Jinja];

%Masaka = Masaka.updatePop(Kampala);
%Kampala = Kampala.updatePop(Masaka, Jinja);

%on the next steps we have adapted the script to assess the migration
% cities from the property inside the object
% classes were adjusted for purposes of OOP Lecture 2

Kampala = Kampala.updatePop();
Masaka = Masaka.updatePop();
Jinja = Jinja.updatePop();

