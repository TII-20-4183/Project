function fcnn = Fine_tuning(cnn,TestSet)
% Transfer learning based on fine tuning
res = cnnff(cnn,TestSet);

temp_input = res.fv;
temp_input = temp_input';
fcnn = nnsetup([size(temp_input,2),size(TestSety22,2)]);
opts.numepochs =  5000;   
opts.batchsize = 100;  
opts.plot = 1;
fcnn = nntrain(fcnn,temp_input,TestSet,opts);