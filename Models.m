%% SAE Training
clear
clc
addpath('NN')

% Sample represents the normalized TF measurement data for the training
Sample1 = Sample; 
Sample2 = -Sample;
n_hidden = 72;
sae_net1 = saesetup([length(f_ins),n_hidden]); % For positive part reconstruction
sae_net2 = saesetup([length(f_ins),n_hidden]); % For negative part reconstruction
opts.numepochs =  50;
opts.batchsize = 300;
opts.plot = 1;
sae_net1 = saetrain(sae_net1,Sample1,opts);
sae_net2 = saetrain(sae_net2,Sample2,opts);
save sae_net1
save sae_net2

%% D-CNN Training
clear
clc
addpath('CNN')

% TrainSet represents the generated featrue matrix for training
l = size(TrainSet,2); 
TrainSet_x = TrainSet(:,1:l-23);
TrainSet_y = TrainSet(:,l-22:l-3);
TrainSet_x2 = reshape(TrainSet_x',8,9,size(TrainSet_x,1));
TrainSet_y2 = TrainSet_y';

rand('state',0)

cnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 6, 'kernelsize', 3) %convolution layer
    struct('type', 's', 'scale', 1) %sub sampling layer
    struct('type', 'c', 'outputmaps', 8, 'kernelsize', 2) %convolution layer
    struct('type', 's', 'scale', 1) %sub sampling layer
};

opts.alpha = 2;
opts.batchsize = 100;
opts.numepochs = 5000;

cnn = cnnsetup(cnn, TrainSet_x2, TrainSet_y2);
cnn = cnntrain(cnn, TrainSet_x2, TrainSet_y2, opts);

%% L-CNN Training
clear
clc
addpath('CNN')

% TrainSet represents the generated featrue matrix for training
l = size(TrainSet,2); 
TrainSet_x = TrainSet(:,1:l-23);
TrainSet_y = TrainSet(:,l-2:end);
TrainSet_x2 = reshape(TrainSet_x',8,9,size(TrainSet_x,1));
TrainSet_y2 = TrainSet_y';

rand('state',0)

cnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 6, 'kernelsize', 3) %convolution layer
    struct('type', 's', 'scale', 1) %sub sampling layer
    struct('type', 'c', 'outputmaps', 8, 'kernelsize', 2) %convolution layer
    struct('type', 's', 'scale', 1) %sub sampling layer
};

opts.alpha = 2;
opts.batchsize = 100;
opts.numepochs = 5000;

cnn = cnnsetup(cnn, TrainSet_x2, TrainSet_y2);
cnn = cnntrain(cnn, TrainSet_x2, TrainSet_y2, opts);