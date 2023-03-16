function X=DCT4D(x)
% it is the implementation of Eq1 in the paper
N=size(x,1);
X=zeros(N,N,N,N);
% straigh-forward 3d-DCT
for k1=0:N-1
    for k2=0:N-1
        for k3=0:N-1
            for k4=0:N-1
                sm=0;            
                for n1=0:N-1
                    for n2=0:N-1
                        for n3=0:N-1
                            for n4=0:N-1
                                sm=sm+x(n1+1,n2+1,n3+1,n4+1)*cos(pi/(2*N)*(2*n1+1)*k1)*...
                                    cos(pi/(2*N)*(2*n2+1)*k2)*cos(pi/(2*N)*(2*n3+1)*k3)*...
                                    cos(pi/(2*N)*(2*n4+1)*k4);
                            end
                        end
                    end
                end
                X(k1+1,k2+1,k3+1,k4+1)=4/(N^2)*sm*myK(k1)*myK(k2)*myK(k3)*myK(k4);  
            end
        end
    end
end