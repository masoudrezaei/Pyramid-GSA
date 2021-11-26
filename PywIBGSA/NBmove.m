
%This function updates the velocity and position of agents.
function [X,V]=NBmove(X,a,V,F)

%movement.
[N,n]=size(X);

V=rand(N,n).*V+a;
% V(V>6)=6; V(V<-6)=-6;
% S=abs(tanh(V)); %eq. 13. %%BGSA

k=1;T=500; A=k*(1-exp(-F/T)); %%%NBGSA
S=A+(1-A)*abs(tanh(V));

temp=rand(N,n)<S;
moving=find(temp==1);

X(moving)=~X(moving);   %eq. 14    

% V=[-7:7];F=1;k=1;T=100; A=k*(1-exp(-F/T));S=A+(1-A)*abs(tanh(V));min(S)