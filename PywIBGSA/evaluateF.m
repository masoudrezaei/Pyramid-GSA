%Rashedi
%This function Evaluates the agents. 
function   [fitness, Crate]=evaluateF(X,Data,Targets,KFindices,K,Kf,pTr,classMethod)
Er=[];Fnr=[];
[N,dim]=size(X);Nd = length(Data);
for i=1:N 
    L=X(i,:); Fnum=sum(L==1); Data2=Data(:,L==1); %tr=zeros(1,Nd);
    %calculation of objective function
    if sum(L==1)~=0
    [CorPer,cp]=ClassificationRate(Data2,Targets,KFindices,K,Kf,pTr,classMethod); %100-CorPer
%    y=Arsenal('classify -sf 1 -n 1 -- cross_validate -t 10 -- kNN_classify -k 1 -d 2',[Data2,Targets] );
%    CorPer=1-y.Err;
    else
    CorPer=0; BCA=0; fitness(i)=0;
    end
    w=1; fitness(i)=w*CorPer+(1-w)*(1-Fnum/dim); %fitness(i)%CorPer;
    Crate(i)=CorPer;
%     cp.Specificity, cp.Sensitivity
end


