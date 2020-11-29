function [H,Yin] = DModel(Z,Y,L,YL)
n = size(Z,1);
[T,lamda] = eig(Y*Z);
Tao = sqrt(lamda);
Zc = Y\T*Tao/T;
Yc = inv(Zc);
rho = T\Yc*inv(Yc+YL)*(YL-Yc)*Zc*T;
E_plus = zeros(n,n);
E_minus = zeros(n,n);
for i = 1:n
    E_plus(i,i) = exp(Tao(i,i)*L);
    E_minus(i,i) = exp(-Tao(i,i)*L);
end
Yin = T*(E_minus+E_plus*rho)*inv(E_minus-E_plus*rho)*inv(T)*Yc;
H = Zc*T*(eye(n,n)-rho)*inv(E_minus-E_plus*rho)*inv(T)*Yc;