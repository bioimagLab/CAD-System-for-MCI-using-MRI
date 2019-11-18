function skull_stripping(sdirectory, sdirectorym)

tifFiles = dir([sdirectory '\*.nii']);
tifFilesm = dir([sdirectorym '\*.nii']);
for sbgt = 1:length(tifFiles)

% Read the volume
filename = [sdirectory '\' tifFiles(sbgt).name];
filenamem = [sdirectorym '\' tifFilesm(sbgt).name];
l=spm_vol(filename);
l2=spm_read_vols(l);
lm=spm_vol(filenamem);
l2m=spm_read_vols(lm);

% Use the Volume's corresponding mask to strip the skull
l2(l2m==0)=0;

% Write the skull stripped volume
spm_write_vol(l,l2);
end
end
