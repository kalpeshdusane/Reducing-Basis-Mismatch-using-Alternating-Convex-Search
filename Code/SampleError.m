tic;
clear;
close all;
clc;


N = 50;
i = 10;
x1 = [];
for j = 0:N-1
    temp = cos(pi *j * (2*i + 1) / (2 * N));
    x1 = [x1 temp];
end

i = 9.5;
x2 = [];
for j = 0:N-1
    temp = cos(pi * j * (2*i + 1) / (2 * N));
    x2 = [x2 temp];
end

% temp = 2:2:10;
% for i in temp
%     display(i);
% end
i = 0; j = 1;
if i==1 || j == 1
    disp('Hi')
end

toc;