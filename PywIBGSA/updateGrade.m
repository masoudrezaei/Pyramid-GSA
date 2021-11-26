function W=updateGrade(W,gpop,fitness)

% for i=1:size(gpop,1)
%     a=find(gpop(i,:)==1);
%     W(1,a)=W(1,a)+.001*fitness(i);
% end
[b loc]=max(fitness);
for i=loc
    a=find(gpop(i,:)==1);
    W(1,a)=W(1,a)+.01*fitness(i);
end