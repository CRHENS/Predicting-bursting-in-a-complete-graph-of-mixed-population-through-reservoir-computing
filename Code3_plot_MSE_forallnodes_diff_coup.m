
close all;
clear all;
load onenode_feed.mat;
%load zz1_twonode_feed_EL5000_20kdata_1000RSn.mat;
figure(1); 
for node=1:9
index=find(zz1(:,4)==node);%% node slection if anyone selects 1 means the node is 2
index11=find(zz1(:,5)<10^-23);
length(index11)
zz1(index11,5)=0.0000005;
rawdata=[zz1(index,2)  zz1(index,5)]; %% coupling strength  vs MSE for node (index =1)
%rawdata=[zz1(index,1)  zz1(index,5)]; 
nanind=find(isnan(rawdata(:,2)));
rawdata(nanind,:)=[];
% indexzerocoup=find(rawdata(:,1)==1);
% rawdata(indexzerocoup,:)=[];
 plot(rawdata(2:end,1),rawdata(2:end,2), '.','color',  [0.5 0.5 0.5], 'markersize', 20);
 hold on;
cool=linearbin(rawdata);
index1=find(isnan(cool(:,1)));
cool(index1,:)=[]; % 6+floor(node/2)

semilogy(cool(1:end,1),cool(1:end,2), 'o-','markersize',8, 'linewidth', 2, 'color',[1-node/9 0 node/9] );
hold on
if (node>4)
    semilogy(cool(1:end,1),cool(1:end,2), 'p-','markersize',8, 'linewidth', 2, 'color',[1-node/9 0 node/9] );
end
index=[];index1=[];
end
%xlabel('\epsilon','FontName','Times New Roman','FontSize',24);
xlabel('\boldmath $\epsilon$','FontName','Times New Roman','FontSize',32,'interpreter','latex','fontweight','b');

  ylabel('MSE','FontName','Times New Roman','FontSize',32);
 set(findall(gcf,'-property','FontSize'),'FontName','Times New Roman','FontSize',30,'linewidth',3,'fontweight','b')   
    set(gca,'YScale','log');
  %  set(gca,'XScale','log');
      set(gca,'ticklength',3*get(gca,'ticklength'))
            xlim([-0.8 10.2]);
%      ylim([7*10^-7 0.7]);
      set(gca,'YTick', [10^-7 10^-6 0.00001  0.0001 0.001  0.01 0.1]);
      set(gca,'XTick',[0 5 10]);
       set(gcf, 'PaperPositionMode', 'auto','position', [0, 0,600, 600]);
 %axis([1.5 21.5 -0.0 0.07])