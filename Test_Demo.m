%% Test the model performance for trained D-CNN
clear
clc
addpath('DataSet_I')
addpath('Trained_Models/D-CNN')
addpath('CNN')
addpath('util')
load('TestSet.mat')
load('D-CNN.mat')

% Form feature Matrix
l = size(TestSet,2);
TestSet_x = TestSet(:,1:l-23);
TestSet_y = TestSet(:,l-22:l-3);
TestSet_x2 = reshape(TestSet_x',8,9,size(TestSet_x,1));
TestSet_y2 = TestSet_y';

% Obtain estimation result
res = cnnff(cnn,TestSet_x2);
output = res.o;
err = output'-TestSet_y2';

%% Plot performance of the D-CNN model
k = size(TestSet_y2,2);
r = floor(k*rand(1));

figure
stairs(TestSet_y2(:,r),'linewidth',3)
hold on
stairs(output(:,r),'linewidth',3)
axis([1,20,-0.1,1.1])
set(gcf,'color','white')
set(gca,'linewidth',2,'fontsize',15,'fontname','Times');
xlabel('Segment number','Fontname', 'Times New Roman','FontSize',18)
ylabel('Aging probability','Fontname', 'Times New Roman','FontSize',18)
grid on
legend_str = {'Real','By D-CNN'};
legend(legend_str,'FontSize',18)

%% Precision analysis
output_p = zeros(size(output));
for i = 1:size(output_p,1)
    for j = 1:size(output_p,2)
        if(output(i,j) > 0.5)
            output_p(i,j) = 1;
        end
    end
end
err2 = output_p'-TestSet_y2';
precision = 1-mean(abs(err2));

figure
plot(precision,'linewidth',3)
hold on
plot(ones(1,20)*mean(precision),'--','linewidth',3)
axis([1,20,0.5,1])
set(gcf,'color','white')
set(gca,'linewidth',2,'fontsize',15,'fontname','Times');
xlabel('Segment number','Fontname', 'Times New Roman','FontSize',18)
ylabel('\it Pre_L','Fontname', 'Times New Roman','FontSize',18)
grid on

%% Analyze the precision under different ageing severities
k1 = 0;
k2 = 0;
k3 = 0;
for i = 1:size(output_p,2)
    if ((TestSet(i,l-1)-TestSet(i,l-2))*TestSet(i,l) <= 0.02)
        k1 = k1+1;
        out1(k1,:) = output_p(:,i)';
        Test1(k1,:) = TestSet_y(i,:);
    elseif ((TestSet(i,l-1)-TestSet(i,l-2))*TestSet(i,l) >= 0.18)
        k3 = k3+1;
        out3(k3,:) = output_p(:,i)';
        Test3(k3,:) = TestSet_y(i,:);
    else
        k2 = k2+1;
        out2(k2,:) = output_p(:,i)';
        Test2(k2,:) = TestSet_y(i,:);
    end
end

err_light = out1'-Test1';
err_medium = out2'-Test2';
err_serious = out3'-Test3';
precision_light = 1-mean(abs(err_light'));
precision_medium = 1-mean(abs(err_medium'));
precision_serious = 1-mean(abs(err_serious'));

figure
plot(precision,'linewidth',3)
hold on
plot(ones(1,20)*mean(precision),'--','linewidth',3)
plot(precision_light,'linewidth',3)
plot(precision_medium,'linewidth',3)
plot(precision_serious,'linewidth',3)
axis([1,20,0.5,1])
set(gcf,'color','white')
set(gca,'linewidth',2,'fontsize',15,'fontname','Times');
xlabel('Segment number','Fontname', 'Times New Roman','FontSize',18)
ylabel('\it Pre_L','Fontname', 'Times New Roman','FontSize',18)
grid on
legend('Overall','Average','Lightly aged','Medium aged','Seriously aged')