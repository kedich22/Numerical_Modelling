% First exercise: wild boar population
A = 50000;
N = 11000000;

years = log(N/A)/0.48;
years;

%11 years to reach the result
%% Training
v1 = [1,4,6,8];
v2 = [1;4;6;8;9];
v3 = linspace(0,10,5);
v4 = [0:2:16];
m1 = [1,1;2,6,;2,6;3,7];

A = zeros(5);
B = NaN(6,2);

rand;
randn;
randi([-10 10], 3,4);

A = magic(4);
A = [A, ones(4,1)]; %add new column into matrix

A(1:3, 2); 
A(:, 2)*2;

A(end);


A = [1:5, 0];
ind = find(A>3); %gives indicies
A>3; %boolean array as a response

A = [10,20,40,50,70,90,100];
A(A>30);

B = [1:3;1:3;1:3];
ind = find(B>2);
[row,col] = find(B>2); %find indicies for a matrix elements (rows cols)
%% 
clearvars

%calling functions
Result_1 = TimeToPopNew(50000, 11e6); %output with 5 random growth coefficients
Result_2 = PopFromTime(50000, 10, 0.48);









