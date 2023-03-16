function feat = wbl_shape(vector)
vector = abs(vector);
vector(vector == 0) = 0.00001; 
[a,~] = wblfit(abs(vector));
feat = [a(1)];