
% E. Rashedi
tic
clear all ; clc;    
curPath = pwd;
path(path, [curPath filesep 'database']);
path(path, [curPath filesep 'classifiers']);
path(path, [curPath filesep 'indices']);
path(path, [curPath filesep 'MIToolbox-master']);
%%%
clear all;clc
% set random seed
rand('state', sum(100*clock));
 N=10; %20,20,6
 Submax_it=6; CycleNum=8;
 iterMax=Submax_it*CycleNum;
 Fnum1=100; Fnum1w=20000;
 ElitistCheck=1;  bit_num=1;  min_flag=0; Nr=30; 
 pTr=.7; %% train test
K=1; %% Knn
Kf=10; %% kfold
% classMethod='bayesKfold'  ; %%% 'knnLOOCV'  
% classMethod='svmKfold' ;
% classMethod='svmTrTs' ;
classMethod='svmTrTs' ;
 TcaseIndex=[1 2 3 4 5 6 7 8 9 12]; %TcaseIndex=24;
% TcaseIndex=[3 4 5 6 18 19 13 7 15 16  ]; 
methods = {@PywIBGSA @FilABACO @FilBPSO @FilCatFishPSO @FilNBGSA @PywIBPSO};
 for i=10; %1:length(TcaseIndex)
   caseIndex=TcaseIndex(i),
   [Data,Targets,CaseName,KFindices]=DataCaseGet(caseIndex,Kf); CaseName
   Data=normalData(Data);
%    [DataL,TargetsL]=DataTrainGet(Data,Targets,CaseName); %% learn data
   BestsC=[]; FrNumC=[]; BflistC=[]; CorPerTot=[]; size(Data)
   ItBreak=20; 
       Aacc=[]; Asen=[]; Aspe=[]; Afnum=[];
    cyAacc=[]; cyAsen=[]; cyAspe=[]; cyAfnum=[];
    AtFS=[]; AtClassification=[]; cyF=[];
   for run=1:Nr
     run,i,  
       BestsC=[]; FrNumC=[]; BflistC=[];
            acc=[]; sen=[]; spe=[]; fnum=[];
     %%%run for learn data
     [params]= setParamsWrappers(methods{1},Data,N,iterMax,CycleNum,Submax_it);
%      [BestCycle, FrNumCycle,Bflist]=PyRrun(DataL,TargetsL,N,itermax,Submax_it,KFindices,ItBreak,K,Kf,pTr,classMethod,CycleNum);
     [out]=PywIBGSAtrts(Data,Targets,params,KFindices,K,Kf,pTr,classMethod,Fnum1w,Data, Targets);

     cyAacc=[cyAacc;out.CycleTsAcc]; cyAsen=[cyAsen;out.CycleTsSen];
     cyAspe=[cyAspe;out.CycleTsSpe]; cyAfnum=[cyAfnum;out.CycleTsFn];
     cyF{run}=out.flist;
     %% saving
        fn=['res ',func2str(methods{1}) ,' Cy',num2str(CycleNum), ' ',CaseName,' ',classMethod,' F',num2str(Fnum1w),'.mat'];
        save(fn,'cyAacc','cyAsen','cyAspe','cyAfnum','cyF');

  end
  BestsC=[]; FrNumC=[];
 
 end
toc

%  L=Lbests;
% [CorPer,BCA]=ClassificationRate(Data(:,L==1),Targets,KFindices),
% [EFSm,Erm,Fnrm]=EESrate(Data,Targets,L,KFindices),
% mean(1-sum(Lbests')/size(Lbests,2))

