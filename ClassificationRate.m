%%%%Esmat Rashedi. 2016
function [CorPer,cp]=ClassificationRate(Data,Targets,KFindices,K,Kf,pTr,classMethod)

switch classMethod;
    case 'knnLOOCV'
        [CorPer,cp]=knnLOOCV(Data,Targets,K);
     case 'bayesLOOCV'  
         [CorPer,cp]=bayesLOOCV(Data,Targets);
     case 'bayesKfold'  
         [CorPer,cp]=bayesKfold(Data,Targets,Kf,KFindices);
     case 'knnKfold'  
        [CorPer,cp]=knnKfold(Data,Targets,K,Kf,KFindices);
     case 'svmKfold'  
        [CorPer,cp]=svmKfold(Data,Targets,Kf,KFindices);
    case 'ptnet'   
        [CorPer,cp]=ptnet(Data,Targets,Kf,KFindices);
    case 'svmTrTs'   
        [CorPer,cp]=svmTrTs(Data,Targets,pTr);
end


