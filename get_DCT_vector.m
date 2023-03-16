function DCT_vector = get_DCT_vector(DCT)
DCT = DCT;
[u,v,s,t] = size(DCT);
num = 1;
DCT_vector = zeros(u*v*s*t,1);
for uu = 1:u
    for vv = 1:v
        for ss = 1:s
                DCT_vector(num:num+t-1,1) = squeeze(DCT(uu,vv,ss,:));
                num = num+t;
        end
    end
end