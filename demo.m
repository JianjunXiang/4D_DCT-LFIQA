clc; clear;
close;
load principleVectors; % projection Matrix
load feat_mu; % the mean of test features;
lfiDir = dir('./rosemary/*.bmp');
sai_num = length(lfiDir);
patchSize = 4;
for k = 1:sai_num
    saiColor = imread([lfiDir(k).folder,'/',lfiDir(k).name]);
    saiGray  = double(rgb2gray(saiColor));
   if mod(k,9) == 0
      aa = floor(k/9);
      bb = 9;
   else
      aa = floor(k/9)+1;
      bb = mod(k,9);
   end
   LF4D(aa,bb,:,:) = saiGray;
end
%calculate sub-aperture graident image array
[u,v,s,t] = size(LF4D);
for uu = 1:u-1
    for vv = 1:v-1
        %horzontal
        Gx = squeeze(LF4D(uu,vv,:,:))-squeeze(LF4D(uu,vv+1,:,:));
        %vertical
        Gy = squeeze(LF4D(uu,vv,:,:))-squeeze(LF4D(uu+1,vv,:,:));
        %GMMap
        GMmap = sqrt(Gx.^2+Gy.^2);
        LF4DMap(uu,vv,:,:) = GMmap;
    end
end
u = u-1;
v = v-1;
s = (floor(s/8))*8;
t = (floor(t/8))*8;
num = 0;
% generate 4D-DCT coefficients
for uu = 1:4:u
    for vv = 1:4:v
        for ss = 1:4:s
            for tt = 1:4:t
                num = num + 1;
                DC4DCT = DCT4D(LF4DMap(uu:uu+3,vv:vv+3,ss:ss+3,tt:tt+3));
                oneCubeDCTCoff = get_DCT_vector(DC4DCT);
                interCoff(:,num) = oneCubeDCTCoff;
            end
        end
    end
end
interCoffNum = size(interCoff,1);
% calculate features at the same position of all blocks
for nn = 1:interCoffNum
      interEnergy(nn) = getEnergy(interCoff(nn,:));
      interWbl(nn) = wbl_shape(interCoff(nn,:));
end
[bandEnergy,oriEnergy] = get_band_ori_energy(interEnergy,patchSize);
interWbl = interWbl(2:end);
% PCA
reducedFeat = (interWbl - feat_mu) * principleVectors;
feat = [reducedFeat(:,1:40), bandEnergy, oriEnergy];