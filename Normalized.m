function [Sample,Target] = Normalized(H_sample)
% Normalize function for the TF measurements
% H_Sample represents the TF measurements under even, terminal or uneven
% situations

f_max = 500000;
f_ins = 3000:1000:f_max;

Target = H_sample(:,length(f_ins)+1:end);
Sample = H_sample(:,1:length(f_ins));
addpath('Intact_TF_Measurement')
load Intact_TF_Measurement.mat

for i = 1:size(Sample,1)
    Sample(i,:) = Sample(i,:)-H_sample(1,1:length(f_ins));
end
miu = sum(Sample)/size(Sample,1);
sig = sum(Sample.^2)/size(Sample,1);
Sample = Sample-miu./sqrt(sig);