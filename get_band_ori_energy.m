function [band_energy,ori_energy] = get_band_ori_energy(vector,N)
energyPatch4D = reshape(vector,[N,N,N,N]);
num = 0;
energy11 = [];
energy12 = [];
energy13 = [];
energy21 = [];
energy22 = [];
energy23 = [];
energy31 = [];
energy32 = [];
energy33 = [];
ori_energy11 = [];
ori_energy12 = [];
ori_energy13 = [];
ori_energy21 = [];
ori_energy22 = [];
ori_energy23 = [];
ori_energy31 = [];
ori_energy32 = [];
ori_energy33 = [];
for u = 1:N
    for v = 1:N
        for s = 1:N
            for t = 1:N
                %排除DC
                if u == 1&&v==1&&s==1&&t==1
                    continue;
                end
                %子带能量
                if (u+v)<=4
                    if (s+t)<=4
                        energy11 = [energy11 energyPatch4D(u,v,s,t)];
                    elseif ((s+t)<=6&&(s+t)>4)
                        energy12 = [energy12 energyPatch4D(u,v,s,t)];
                    elseif (s+t)>=7
                        energy13 = [energy13 energyPatch4D(u,v,s,t)];
                    end
                elseif (u+v)>=5&&(u+v)<=6
                    if (s+t)<=4
                        energy21 = [energy21 energyPatch4D(u,v,s,t)];
                    elseif ((s+t)<=6&&(s+t)>4)
                        energy22 = [energy22 energyPatch4D(u,v,s,t)];
                    elseif (s+t)>=7
                        energy23 = [energy23 energyPatch4D(u,v,s,t)];
                    end
                elseif (u+v)>=7
                    if (s+t)<=4
                        energy31 = [energy31 energyPatch4D(u,v,s,t)];
                    elseif ((s+t)<=6&&(s+t)>4)
                        energy32 = [energy32 energyPatch4D(u,v,s,t)];
                    elseif (s+t)>=7
                        energy33 = [energy33 energyPatch4D(u,v,s,t)];
                    end
                end
                %方向能量
                if u == v
                    if s == t
                        ori_energy22 = [ori_energy22 energyPatch4D(u,v,s,t)];
                    elseif s > t
                        ori_energy21 = [ori_energy21 energyPatch4D(u,v,s,t)];
                    elseif t > s
                        ori_energy23 = [ori_energy23 energyPatch4D(u,v,s,t)];
                    end
                elseif u > v
                    if s == t
                        ori_energy12 = [ori_energy12 energyPatch4D(u,v,s,t)];
                    elseif s > t
                        ori_energy11 = [ori_energy11 energyPatch4D(u,v,s,t)];
                    elseif t > s
                        ori_energy13 = [ori_energy13 energyPatch4D(u,v,s,t)];
                    end  
                elseif u < v 
                    if s == t
                        ori_energy32 = [ori_energy32 energyPatch4D(u,v,s,t)];
                    elseif s > t
                        ori_energy31 = [ori_energy31 energyPatch4D(u,v,s,t)];
                    elseif t > s
                        ori_energy33 = [ori_energy33 energyPatch4D(u,v,s,t)];
                    end
                end
            end
        end
    end
end
band_energy = [mean(energy11) mean(energy12) mean(energy13) mean(energy21) mean(energy22) mean(energy23) mean(energy31) mean(energy32) mean(energy33)];
ori_energy = [mean(ori_energy11) mean(ori_energy12) mean(ori_energy13) mean(ori_energy21) mean(ori_energy22) mean(ori_energy23) mean(ori_energy31) mean(ori_energy32) mean(ori_energy33)];
