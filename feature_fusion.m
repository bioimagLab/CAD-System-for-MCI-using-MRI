function feature_fusion

% Load features' files of the tested groups
load two_cortex_aal_sMRI_NC_features.mat;
load two_cortex_aal_sMRI_MCI_features.mat;
% Determine the size of the tested groups
NC=size(cortex_sMRI_NC_features,1);
MCI=size(cortex_sMRI_MCI_features,1);
% Define the targeted regions' indices
Cregions=[1:8 13:16 23:25 27:35 37 39 43 47 50 53:81 83 85:89 91:101 103 105:108 112:114];
% Prepare and normalize the extracted features
for i=1:NC
for j=1:size(Cregions,2)
eval(sprintf('all_NC_mcurv%d(i,1:size(cortex_sMRI_NC_features{i,Cregions(j)}{1,1},2))=[cortex_sMRI_NC_features{i,Cregions(j)}{1,1}];',Cregions(j)));
eval(sprintf('all_NC_gcurv%d(i,1:size(cortex_sMRI_NC_features{i,Cregions(j)}{1,2},2))=[cortex_sMRI_NC_features{i,Cregions(j)}{1,2}];',Cregions(j)));
eval(sprintf('all_NC_curvedness%d(i,1:size(cortex_sMRI_NC_features{i,Cregions(j)}{1,3},2))=[cortex_sMRI_NC_features{i,Cregions(j)}{1,3}];',Cregions(j)));
eval(sprintf('all_NC_sharpness%d(i,1:size(cortex_sMRI_NC_features{i,Cregions(j)}{1,4},2))=[cortex_sMRI_NC_features{i,Cregions(j)}{1,4}];',Cregions(j)));
eval(sprintf('all_NC_volume%d(i,1:size(cortex_sMRI_NC_features{i,Cregions(j)}{1,5},2))=[cortex_sMRI_NC_features{i,Cregions(j)}{1,5}];',Cregions(j)));
end
end
for i=1:MCI
for j=1:size(Cregions,2)
eval(sprintf('all_MCI_mcurv%d(i,1:size(cortex_sMRI_MCI_features{i,Cregions(j)}{1,1},2))=[cortex_sMRI_MCI_features{i,Cregions(j)}{1,1}];',Cregions(j)));
eval(sprintf('all_MCI_gcurv%d(i,1:size(cortex_sMRI_MCI_features{i,Cregions(j)}{1,2},2))=[cortex_sMRI_MCI_features{i,Cregions(j)}{1,2}];',Cregions(j)));
eval(sprintf('all_MCI_curvedness%d(i,1:size(cortex_sMRI_MCI_features{i,Cregions(j)}{1,3},2))=[cortex_sMRI_MCI_features{i,Cregions(j)}{1,3}];',Cregions(j)));
eval(sprintf('all_MCI_sharpness%d(i,1:size(cortex_sMRI_MCI_features{i,Cregions(j)}{1,4},2))=[cortex_sMRI_MCI_features{i,Cregions(j)}{1,4}];',Cregions(j)));
eval(sprintf('all_MCI_volume%d(i,1:size(cortex_sMRI_MCI_features{i,Cregions(j)}{1,5},2))=[cortex_sMRI_MCI_features{i,Cregions(j)}{1,5}];',Cregions(j)));
end
end
for j=1:size(Cregions,2)
to_max = 1;
to_min = 0;
eval(sprintf('all_mcurv%d(1:NC,1:size(all_NC_mcurv%d,2))=all_NC_mcurv %d;',Cregions(j),Cregions(j),Cregions(j)));
eval(sprintf('all_mcurv%d(NC+1:NC+MCI,1:size(all_MCI_mcurv%d,2))=all_MCI_mcurv%d;',Cregions(j),Cregions(j),Cregions(j)));
eval(sprintf('all_mcurv%d_from_min=min(min(all_mcurv%d));',Cregions(j),Cregions(j)));
eval(sprintf('all_mcurv%d_from_max=max(max(all_mcurv%d));',Cregions(j),Cregions(j)));
eval(sprintf('all_mcurv%dn=(all_mcurv%d - all_mcurv%d_from_min) * (to_max - to_min) / (all_mcurv%d_from_max - all_mcurv%d_from_min) + to_min;',Cregions(j),Cregions(j),Cregions(j),Cregions(j),Cregions(j)));

eval(sprintf('all_gcurv%d(1:NC,1:size(all_NC_gcurv%d,2))=all_NC_gcurv %d;',Cregions(j),Cregions(j),Cregions(j)));
eval(sprintf('all_gcurv%d(NC+1:NC+MCI,1:size(all_MCI_gcurv%d,2))=all_MCI_gcurv %d;',Cregions(j),Cregions(j),Cregions(j)));
eval(sprintf('all_gcurv%d_from_min=min(min(all_gcurv%d));',Cregions(j),Cregions(j)));
eval(sprintf('all_gcurv%d_from_max=max(max(all_gcurv%d));',Cregions(j),Cregions(j)));
eval(sprintf('all_gcurv%dn=(all_gcurv%d - all_gcurv%d_from_min) * (to_max - to_min) / (all_gcurv%d_from_max - all_gcurv%d_from_min) + to_min;',Cregions(j),Cregions(j),Cregions(j),Cregions(j),Cregions(j)));

eval(sprintf('all_curvedness%d(1:NC,1:size(all_NC_curvedness%d,2))=all_NC_curvedness%d;',Cregions(j),Cregions(j),Cregions(j)));
eval(sprintf('all_curvedness%d(NC+1:NC+MCI,1:size(all_MCI_curvedness %d,2))=all_MCI_curvedness%d;',Cregions(j),Cregions(j),Cregions(j)));
eval(sprintf('all_curvedness%d_from_min=min(min(all_curvedness%d));',Cregions(j),Cregions(j)));
eval(sprintf('all_curvedness%d_from_max=max(max(all_curvedness%d));',Cregions(j),Cregions(j)));
eval(sprintf('all_curvedness%dn=(all_curvedness%d - all_curvedness%d_from_min) * (to_max - to_min) / (all_curvedness%d_from_max - all_curvedness%d_from_min) + to_min;',Cregions(j),Cregions(j),Cregions(j),Cregions(j),Cregions(j)));

eval(sprintf('all_sharpness%d(1:NC,1:size(all_NC_sharpness%d,2))=all_NC_sharpness%d;',Cregions(j),Cregions(j),Cregions(j)));
eval(sprintf('all_sharpness%d(NC+1:NC+MCI,1:size(all_MCI_sharpness%d,2))=all_MCI_sharpness%d;',Cregions(j),Cregions(j),Cregions(j)));
eval(sprintf('all_sharpness%d_from_min=min(min(all_sharpness%d));',Cregions(j),Cregions(j)));
eval(sprintf('all_sharpness%d_from_max=max(max(all_sharpness%d));',Cregions(j),Cregions(j)));
eval(sprintf('all_sharpness%dn=(all_sharpness%d - all_sharpness%d_from_min) * (to_max - to_min) / (all_sharpness%d_from_max - all_sharpness%d_from_min) + to_min;',Cregions(j),Cregions(j),Cregions(j),Cregions(j),Cregions(j)));

eval(sprintf('all_volume%d(1:NC,1:size(all_NC_volume%d,2))=all_NC_volume%d;',Cregions(j),Cregions(j),Cregions(j)));
eval(sprintf('all_volume%d(NC+1:NC+MCI,1:size(all_MCI_volume%d,2))=all_MCI_volume%d;',Cregions(j),Cregions(j),Cregions(j)));
eval(sprintf('all_volume%d_from_min=min(min(all_volume%d));',Cregions(j),Cregions(j)));
eval(sprintf('all_volume%d_from_max=max(max(all_volume%d));',Cregions(j),Cregions(j)));
eval(sprintf('all_volume%dn=(all_volume%d - all_volume%d_from_min) * (to_max - to_min) / (all_volume%d_from_max - all_volume%d_from_min) + to_min;',Cregions(j),Cregions(j),Cregions(j),Cregions(j),Cregions(j)));
% Save each original feature alone for the two tested groups
eval(sprintf('save two_all_mcurv%d all_mcurv%d',Cregions(j),Cregions(j)));
eval(sprintf('save two_all_gcurv%d all_gcurv%d',Cregions(j),Cregions(j)));
eval(sprintf('save two_all_curvedness%d all_curvedness%d',Cregions(j),Cregions(j)));
eval(sprintf('save two_all_sharpness%d all_sharpness%d',Cregions(j),Cregions(j)));
eval(sprintf('save two_all_sharpness%d all_volume%d',Cregions(j),Cregions(j)));

% Save each normalized feature alone for the two tested groups
eval(sprintf('save two_all_mcurv%dn all_mcurv%dn',Cregions(j),Cregions(j)));
eval(sprintf('save two_all_gcurv%dn all_gcurv%dn',Cregions(j),Cregions(j)));
eval(sprintf('save two_all_curvedness%dn all_curvedness%dn',Cregions(j),Cregions(j)));
eval(sprintf('save two_all_sharpness%dn all_sharpness%dn',Cregions(j),Cregions(j)));
eval(sprintf('save two_all_volume%dn all_volume%dn',Cregions(j),Cregions(j)));
end

% Feature fusion using CCA technique
for i=1:size(Cregions,2)
eval(sprintf('[trainZ1%d,testZ1%d] = ccaFuse(all_mcurv%dn, all_gcurv%dn, all_mcurv%dn, all_gcurv%dn, ''sum'');',Cregions(i),Cregions(i),Cregions(i),Cregions(i),Cregions(i),Cregions(i)));
eval(sprintf('[trainZ2%d,testZ2%d] = ccaFuse(trainZ1%d, all_curvedness%dn, trainZ1%d, all_curvedness%dn, ''sum'');',Cregions(i),Cregions(i),Cregions(i),Cregions(i),Cregions(i),Cregions(i)));
eval(sprintf('[trainZ3%d,testZ3%d] = ccaFuse(trainZ2%d, all_sharpness%dn, trainZ2%d, all_sharpness%dn, ''sum'');',Cregions(i),Cregions(i),Cregions(i),Cregions(i),Cregions(i),Cregions(i)));
eval(sprintf('[trainZ%d,testZ%d] = ccaFuse(trainZ3%d, all_volume%dn, trainZ3%d, all_volume%dn, ''sum'');',Cregions(i),Cregions(i),Cregions(i),Cregions(i),Cregions(i),Cregions(i)));
eval(sprintf(' save fused_all_features_norm%d trainZ%d',Cregions(i),Cregions(i)));
end
end
