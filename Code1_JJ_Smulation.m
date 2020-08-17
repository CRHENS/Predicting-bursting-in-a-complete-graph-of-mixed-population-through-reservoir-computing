%function [Y]= bifur_josephson_junction_phasecoup;
%% @Chittaranjan Hens. The script is little messy. Here
%% we have generated the model data for different coupling strength and 
%%has been saved in TS_10nodes_coup_0to10_50k_Hetreroset3.mat
%% Mail ID: chittaranjanhens@gmail.com
close all;
clear
XX=[];
N =10;                           % number of oscillators
                       % time (initialisation) of integration (with K=0)
trans=2500;                          % time (transient) of integration
tend=7000;                         % time (end) of integration
tstep=0.01;   % k=1;   
q1=1; 

a=0.2; b=1.7; ic1=a+(b-a)*rand(2*N,1);
%ic=rand(2*N,1)/50;
 % I_n=0.5; I_p=1.25; 
  I_p=1.25+0.05*rand;
  I_n=0.5+0.05*rand;
 ic=ic1;
 zz_osc=[]; zz_exc=[];
 ll=0; zz=[];q1=1;
 bifur_joseph_coup_osc=[];zz=[];spike_number=[];
%sc=0.8;
for p=0.5; 
%for k=[0 0.25 0.5 0.75 1 1.25 1.5 1.75 2.0 2.25 2.5 2.75 3.35 3.5 3.75  4  4.25 4.5 4.75 5  5.25 5.5 5.75 6 7 8 9 10]
%for k=[1 2 3 4 5 6 8 10  20]
I_pp(1:1:p*N)=I_p;    
I_nn(1:1:(1-p)*N)=I_n;
for k=0:1:10
    fprintf('p=%f; k=%f\n',p,k)
    op=odeset('RelTol', 1e-7, 'AbsTol', 1e-7);
%if (trans>0)
sum(ic)
   tspan=[0  trans];
   [t,x] = ode45(@joseph_phasecoup,tspan,ic,op,N,I_n,I_p,k,p);
   ic = x(end,:);
%end

[t,x] = ode45(@joseph_phasecoup,[0 tend],ic,op,N,I_n,I_p,k,p);
Y=x(end-50001:end,2:2:end);

% Yosc=Y(:,2);
% Yexc=Y(:,end);
% [PP1] = bifur_function(Yosc,k);
% [PP2] = bifur_function(Yexc,k);
% zz_osc=[zz_osc;PP1];
% zz_exc=[zz_exc;PP2];
% x=[];
zz=[zz;Y];
Y=[];
%Y=x;
 %save Y.mat Y;
%  figure(1); subplot(3,3,q1); plot(x(end-20000:end,2:2:end)); 
%   figure(3); subplot(3,3,q1); imagesc(x(end-20000:end,2:2:end));
%  q1=q1+1;
      end
end
i1=2;
Y1=zz;
Ydata(:,1)=Y1((i1-1)*50001+1:i1*50001,1);
Ydata1(:,1:9)=Y1((i1-1)*50001+1:i1*50001,2:10);
plot(Ydata1(:,1:4))
hold on;
plot(Ydata)

  save TS_10nodes_coup_0to10_50k_Hetreroset3.mat  zz;

function y=joseph_phasecoup(t,x,N,I_nn,I_pp,k,p);
alpha= 1.5;  
x22=x(2:2:2*N);
x1p=x(1:2:p*2*N);
x2p=x(2:2:p*2*N);
x1n=x((p*2*N)+1:2:2*N);
x2n=x((p*2*N)+2:2:2*N);
mf2=mean(x22);
coupling2p=k*(mf2-x2p);
coupling2n=k*(mf2-x2n);
y(1:2:p*2*N) = (x2p);%+coupling1p+light;
y(2:2:p*2*N) = (I_pp-alpha*x2p-sin(x1p))+coupling2p;
y((p*2*N)+1:2:2*N) = (x2n);%+coupling1n+light;
y((p*2*N)+2:2:2*N) = (I_nn-alpha*x2n-sin(x1n))+coupling2n;
y=y';
end
