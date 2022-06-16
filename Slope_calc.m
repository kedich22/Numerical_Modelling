function Result = Slope_calc(dem_mat, subsetrow1, subsetrow2, subsetcol1, subsetcol2, res_dem)
dem_extract = dem_mat(subsetrow1:subsetrow2, subsetcol1:subsetcol2);
n1 = height(dem_extract)-1;
n2 = width(dem_extract)-1;
slope_matrix = [height(dem_extract)-2, width(dem_extract)-2];
for i = 2:n1
    for j = 2:n2
        dz_dx = (dem_extract(i,j+1) - dem_extract(i,j-1))/(2*res_dem);
        dz_dy = (dem_extract(i-1,j) - dem_extract(i+1,j))/(2*res_dem);
        slope = sqrt(dz_dx^2 + dz_dy^2);
        slope_matrix(i-1, j-1) = slope;
    end 
end
Result = slope_matrix;
end