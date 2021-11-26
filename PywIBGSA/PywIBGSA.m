function [out]=PywIBGSA(Data,Targets,params,KFindices,K,Kf,pTr,classMethod,Fnum1w,DataT, TargetsT)
N=params.N; ClassNum=max(Targets);
Submax_it=params.Submax_it; CycleNum=params.CycleNum;
ItBreak=params.ItBreak;
BestCycle=[];
[CorPer,cp]=ClassificationRate(Data,Targets,KFindices,K,Kf,pTr,classMethod); %CorPer
BestCycle=[BestCycle,CorPer];
%%%% FS by wrapper methods, fspackage
% [Or] = fsReliefF(Data, Targets); [sor ord]=sort(Or.W,'descend'); flist=ord(1:Fnum1);
% [flist] =  fsFCBF(Data, Targets);
[Or] = fsInfoGain(Data, Targets); [sor ord]=sort(Or.W,'descend');flist=ord(1:Fnum1w); %good
% param.k=Fnum1w; param.pool = 1000; param.type = 1; [out]=fsMRMR(Data,Targets);flist=out.fList; %bad
% out=fsTtest(Data, Targets);flist=out.fList(1:Fnum1w); %good
% out=fsFisher(Data, Targets);flist=out.fList(1:Fnum1); %bad
% out=fsGini(Data, Targets);flist=out.fList(1:Fnum1); %bad
DataR=Data(:,flist);
%%%%
Fnum=size(DataR,2);

group = {};
Cycle = 0;
iter = 0;
FrNumCycle=[];
bestmem=ones(1,Fnum); bestmemW=bestmem;
[CorPer,cp]=ClassificationRate(DataR,Targets,KFindices,K,Kf,pTr,classMethod);
BestCycle=[BestCycle,CorPer];
Disp=strcat('cycle=  ',strcat(num2str(Cycle)),' ,best= ',strcat(num2str(CorPer)));
disp(Disp);

% while (iter < itermax)
while (    Cycle<CycleNum)
    Cycle = Cycle + 1;
%     flist=flist(bestmemW==1); %%weighting
            flist=flist(bestmem==1); %%% best found
    DataR=Data(:, flist);  FnumN=size(DataR,2); pop =Binitialization(N,FnumN); dim_index=[1:FnumN]; gpop=pop;
    %         [CorPer,cp]=ClassificationRate(DataR,Targets,KFindices,K,Kf,pTr,classMethod); CorPer
    % ranking using IBGSA FS.
    [Fbest,Lbest,BestChart,MeanChar,pop, bestmem, bestval,W]=NBGSAw(N,Submax_it,DataR,Targets,ItBreak,KFindices,gpop,dim_index,K,Kf,pTr,classMethod);
    %         [CorPer,cp]=ClassificationRate(Data(:, flist(bestmem==1)),Targets,KFindices,K,Kf,pTr,classMethod); CorPer
    % dimention reduction by ranking.
    [ws,bw]=sort(W,'descend');
    bestmemW=zeros(1,FnumN); bestmemW(1,bw(1:round(2*FnumN/3)))=1;
    FrNumCycle=[FrNumCycle,sum(bestmem)];
    BestCycle=[BestCycle,BestChart];
    Disp=strcat('cycle=  ',strcat(num2str(Cycle)),' ,best= ',strcat(num2str(bestval)));
    disp(Disp);
    
    %%%% cycle test evaluation
    flistB=flist(bestmem==1);
    DataTF=DataT(:,flistB(flistB~=0));pairwise = nchoosek(1:ClassNum,2);clear cp;
    DataF=Data(:,flistB(flistB~=0));
    cp = classperf(TargetsT);                      %# init performance tracker
    pairwise = nchoosek(1:ClassNum,2);            %# 1-vs-1 pairwise models
    svmModel = cell(size(pairwise,1),1);            %# store binary-classifers
    predTest = zeros(length(TargetsT),numel(svmModel)); %# store binary predictions
    
    %%%%%%%
    %# classify using one-against-one approach, SVM with 3rd degree poly kernel
    for k=1:numel(svmModel)
        %# get only training instances belonging to this pair
        idx =  any( bsxfun(@eq, Targets, pairwise(k,:)) , 2 );
        %# train
        %     svmModel{k} = svmtrain(meas(idx,:), g(idx), 'BoxConstraint',2e-1, 'Kernel_Function','polynomial', 'Polyorder',3);
        %         svmModel{k} = svmtrainMatlab(Data(idx,:), Targets(idx),'Autoscale',true, 'Showplot',false, 'Method','QP', ...
        %                 'BoxConstraint',100, 'Kernel_Function','rbf', 'RBF_Sigma',2);
        %         svmModel{k} = svmtrainMatlab(Data(idx,:),Targets(idx), 'Kernel_Function','polynomial', 'polyorder',1,'boxconstraint',2e-1); %%ver.2013
        %                                     svmModel{k} = fitcsvm(DataF(idx,:),Targets(idx), 'KernelFunction','polynomial', 'PolynomialOrder',1,'boxconstraint',2e-1); %%ver.2015
        svmModel{k} = fitcsvm(DataF(idx,:),Targets(idx), 'KernelFunction','linear','KernelScale',1); %%ver.2015
        %                     svmModel{k} = fitcsvm(DataF(idx,:),Targets(idx), 'KernelFunction','rbf', 'KernelScale',.2,'boxconstraint',2e-1); %%ver.2015
        %         svmModel{k} = svmtrainMatlab(Data(idx,:),Targets(idx), 'Kernel_Function','rbf', 'RBF_Sigma',2,'boxconstraint',2e-1); %%ver.2013
        %         svmModel{k} = svmtrain(Data(idx,:), Targets(idx),'Kernel_Function', 'rbf','RBF_Sigma',2,'BoxConstraint', 100,'Method','SMO','SMO_Opts', opts,'Autoscale',true );
        %         svmModel{k} = svmtrain(Data(idx,:), Targets(idx),'Kernel_Function', 'rbf','RBF_Sigma',2,'BoxConstraint', 100,'Autoscale',true );
        %# test
        %        predTest(:,k) = svmclassify(svmModel{k}, Data(testIdx,:)); %%ver.2013
        predTest(:,k) = predict(svmModel{k}, DataTF); %%ver.2015
    end
    mTarget = mode(predTest,2);   %# voting: clasify as the class receiving most votes
    %# performance
    cp=classperf(cp, mTarget);
    Disp=strcat('cycle=  ',strcat(num2str(Cycle)),' ,Testbest= ',strcat(num2str(cp.correctRate())), ' ,Fnum= ',strcat(num2str(sum(flistB~=0))));
    disp(Disp);
    CycleTsAcc(1,Cycle)=cp.correctRate(); CycleTsFn(1,Cycle)=sum(flistB~=0);
    CycleTsSen(1,Cycle)=cp.Sensitivity(); CycleTsSpe(1,Cycle)=cp.Specificity();
    %%%% cycle test
end  %cycle
Bflist=zeros(1,8); Bflist(1:sum(bestmem))=flist(bestmem==1);
out.flist=Bflist(Bflist~=0);
out.CycleTsAcc=CycleTsAcc; out.CycleTsFn=CycleTsFn; 
out.CycleTsSpe=CycleTsSpe; out.CycleTsSen=CycleTsSen;
% out.BestCycle=BestCycle; out.FrNumCycle=FrNumCycle;
%%%%%%%%%%%%%%%%%%%%%%%%
%
%         Data=Data(:,Bflist);  FnumN=size(Data,2); pop =Binitialization(N,FnumN); dim_index=[1:FnumN]; gpop=pop;
%         [Fbest,Lbest,BestChart,MeanChar,pop, bestmem, bestval,W]=NBGSAw(N,Submax_it,Data,Targets,ItBreak,KFindices,gpop,dim_index,K,Kf,pTr,classMethod);

