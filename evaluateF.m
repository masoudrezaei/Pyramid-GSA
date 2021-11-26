%Rashedi
%This function Evaluates the agents. 
function   [fitness, Crate]=evaluateF(X,Data,Targets,KFindices,K,Kf,pTr,classMethod)
Er=[];Fnr=[];
[N,dim]=size(X);Nd = length(Data);
A=0;
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
    Sen = cp.Sensitivity;
    Spe = cp.Specificity;
    Acc = cp.CorrectRate;

    w=1; w1 = 1; w2 = 0; w3=0;
    fitness(i)=(w1*Sen) + (w2*Spe) + (w3*Acc)+(1-w)*(1-Fnum/dim);
   %{ 
for w1=0:0.1:1
        for w2=0:0.1:1
            for w3=0:0.1:1
    fitness(i)=(w1*Sen) + (w2*Spe) + (w3*Acc)+(1-w)*(1-Fnum/dim);
               if fitness(i)>=A
               A =fitness(i);
               end%fitness(i)%CorPer;
            end
        end
end
    %}
    
    %fitness(i)=A;
    Crate(i)=CorPer;
%     cp.Specificity, cp.Sensitivity
end


