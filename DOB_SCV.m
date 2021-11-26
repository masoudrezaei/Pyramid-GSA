% TcaseIndex=[1 2 3 4 5 6 7 8 9 10]; %TcaseIndex=24;
% Kf=5; K=1; pTr=.7; classMethod='svmKfold' ;
% % TcaseIndex=[3 4 5 6 18 19 13 7 15 16  ];  
%  for i=1:10; %1:length(TcaseIndex)
%    caseIndex=TcaseIndex(i),
%    [Data,Targets,CaseName,KFindices]=DataCaseGet(caseIndex,Kf,foldType ); 
%   DOB_SCV(Data,Targets,Kf,CaseName);
%  end
%%% fold construction
function [KFindices,Fold]=DOB_SCV(data,Targets,k,CaseName)
ds=[data,Targets];
[dNum,Fnum]=size(data);
C=unique(Targets);
Fold={};
f=1;
for i=1:length(C)
    ind=find(ds(:,end)==C(i));
    ind_mask=ones(length(ind),1);
   
    while sum(ind_mask)~=0
        ind=ind.*ind_mask;
        ind=nonzeros(ind);
        ind_mask=nonzeros(ind_mask);
        L=length(find(ind_mask==1));
        E_0=randi(L);
        E_0=repmat(data(ind(E_0),:),[L,1]);
        dist=sqrt(sum(((data(ind,:)-E_0).^2)'));
        [D,I]=sort(dist);
        if length(I)<k
            k_new=length(I);
        else
            k_new=k;
        end
        for j=1:k_new
            if f==1
                Fold{j,1}=[ind(I(j))];
            else
                Fold{j}=[Fold{j},ind(I(j))];
            end
        end
        f=0;
        [~,ind_Remove]=ismember(ind(I(1:k_new)),ind);
        ind_mask(ind_Remove)=0;
    end
end
KFindices=zeros(dNum,1);
for j=1:k
    KFindices(Fold{j})=j;
% fn=['DOBfold' ,num2str(k),' ',CaseName];
% save(fn,'KFindices');
end