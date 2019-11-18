clear all
clc
warning off
% Skull_stripping of the scans
% Pass the directory of the original scans as the first parameter sdirectory and the directory of the scans' equivalent masks as the second parameter sdirectorym 
function skull_stripping(sdirectory, sdirectorym)

% Pre-precossing was applied using SPM toolbox
%SPM path for preprocessing of the scans
addpath ..\MATLAB\spm12

% Cortex segmentation and cortex analysis
% Note: use the smri_feature_extraction function once for the NC and the other for the MCI scans
NC_sdirectory = ''; % Pass the path of the preprocessed NC scans
smri_feature_extraction(NC_sdirectory)
MCI_sdirectory = ''; % Pass the path of the preprocessed MCI scans
% Note: please read the comment at the end of the smri_feature_extraction to see how to name the output features file of the MCI subjects
smri_feature_extraction(MCI_sdirectory)

% Feature fusion
Feature_fusion

% Diagnosis
diagnosis

