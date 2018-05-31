clear;
close all;
clc;
x = 2:2:10;

z_1 = [0.573188970218924	0.745343040330860	2.41847730518720	0.0302713240724280	0.132848094989664];

z_2 = [1.03959829208392e-05	1.82624554659973e-05	6.93130599869578e-05	1.25945703198800	0.544971944232439];

z_3 = [];
figure
plot(x,z_1,x,z_2)
xlabel('S - sparsity') % x-axis label
ylabel('RMSE') % y-axis label
legend('Q = 1','Q = 3/2');

x1 = [0.00495878268230543	0.597930418697668	0.894012289379296	1.28562132538306	3.00847087887630];
x2 = [0.0913469200775871	2.71678072987587	0.230662331618171	0.856334879668547	0.330859672038550];
% x3 = [];
figure
plot(x,x1,x,x2)
xlabel('S - sparsity') % x-axis label
ylabel('x DIFFERENCE') % y-axis label
legend('Q = 1','Q = 3/2');
% 
% t1 = [];
% t2 = [];
% t3 = [];
% figure
% plot(x,t1,x,t2,x,t3)
% xlabel('S - sparsity') % x-axis label
% ylabel('Time(s)') % y-axis label
% legend('Q = 1','Q = 3/2','Q = 2');
