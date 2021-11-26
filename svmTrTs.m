%%%%Esmat Rashedi. 2016
function [CorPer,cp]=svmTrTs(Data,Targets,pTr)

% %%%% svm classify two sets of train and test
indices = crossvalind('HoldOut',Targets,pTr); %% two sets of train and test. pTr is the percent for train.
ClassNum=max(Targets);
cp=classperf(Targets);

trainIdx=indices==0; testIdx=indices==1; %%==1 is for double to logical transformation
%  Mdl = fitcknn(Ldata,Ltarget,'NumNeighbors',K,'distance','euclidean');
    pairwise = nchoosek(1:ClassNum,2);            %# 1-vs-1 pairwise models
    svmModel = cell(size(pairwise,1),1);            %# store binary-classifers
    predTest = zeros(sum(testIdx),numel(svmModel)); %# store binary predictions
%     Mdl = fitcecoc(Data(trainIdx,:),Targets(trainIdx,:)); CVMdl = crossval(Mdl); oosLoss = kfoldLoss(CVMdl)
    for k=1:numel(svmModel)
       idx = trainIdx & any( bsxfun(@eq,Targets, pairwise(k,:)) , 2 ); 
    %idxx=find(idx==1);
%         struct = svmtrainMatlab(Data(idx,:),Targets(idx), 'Kernel_Function','rbf', 'rbf_sigma',.02,'boxconstraint',2e-1); %%ver.2013
%         struct = svmtrainMatlab(Data(idx,:),Targets(idx), 'Kernel_Function','polynomial', 'polyorder',1,'boxconstraint',2e-1); %%ver.2013
        struct{k} = fitcsvm(Data(idx,:),Targets(idx)); %%ver.2015
        
%         predTest(:,k) = svmclassify(struct{k}, Data(testIdx,:) ); %%ver.2013
        pred(:,k) = predict(struct{k},Data );  %%ver.2015
    end
%  mTarget= mode(predTest,2);
  tTarget= mode(pred,2);
 cp=classperf(cp, tTarget);
%%%%
CorPer=cp.CorrectRate;

