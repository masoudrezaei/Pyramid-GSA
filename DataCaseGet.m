function [Data,Targets,CaseName,KFindices]=DataCaseGet(caseIndex,Kf,foldType)
KFindices=[];
%%% Dnum*Fnum , classNum
switch caseIndex
    case 1
        A=load('colon.mat'); Data=A.colon(:,[1:end-1]); Targets=A.colon(:,end); CaseName='colon'; %64*2000 , 2
    case 2
        A=load('Ovarian.mat'); Data=A.Ovarian(:,[1:end-1]); Targets=A.Ovarian(:,end); CaseName='Ovarian'; %253*15154 , 2
    case 3
        A=load('leukemia.mat'); Data=A.leukemia(:,[1:end-1]); Targets=A.leukemia(:,end)+1; CaseName='leukemia'; %72*7129 , 2
    case 4 
        A=load('Prostat_cancer1.mat'); Data=A.Prostat_cancer2(:,[1:end-1]); Targets=A.Prostat_cancer2(:,end); CaseName='Prostate_cancer'; %136*12600 , 2
    case 5 
        A=load('breast_Cancer.mat'); Data=A.breast_Cancer(:,[1:end-1]); Targets=A.breast_Cancer(:,end)+1; CaseName='Breast_Cancer'; %97*24481 , 2 
    case 6 
         A=load('Lung_Cancer.mat'); Data=A.data(:,[2:end]); Targets=A.data(:,1)+1; CaseName='Lung_Cancer'; %203*12600 , 5, harvard1
    case 7 
        A=load('leukemia1.mat'); Data=A.data(:,[2:end]); Targets=A.data(:,1)+1; CaseName='Leukemia1'; %72*5327 , 3
    case 8 
        A=load('leukemia2.mat'); Data=A.data(:,[2:end]); Targets=A.data(:,1)+1; CaseName='Leukemia2'; %72*11227 , 3
    case 9 
         A=load('SRBCT.mat'); Data=A.data(:,[2:end]); Targets=A.data(:,1)+1; CaseName='SRBCT'; %83*2308 , 4
   case 10 
        A=load('Lymphoma.mat'); Data=A.Lymphoma(:,[1:end-1]); Targets=A.Lymphoma(:,end)+1; CaseName='Lymphoma'; %45*4026 , 2 (NaN Data)
    case 11
        A=load('lungCancer_test.data');
    case 12
            A=load('BCDS.mat');Data=A.BCDS([2:end],:);Targets=A.BCDS(1,:);
            %A=load('microRna.mat'); Data=A.Mydata([2:end],:);Data(4,:)=[]; Targets=A.Mydata(1,:);
            Data=Data';Targets=Targets';CaseName='microRna'; 
end
% %%regular cross-validation/ DOB-SCV
% switch foldType
%     case 'random'
%         fn=['fold' ,num2str(Kf),' ',CaseName];
%         load(fn,'KFindices');
%     case 'DOB'
        fn=['DOBfold' ,num2str(Kf),' ',CaseName];
        load(fn,'KFindices');
% end