% E. Rashedi, H. Nezamabadi-pour, “Feature subset selection using improved binary gravitational search algorithm”, Journal of Intelligent and Fuzzy Systems, vol. 26, pp. 1211-1221, 2014.% Rashedi 90.06

%rashedi
function   [Fbest,Lbest,BestChart,MeanChart,gpop, bestmem, FCbest,W]=NBGSAw(N,Submax_it,Data,Targets,ItBreak,KFindices,gpop,dim_index,K,Kf,pTr,classMethod);

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
 
X=gpop(:,dim_index); n=size(X,2); low=0; up=1;
%create best so far chart and average fitnesses chart.
BestChart=[];MeanChart=[];

V=zeros(N,n); F=0; iteration=0;
Fnum=size(Data,2);
W=zeros(1,Fnum);
while iteration<Submax_it
    iteration=iteration+1;
    
    %Evaluation of agents.
    gpop(:,dim_index)=X;
    [fitness,Crate]=evaluateF(gpop,Data,Targets,KFindices,K,Kf,pTr,classMethod); 
    W=updateGrade(W,gpop,fitness);
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
%  %%%%  catfish    
%      if F > 3
%         [fitness inds] = sort(fitness , 'descend');
%         X = X(inds , :);
%         for j = 1 : round(N/10)
%             if rand > 0.5
%                 X(N-round(N/10)+j , :) = ones(1 , Fnum);
%             else
%                 X(N-round(N/10)+j , :) = zeros(1 , Fnum);
%             end
%             
%         end
%      end
%     %%%%%%%%%%%%%%%
BestChart=[BestChart Fbest];
MeanChart=[MeanChart mean(fitness)];


%Calculation of M. eq.8-12
[M]=massCalculation(fitness,min_flag); 

%Calculation of Gravitational constant. eq.7.
G=NGconstant(iteration,Submax_it); 

%Calculation of accelaration in the gravitational field. eq.2-4.
a=NGfield(M,X,G,Rpower,ElitistCheck,iteration,Submax_it);

%%%
Xold=X; fitnessold=fitness;

%Agent movement. new method
[X,V]=NBmove(X,a,V,F);
% Fbest, FCbest, sum(bestmem),
%%% speed 
    if iteration>ItBreak
           if BestChart(iteration-ItBreak)==BestChart(iteration)
               BestChart(iteration+1:Submax_it)=BestChart(iteration);MeanChart(iteration+1:Submax_it)=MeanChart(iteration);
                   iteration=Submax_it;
           end
    end
%%%%
%  Disp=strcat('Iter=  ',strcat(num2str(iteration)),' ,best= ',strcat(num2str(Fbest)),' ,bestC= ',strcat(num2str(FCbest)), ' ,fnum= ',strcat(num2str(sum(bestmem))));
%  disp(Disp);
end %iteration
% Fbest, FCbest, sum(bestmem)
