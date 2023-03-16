function E = getEnergy(vector)
I = vector;
E = mean(log2((I + 0.0000001).^2));