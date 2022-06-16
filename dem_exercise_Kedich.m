load('dem.mat')
%imagesc(dem)

r1 = 10*1; 
r2 = r1+r1*2;
c1 = 5*11;
c2 = c1+c1*3;

% extraction of subset from dem
dem_extract = dem(r1:r2, c1:c2);

%example of calculations on one cell
dz_dx = (dem_extract(2,3) - dem_extract(2,1))/180;
dz_dy = (dem_extract(1,2) - dem_extract(3,2))/180;
slope = sqrt(dz_dx^2 + dz_dy^2);

%calculation through nested loop on the whole matrix
n1 = height(dem_extract)-1;
n2 = width(dem_extract)-1;
slope_matrix = [height(dem_extract)-2, width(dem_extract)-2];

for i = 2:n1
    for j = 2:n2
        dz_dx = (dem_extract(i,j+1) - dem_extract(i,j-1))/180;
        dz_dy = (dem_extract(i-1,j) - dem_extract(i+1,j))/180;
        slope = sqrt(dz_dx^2 + dz_dy^2);
        slope_matrix(i-1, j-1) = slope;
    end 
end

% implementation of fuction to calulate slope
slopes = Slope_calc(dem, r1, r2, c1, c2, 90);
slopes

% test whether equal or not
slopes == slope_matrix

% obtained results are equal!
