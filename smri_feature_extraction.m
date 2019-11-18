function smri_feature_extraction(sdirectory)


% Read the skull stripped volume and segment the cortex
tifFiles = dir([sdirectory '\*.nii']);
for sbgt = 1:length(tifFiles)
filename = [sdirectory '\' tifFiles(sbgt).name];
 [cor, intensity, cor_singlecolumn,M,DIM,TF,df] = mask2coord(filename);

%% Normalization
from_min = min(min(min(intensity)));
from_max = max(max(max(intensity)));
to_max = 255;
to_min = 0;
to_range=to_max - to_min;
from_range=from_max - from_min;
intensity=(intensity - from_min) * (to_max - to_min) / (from_max - from_min) + to_min;

%% Cortex segmentation
mni = cor2mni(cor, M);
X=load('TDdatabase');
handles.DB = X.DB;
[x,y]=cuixuFindStructure(mni, handles.DB);
u=unique(y(:,1));
comp=strcmp(y(:,1),u(4));
for j=1:size(comp,1)
if comp(j)==1
label(cor(j,1),cor(j,2),cor(j,3))=1;
label_int(cor(j,1),cor(j,2),cor(j,3))=intensity(j);
end
end
comp2=strcmp(y(:,1),u(7));
for j=1:size(comp2,1)
if comp2(j)==1
label(cor(j,1),cor(j,2),cor(j,3))=1;
label_int(cor(j,1),cor(j,2),cor(j,3))=intensity(j);
end
end
for lsize=1:size(u,1)-1    eval(sprintf('label%d_int=zeros(size(label,1)+100,size(label,2)+100,size(label,3)+100);',lsize));
end
labi=1;
for i=1:size(label,1)
for ii=1:size(label,2)
for iii=1:size(label,3)
if label(i,ii,iii)==labi
eval(sprintf('label%d_int(i,ii,iii)=label_int(i,ii,iii);',labi));
end
end
end
end

% Feature extraction
eval(sprintf('isoval%d = isovalue(label%d_int)',labi,labi));
eval(sprintf('if (isoval%d <0) isoval%d=0; end',labi,labi));
eval(sprintf('[nX%d,nY%d,nZ%d] = size(label%d_int);',labi,labi,labi,labi));
eval(sprintf('[X%d,Y%d,Z%d] = meshgrid(1:nY%d,1:nX%d,1:nZ%d);',labi,labi,labi,labi,labi,labi));
eval(sprintf('[F%d,V%d,col%d] = MarchingCubes(X%d,Y%d,Z%d,label%d_int,isoval%d);',labi,labi,labi,labi,labi,labi,labi,labi));

%% Calculate the volume
eval(sprintf('[Volume%d] =sVolume(V%d,F%d);',labi,labi,labi));

%% Calculate the curvatures% eval(sprintf('FV%d.vertices=V%d;',labi,labi));
%eval(sprintf('FV%d.faces=F%d;',labi,labi));
eval(sprintf('[Cmean%d,Cgaussian%d,Dir1_%d,Dir2_%d,Lambda1_%d,Lambda2_%d]=patchcurvature(FV%d,true);',labi,labi,labi,labi,labi,labi,labi));
eval(sprintf('curvedness%d=sqrt(((Lambda1_%d).^2+(Lambda2_%d).^2)/2);',labi,labi,labi));
eval(sprintf('sharpness%d=(Lambda1_%d-Lambda2_%d).^2;',labi,labi,labi));
eval(sprintf('V=int8(V%d);',labi));
f=find(V(:,1)>max(cor(:,1)));
V(f,1)=max(cor(:,1));
f2=find(V(:,2)>max(cor(:,2)));
V(f2,2)=max(cor(:,2));
f3=find(V(:,3)>max(cor(:,3)));
V(f3,3)=max(cor(:,3));
[r ind]=ismember(V,cor,'rows');
indy=y(ind,:);
u2=unique(y(:,5));
for i2=1:size(u2,1)-1
comp=strcmp(indy(:,5),u2(i2));
for j=1:size(comp,1)
if comp(j)==1
regions_ind(i2)=i2;
eval(sprintf('label%d_Cmean=Cmean%d(comp);',i2,labi));
eval(sprintf('label%d_Gauss=Cgaussian%d(comp);',i2,labi));
eval(sprintf('label%d_curvedness=curvedness%d(comp);',i2,labi));
eval(sprintf('label%d_sharpness=sharpness%d(comp);',i2,labi));
eval(sprintf('label%d_volume=Volume%d(comp);',i2,labi));
end
end
end
f=find(regions_ind==0);
regions_ind(f)=[];
% For MCI subjects, name the variable: cortex_sMRI_MCI_features
for r_i=1:size(regions_ind,2)
eval(sprintf('cortex_sMRI_NC_features{sbgt,%d}{1} =[label%d_Cmean''];',regions_ind(r_i),regions_ind(r_i)));
eval(sprintf('cortex_sMRI_NC_features{sbgt,%d}{2} =[label%d_Gauss''];',regions_ind(r_i),regions_ind(r_i)));
eval(sprintf('cortex_sMRI_NC_features{sbgt,%d}{3} =[label%d_curvedness''];',regions_ind(r_i),regions_ind(r_i)));
eval(sprintf('cortex_sMRI_NC_features{sbgt,%d}{4} =[label%d_sharpness''];',regions_ind(r_i),regions_ind(r_i)));
eval(sprintf('cortex_sMRI_NC_features{sbgt,%d}{5} =[label%d_volume''];',regions_ind(r_i),regions_ind(r_i)));
end
eval(sprintf('clear label%d_Cmean label%d_Gauss label%d_curvedness label%d_sharpness label%d_int l_int%d val%d I%d r c f curvedness%d sharpness%d isovalues%d_sett nX%d nY%d nZ%d label%d X%d Y%d Z%d F%d V%d col%d FV%d Cmean%d Cgaussian%d Dir1_%d Dir2_%d Lambda1_%d Lambda2_%d verts%d faces%d a%d b%d c%d area%d];',labi,labi,labi,labi,labi,labi,labi,labi,labi,labi,labi,labi,labi,labi,labi,labi,labi,labi,labi,labi,labi,labi,labi));
end
clear label label_int 
end

% Write the features' file for each subject
% Do the same for MCI subjects and save it
% save two_cortex_sMRI_MCI_features cortex_sMRI_MCI_features
save two_cortex_sMRI_NC_features cortex_sMRI_NC_features
end
