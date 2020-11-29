function FeatureSet = Feature_Set_Generation(sae_net1,sae_net2,Sample,Target)
% Generate FeatureSet using the trained SAEs and the normalized samples

Feature1 = nnff(sae_net1.ae{1},Sample,Sample);
Feature2 = nnff(sae_net2.ae{1},-Sample,-Sample);
FeatureSet1 = Feature1.a{2}(:,2:end);
FeatureSet2 = Feature2.a{2}(:,2:end);
FeatureSet = FeatureSet1-FeatureSet2;
FeatureSet = [FeatureSet,Target];

% Normalize of the outputs
l = size(FeatureSet,2);
L = 10000;
epsilon = 2.46;
FeatureSet(:,l-2) = FeatureSet(:,l-2)/L;
FeatureSet(:,l-1) = FeatureSet(:,l-1)/L;
FeatureSet(:,l) = (FeatureSet(:,l)-epsilon)/epsilon;

