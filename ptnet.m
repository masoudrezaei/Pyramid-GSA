%%%%Esmat Rashedi. 2020
function [CorPer,cp]=ptnet(Data,Targets,Kf,KFindices)

ClassNum=max(Targets);
% size(Data), size(Targets)
% cp = classperf(Targets');
Target = ind2vec(Targets');
Target = full(Target);
 net = patternnet(15,'trainscg');
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
net.trainParam.max_fail =10;
net.trainParam.showWindow = false;
net = train(net,Data',Target);
output = net(Data');
out=vec2ind(output);

%A = output;
%A = round(A);
%B = Target;
%plotconfusion(Target,output);
%        fitness = crossentropy(net,Targets,output);
% CorPer=sum(out==Targets')/length(out)
% E =  crossentropy(net,Target,output);E
% CorPer=1-E,
        cp=classperf(Targets',out);
        CorPer=cp.CorrectRate;
       
% figure ; plotconfusion(Target,output)
% figure ; plotroc(Target,output)

