% E. Rashedi, 2016
%
function   [Fbest,Lbest,BestChart,MeanChart,gpop, bestmem, FCbest]=moNBGSA(N,Submax_it,Data,Targets,ItBreak,KFindices,gpop,dim_index,K,Kf,pTr,classMethod);

%V:   Velocity.
%a:   Acceleration.
%M:   Mass.  Ma=Mp=Mi=M;
%m: Dimension of test function.
%n: Dimension of binary search space.
%N:   Number of agents.
%X:   Position of agents. N-by-n matrix.
%R:   Distance between agents in search space.
%[low-up]: Allowable range for search space.
%Rpower: Power of R in eq.2.
 
Rpower=1;  min_flag=0; ElitistCheck=1;
 
X=gpop(:,dim_index); n=size(X,2); low=0;up=1;
%create best so far chart and average fitnesses chart.
BestChart=[];MeanChart=[];

V=zeros(N,n); F=0; iteration=0;

while iteration<Submax_it
    iteration=iteration+1;
    
    %Evaluation of agents.
    gpop(:,dim_index)=X;
    [fitness,Crate]=evaluateF(gpop,Data,Targets,KFindices,K,Kf,pTr,classMethod); 
    %%%new method
    if iteration>1
        if min_flag==1
            afit=find(fitness>fitnessold);
        else
            afit=find(fitness<fitnessold);
        end
    X(afit,:)=Xold(afit,:);fitness(afit)=fitnessold(afit);
    end
    %%%

    if min_flag==1
    [best best_X]=min(fitness); Cbest=Crate(best_X);%minimization.
    else
    [best best_X]=max(fitness); Cbest=Crate(best_X);%fitnessCCR(best_X),fitnessE(best_X)%maximization.
    end        
    
    if iteration==1
       Fbest=best;Lbest=X(best_X,:); bestmem=gpop(best_X,:);  FCbest=Cbest;
    end
    if min_flag==1
      if best<Fbest  %minimization.
       Fbest=best;Lbest=X(best_X,:); bestmem=gpop(best_X,:); FCbest=Cbest;
      end
    else 
      if best>Fbest  %maximization
       Fbest=best;Lbest=X(best_X,:); bestmem=gpop(best_X,:); FCbest=Cbest;
      end
    end
 %%%%new method
       if iteration~=1
           if Fbest==BestChart(iteration-1)
               F=F+1;
           end
           if Fbest~=BestChart(iteration-1)
               F=0;
           end
       end
 %%%%       
BestChart=[BestChart Fbest];
MeanChart=[MeanChart mean(fitness)];


%Calculation of M. eq.8-12
[M]=massCalculation(fitness,min_flag); 

%Calculation of Gravitational constant. eq.7.
G=NGconstant(iteration,Submax_it); 

%Calculation of accelaration in the gravitational field. eq.2-4.
a=NGfield(M,X,G,Rpower,ElitistCheck,iteration,Submax_it);

%%%
Xold=X;fitnessold=fitness;

%Agent movement. new method
[X,V]=NBmove(X,a,V,F);
% Fbest, FCbest, sum(bestmem),
%%% speed 
    if iteration>ItBreak
           if BestChart(iteration-ItBreak)==BestChart(iteration)
               BestChart(iteration+1:max_it)=BestChart(iteration);MeanChart(iteration+1:max_it)=MeanChart(iteration);
                   iteration=max_it;
           end
    end
%%%%
 Disp=strcat('Iter=  ',strcat(Num2Str(iteration)),' ,best ',strcat(Num2Str(Fbest)),' ,bestC ',strcat(Num2Str(FCbest)));
 disp(Disp);
end %iteration
Fbest, FCbest, sum(bestmem),
