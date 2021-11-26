function [params] = setParamsWrappers(method , dataSet, N,iterMax,CycleNum,Submax_it )% firNum : 1 to 20 except for 19
inds = randperm(size(dataSet,1));
% Q = [0.09 1 0.1 0.6];
ItBreak=10;
zita = 1;

% if size(dataSet,1)>500;ItBreak=10;end;if size(dataSet,1)>1000;ItBreak=5;end

% visit_feature=[3 5 7 4 28 10 7 13 6 30 11 15 7 5 11 6 31 3 16 6 7];
% pm = 0.01*ones(1,100);%[0.01 0.01 0.01 0.1 0.1 0.01 0.01 0.01 0.01 0.1 0.1 0.01 0.1];
% pc = 0.9*ones(1,100);%[0.9 0.9 0.9 0.9 0.9 0.9 0.9 0.9 0.9 0.9 0.9 0.9 0.9];
% 
% ps = 50*ones(1,100);%= ant no.
% maxEvalNum = 3000*ones(1,100);%[40000 40000 40000 40000 40000 40000 40000 40000 40000 40000 40000 40000 4000];
% radiuses = [1 1 1 15 26 7 5 9 7 30 9 13 6 1 1 1 1 1 1 1 1];
% generations = 50;%iteration
% doesPlot = 0;
% selType = 'RouletteWheel';
% mutationType = 'Binary';
% XoverType = 'OnePoint';%'Tauguchi';
% SurviveType = 'Generational';%'Elitism';%'Generational';
methodS=func2str(method);

switch methodS
    case 'FilABACO'        
        params = struct('alpha' , 1 , 'beta' , 0.5, 'ant_num' , N ,...
            'iter' ,iterMax ,'inds' , inds , 'ItBreak' , ItBreak , 'zita' , zita );
    case 'PywIBGSA'
        params = struct('CycleNum' , CycleNum, 'Submax_it' , Submax_it, 'N' , N ,...
            'ItBreak' , ItBreak  );
    case 'FilBPSO'
        params = struct( 'iter' ,iterMax, 'N' , N ,...
            'ItBreak' , ItBreak  );
    case 'FilCatFishPSO'
              params = struct( 'generations' ,iterMax, 'N' , N ,...
            'alpha',zita,'ItBreak' , ItBreak  );
    case 'FilNBGSA'
        params = struct('iter' ,iterMax, 'N' , N ,...
            'ItBreak' , ItBreak  );
    case 'PywIBPSO'
        params = struct('CycleNum' , CycleNum, 'Submax_it' , Submax_it, 'N' , N ,...
            'ItBreak' , ItBreak  );

end


