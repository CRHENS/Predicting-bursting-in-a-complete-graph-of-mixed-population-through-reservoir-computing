%%% Code for generating machine data in different coupling @Chittaranjan Hens (chittaranjanhens@gmail.com)
%%% Intial code was developed by Mantas Lukoševičius and the people from Michael Small group
%%% In this code  machine generates data for one node input  data extracted 
%%%from the complete graph of Josephson junction. The data is checked for  different coupling strength (here k)
%%%for diffrent leaking constant (here a) and for each a and k, the intrernal resevior elements 
%%%have been chnaged for 50 realization.
%%%
clear all
close all
 %a = 0.45; b = 0.2; c = 4; 

load TS_10nodes_coup_0to10_50k_Hetreroset3.mat;
%load Y1.mat; 
Y1= zz;
zz1=[];
resSize=500;
inSize = 1; outSize = 9;
Win = (rand(resSize,1+inSize)-0.5) .* 1;
%a = 0.3; 
ZX=[];
% dense W:

for jjj=1:50
    W = rand(resSize,resSize)-0.5;

k=0.0:1:10;
for i1=1:length(k)
 % jjj
   
    k1=k(i1);
    
   fprintf('realization=%d\t epsilon=%d\n',jjj,k1); 
Ydata(:,1)=Y1((i1-1)*50002+1:i1*50002,1);%./max((Y1((i1-1)*50000+1:i1*50000,1)));
Ydata1(:,1:9)=Y1((i1-1)*50002+1:i1*50002,2:10);%./max((Y1((i1-1)*50000+1:i1*50000,2:10)));
indata=Ydata;
outdatal=Ydata1;
initLen = 0;
trainLen =25000;
testLen = 20000;
density=0.25;
aa=[0.001 0.005 0.01:0.02:0.1 0.2 0.4 0.5  0.6 0.8 1];
for cc=1:length(aa)
    a=aa(cc);
    fprintf('realization=%d\t a=%d\t epsilon=%d\n',jjj,a,k1);
X = zeros(1+inSize+resSize,trainLen-initLen);
Yt = outdatal(initLen+1:trainLen,1:end)';
x = zeros(resSize,1);
for t = 1:trainLen
	u = indata(t,1);
	x = (1-a)*x + a*tanh(Win*[1;u] + W*x);
	if t > initLen
		X(:,t-initLen) = [1;u;x];
	end
end
% train the output by ridge regression
reg = 1e-8;  % regularization coefficient
% direct equations from texts:
%X_T = X'; 
%Wout = Yt*X_T * inv(X*X_T + reg*eye(1+inSize+resSize));
% using Matlab solver:
Wout = ((X*X' + reg*eye(1+inSize+resSize)) \ (X*Yt'))'; 
Y = zeros(outSize,testLen);
u = indata(trainLen+1,1);
for t = 1:testLen 
	x = (1-a)*x + a*tanh(Win*[1;u] + W*x );
	y = Wout*[1;u;x];
	Y(:,t) = y;
	u = indata(trainLen+t+1,1);
end

 errorLen =5000;
 % ZX=[ZX;Y];
 
% mse = sum((data(trainLen+2:trainLen+errorLen+1)'-Y(1,1:errorLen)).^2)./errorLen;
% disp( ['MSE = ', num2str( mse )] );
for j=1:1:9;

% % time=[0:testLen-1]*0.01; %%%  time
% % figure(3*(j-1)+1);
% % plot(time,outdatal(trainLen+1:trainLen+testLen,j),'linewidth',2);
% % hold on;
% % plot(time,Y(j,:)','-- ','linewidth',2);
% % hold off;
% % xlim([-2 2])
% % ylim([-2 2])
% % axis tight;
% % xlabel('\it{t}','FontName','Times New Roman','FontSize',24);
% % ylabel('X_2 (Originalslave),{X_2(RC)}','FontName','Times New Roman','FontSize',24);
% % set(findall(gcf,'-property','FontSize'),'FontName','Times New Roman','FontSize',30,'linewidth',3,'fontweight','b')   
% % set(gcf, 'PaperPositionMode', 'auto','position', [0, 0,750, 750]);
%title(['Cooupling strength=', num2str(eps1)]);
 mse = sum((outdatal(trainLen+2:trainLen+errorLen+1,j)'-Y(j,1:errorLen)).^2)./errorLen;
 R = corrcoef(Y(j,:),outdatal(trainLen+1:1:trainLen+testLen,j));
% plot(Y(j,:),outdatal(trainLen+2:1:trainLen+testLen+1,j),'o');
%zz1=[zz1;jjj,i1,j,mse,R(1,2)];

zz1=[zz1;jjj, k1, a, j,mse,R(1,2)];
R=[];
mse=[];

% figure(3*(j-1)+2);
% plot(Y(j,:),outdatal(trainLen+1:trainLen+testLen,j),'.');
% hold off;
% axis tight;
% xlabel('{X_2(RC)}','FontName','Times New Roman','FontSize',24);
% ylabel('X_2(Originalslave)','FontName','Times New Roman','FontSize',24);
% set(findall(gcf,'-property','FontSize'),'FontName','Times New Roman','FontSize',30,'linewidth',3,'fontweight','b')   
% set(gcf, 'PaperPositionMode', 'auto','position', [0, 0,750, 750]);
%title(['Cooupling strength=', num2str(eps1)]);
% figure(3*(j-1)+3);
% plot(indata(:,2),outdatal(:,2),'.')
% xlabel('{X_1 (master)}','FontName','Times New Roman','FontSize',24);
% ylabel('X_2','FontName','Times New Roman','FontSize',24);
% set(findall(gcf,'-property','FontSize'),'FontName','Times New Roman','FontSize',30,'linewidth',3,'fontweight','b')   
% set(gcf, 'PaperPositionMode', 'auto','position', [0, 0,750, 750]);
% %title(['Cooupling strength=', num2str(eps1)]);
end
 % Y=[];
  X=[];
  Wout=[];
end
% %  outdatal=[];
% % % indata=[];
% %  Ydata=[];
% %  Ydata1=[];
end
end
save onenode_feed.mat zz1;
% plot(Y(1,:),'-')
% hold on;
% plot(Ydata1(25001:end,1),'-.')
%save zz1_azero.mat zz1;

