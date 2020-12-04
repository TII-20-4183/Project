%% Test the model performance for trained L-CNN
clear
clc
addpath('DataSet_II')
addpath('Trained_Models/L-CNN')
addpath('CNN')
addpath('util')
load('TestSet.mat')
load('L-CNN.mat')

% Form feature Matrix
l = size(TestSet,2);
TestSet_x = TestSet(:,1:l-23);
TestSet_y = TestSet(:,l-2:end);
TestSet_x2 = reshape(TestSet_x',8,9,size(TestSet_x,1));
TestSet_y2 = TestSet_y';

% Obtain estimation result
res = cnnff(cnn,TestSet_x2);
output = res.o;
err = output'-TestSet_y2';
mean(mean(abs(err).^2))
MRE1 = mean(abs(err(:,1)));
MRE2 = mean(abs(err(:,2)));
MRE3 = mean(abs(err(:,3)./(1+TestSet_y2(3,:))'));

%% Plot performance of the L-CNN model
%x = 1;
y = [MRE1;MRE2;MRE3];
b = bar(y);
grid on
set(gcf,'color','white')
set(gca,'linewidth',2,'fontsize',15,'fontname','Times');
xlabel('L-CNN','Fontname', 'Times New Roman','FontSize',18)
ylabel('MRE','Fontname', 'Times New Roman','FontSize',18)
grid on
legend_str = {'\it L_b','\it L_e','\it gamma'};
legend(legend_str,'FontSize',18)

%% Analyze the precision under different ageing severities
k1 = 0;
k2 = 0;
k3 = 0;
for i = 1:size(output,2)
    if ((TestSet(i,l-1)-TestSet(i,l-2))*TestSet(i,l) <= 0.02)
        k1 = k1+1;
        out1(k1,:) = output(:,i)';
        Test1(k1,:) = TestSet_y(i,:);
    elseif ((TestSet(i,l-1)-TestSet(i,l-2))*TestSet(i,l) >= 0.18)
        k3 = k3+1;
        out3(k3,:) = output(:,i)';
        Test3(k3,:) = TestSet_y(i,:);
    else
        k2 = k2+1;
        out2(k2,:) = output(:,i)';
        Test2(k2,:) = TestSet_y(i,:);
    end
end

err1 = out1-Test1;
err1(:,3) = err1(:,3)./(1+Test1(:,3));
err2 = out2-Test2;
err2(:,3) = err2(:,3)./(1+Test2(:,3));
err3 = out3-Test3;
err3(:,3) = err3(:,3)./(1+Test3(:,3));
MRE1 = mean(abs(err1));
MRE2 = mean(abs(err2));
MRE3 = mean(abs(err3));

figure
y = [MRE1;MRE2;MRE3];
b = bar(y);
grid on
set(gcf,'color','white')
set(gca,'linewidth',2,'fontsize',15,'fontname','Times');
xlabel('Ageing severity','Fontname', 'Times New Roman','FontSize',18)
ylabel('MRE','Fontname', 'Times New Roman','FontSize',18)
grid on
legend_str = {'\it L_b','\it L_e','\it gamma'};
legend(legend_str,'FontSize',18)
% Ageing severity = 1 indicates lightly aged
% Ageing severity = 2 indicates medium aged
% Ageing severity = 3 indicates seriously aged
