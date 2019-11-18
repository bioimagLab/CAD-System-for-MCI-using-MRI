function diagnosis

% Load the fused features' files of the targeted regions
Cregions=[1:8 13:16 23:25 27:35 37 39 43 47 50 53:81 83 85:89 91:101 103 105:108 112:114];
for k=1:size(Cregions,2)
    eval(sprintf('load fused_all_features_norm%d.mat;', Cregions(k)));
end
NC=60;
MCI=86;

% Prepare training data

for i=1:size(Cregions,2)
eval(sprintf('trainingRegion%d(1:NC,:)=[trainZ%d(1:NC,:)];',Cregions(i),Cregions(i)));
eval(sprintf('trainingRegion%d(NC+1:NC+MCI,:)=[trainZ%d(NC+1:NC+MCI,:)];',Cregions(i),Cregions(i)));
end
Label=[zeros(NC,1);ones(MCI,1)];
lind=[Cregions];

% Validation of SVM
rng('default');
%% LOSO
%k=size(trainingRegion,1);
%cvFolds1 = crossvalind('Kfold', size(trainingRegion,1), k);
%count1=0;
%for o = 1:k                           %# for each fold
%testIdx1 = (cvFolds1 ==o);            %# get indices of test instances
%trainIdx1 = ~testIdx1;                %# get indices training instances
%for t=1:size(lind,2)
%         eval(sprintf('SVMmodel%d=fitcsvm(trainingRegion%d(trainIdx1,:), Label(trainIdx1,:),''KernelFunction'',''linear'',''Standardize'',true);',t,lind(t)));
%         eval(sprintf('mdlSVM1%d = fitSVMPosterior(SVMmodel%d);',t,t));
%         eval(sprintf('[trainoutputRegion%d,trainprobRegion%d,trainstdevRegion%d] = predict(mdlSVM1%d,trainingRegion%d(trainIdx1,:));',t,t,t,t,lind(t)));
%         eval(sprintf('[testoutputRegion%d,testprobRegion%d,teststdevRegion%d] = predict(mdlSVM1%d,trainingRegion%d(testIdx1,:));',t,t,t,t,lind(t)));
%     end
% for p=1:145
% l=1;
%         for i=1:size(lind,2)
%             eval(sprintf('trainTrainingProbGlobal(p,l)=trainprobRegion%d(p,1);',i));
%             l=l+1;
%         end
% end
% l=1;
%         for i=1:size(lind,2)
%             eval(sprintf('testTrainingProbGlobal(1,l)=testprobRegion%d(1,1);',i));
%             l=l+1;
%         end
% %# train a model over training instances
% SVMmodel=fitcsvm(trainTrainingProbGlobal, Label(trainIdx1),'KernelFunction','linear ','Standardize',true);
% %# test using test instances
% [score1,ss] = predict(SVMmodel,testTrainingProbGlobal);
% Ttest1=Label(testIdx1);
% place1=find(testIdx1==1);
%         if (score1 ~= Ttest1)
%             kplace1=place1
%         	count1=count1+1
%         end
% end

 %% K fold
k=10;
cvFolds1 = crossvalind('Kfold', NC, k);
cvFolds2 = crossvalind('Kfold', MCI, k);
cvFolds=[cvFolds1; cvFolds2];
count1=0;
for o = 1:k                              %# for each fold
testIdx1 = (cvFolds ==o);                %# get indices of test instances
trainIdx1 = ~testIdx1;                   %# get indices training instances
    for t=1:size(lind,2)
        eval(sprintf('SVMmodel%d=fitcsvm(real(trainingRegion%d(trainIdx1,:)), Label(trainIdx1),''KernelFunction'',''linear'',''Standardize'',true);',lind(t),lind(t)));
        eval(sprintf('mdlSVM1%d = fitSVMPosterior(SVMmodel%d);',lind(t),lind(t)));
        eval(sprintf('[trainoutputRegion%d,trainprobRegion%d,trainstdevRegion%d] = predict(mdlSVM1%d,real(trainingRegion%d(trainIdx1,:)));',lind(t),lind(t),lind(t),lind(t),lind(t)));
        eval(sprintf('[testoutputRegion%d,testprobRegion%d,teststdevRegion%d] = predict(mdlSVM1%d,real(trainingRegion%d(testIdx1,:)));',lind(t),lind(t),lind(t),lind(t),lind(t)));
    end
for p=1:size(find(cvFolds~=o),1)
l=1;
        for i=1:size(lind,2)
            eval(sprintf('trainTrainingProbGlobal(p,l)=trainprobRegion%d(p,1);',lind(i)));
            l=l+1;
        end
end
for p=1:size(find(cvFolds==o),1)
l=1;
        for i=1:size(lind,2)
            eval(sprintf('testTrainingProbGlobal(p,l)=testprobRegion%d(p,1);',lind(i)));
            l=l+1;
        end
end
%# train a model over training instances
SVMmodellinearlinear=fitcsvm(trainTrainingProbGlobal, Label(trainIdx1),'KernelFunction','linear','Standardize',true);
%# test using test instances
[score1,ss2] = predict(SVMmodellinearlinear,testTrainingProbGlobal);
Ttest1=Label(testIdx1);
place1=find(testIdx1==1);
for i=1:size(score1,1)
        if (score1(i,:) ~= Ttest1(i,:))
            kplace1=place1(i)
        	count1=count1+1
        end
end
        for i=1:size(lind,2)
            eval(sprintf('clear trainoutputRegion%d trainprobRegion%d trainstdevRegion%d;',lind(i),lind(i),lind(i)));
            eval(sprintf('clear testprobRegion%d testprobRegion%d teststdevRegion%d;',lind(i),lind(i),lind(i)));
            l=l+1;
        end
clear trainTrainingProbGlobal testTrainingProbGlobal SVMmodellinearlinear score1 Ttest1 place1 ss2  kplace1
end
end
