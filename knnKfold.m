function [CorPer,cp]=knnKfold(Data,Targets,K,Kf,KFindices)

% %%%% knn k-fold
% indices = crossvalind('Kfold',Targets,Kf);
indices=KFindices;
cp = classperf(Targets);
for i = 1:Kf
    testIdx = (indices == i); trainIdx = ~testIdx;
    Ldata=Data(trainIdx,:); Tdata=Data(testIdx,:); Ltarget=Targets(trainIdx,:); 
    %     class = knnclassify(Data(test,:),Data(train,:),Targets(train,:),K,'euclidean');
%     Mdl =ClassificationKNN.fit(Ldata,Ltarget,'NumNeighbors',K,'distance','euclidean');
        Mdl =fitcknn(Ldata,Ltarget,'NumNeighbors',K,'distance','euclidean');

     
        mTarget=predict(Mdl,Tdata);
    classperf(cp,mTarget,testIdx);
    %%% Balanced classification accuracy
%     Ttest=Targets(test,1);a=[];uq=unique(class);
%     for j=1:length(uq); jc=uq(j);a=[a sum(class(class==jc)==Ttest(class==jc))/sum(Ttest==jc)];end;
%     for j=1:ClassNum;jc=[];jc=find(Ttest==j);a=[a sum(class(jc)==Ttest(jc))/length(jc)];end;
%     a(isnan(a))=[];a2(i)=mean(a);
end
% BCA=mean(a2);% CorPer=BCA;
CorPer=cp.CorrectRate;%
%%%%

