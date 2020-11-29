%% Data_Generation I
% for even and terminal ageing samples
clear
clc
L = 10000;
L1_ins_ratio = 0:0.05:1;
N = 20;
L1_ins = L*L1_ins_ratio;
L2_ins = L1_ins;
epsilon_0 = 8.86e-12;
epsilon_1 = 2.46;
epsilon_2 = 2.46*(1.01:0.01:1.5);

% TF measurements generation
f_max = 500000;
f_ins = 3000:1000:f_max;
rc = 11.45e-3;
rin = 15.95e-3;
rs = 17.95e-3;
miu_0 = 4*pi*1e-7;
rho_c = 0.0172e-6;
rho_s = rho_c;
YL = 0; % Load admittance

k = 0;
for i = 1:length(L1_ins)
    for j = 1:length(L2_ins)
        for j2 = 1:length(epsilon_2)
            if (L2_ins(j) > L1_ins(i))
                k = k+1
                for t = 1:length(f_ins)
                    f = f_ins(t);
                    Zc = 1/2/pi/rc*sqrt(1j*2*pi*f*miu_0*rho_c)+1j*2*pi*f*miu_0/2/pi*log(rs/rc)+1/2/pi/rs*sqrt(1j*2*pi*f*miu_0*rho_s);
                    Yin_1 = 1j*2*pi*f*2*pi/log(rin/rc)*epsilon_0*epsilon_1;
                    Yin_2 = 1j*2*pi*f*2*pi/log(rin/rc)*epsilon_0*epsilon_2(j2);
    
                    ZcT = eye(3,3)*Zc;
                    Yin_1T = eye(3,3)*Yin_1;
                    Yin_2T = eye(3,3)*Yin_2;
                    [H_temp1,Yin1] = DModel(ZcT,Yin_1T,-(L-L2_ins(j)),YL);
                    [H_temp2,Yin2] = DModel(ZcT,Yin_2T,-(L2_ins(j)-L1_ins(i)),Yin1);
                    [H_temp3,Yin3] = DModel(ZcT,Yin_1T,-L1_ins(i),Yin2);
                    Htotal = H_temp1*H_temp2*H_temp3;
                    H_sample(k,t) = abs(Htotal(1,1));
                end
                
                for t2 = 1:N
                    if ((L/N*t2-L/N/2) > L1_ins(i)) && ((L/N*t2-L/N/2) < L2_ins(j))
                        H_sample(k,t+t2) = 1;
                    else
                        H_sample(k,t+t2) = 0;
                    end
                end
                
                H_sample(k,t+N+1) = L1_ins(i);
                H_sample(k,t+N+2) = L2_ins(j);
                H_sample(k,t+N+3) = epsilon_2(j2);
            end
        end
    end
end

%% Plot a typical TF spectrum
figure
k = size(H_sample,1);
r = floor(k*rand(1));
plot(f_ins,H_sample(1,1:length(f_ins)),'linewidth',2)

set(gcf,'color','white')
set(gca,'linewidth',2,'fontsize',15,'fontname','Times');
xlabel('\itf\rm(Hz)','Fontname', 'Times New Roman','FontSize',18)
ylabel('\itH_{abs}','Fontname', 'Times New Roman','FontSize',18)
grid on