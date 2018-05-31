tic;
clear;
close all;
clc;
%% code

N = 256;
M = 128;

% mu + sigma*randn(M,N); mean = 0 and sigma = 1
phi = 1*randn(M,N);
phi(phi <= 0.5) = 0; phi(phi > 0.5) = 1;

list_error = [];
list_coef_error = [];
list_diff_x = [];
% generate input
S = 2:2:10;
Q = 1:0.5:1.5;
for Q = 1 : 0.5 : 1
    Q_error = [];
    x_error = [];
    x_diff = [];
    for S = 2 : 2 : 10
        disp(['Processing Q : ', num2str(Q),', S : ', num2str(S)]);
        
        [normalized_RMSE, coef_error, diff_x, time] = Run_ACS(S,Q,phi,N,M);
        
        disp(['normalized RMSE : ', num2str(normalized_RMSE),' coefficient error : ', num2str(coef_error),' difference x :', num2str(diff_x)]);
        disp(['Execution Time : ',num2str(time)]);
        Q_error = [Q_error normalized_RMSE];
        x_error = [x_error coef_error];
        x_diff = [x_diff diff_x];
    end
    list_error = [list_error Q_error];
    list_coef_error = [list_coef_error x_error];
    list_diff_x = [list_diff_x x_diff];
end


display(list_error);
display(list_coef_error);
display(list_diff_x);

% z = generate_input(Q,N,S);
% 
% temp = 0 ;
% for i = 1:N
%     temp = temp + z(i)*z(i);
% end
% temp = temp / N;
% sigma = sqrt(temp) / (100);
% % noise
% noise = sigma * randn(M,1);
% 
% % output_signal 
% y = phi * z + noise;
% 
% 
% 
% [x_estimate, theta_estimate] = ACS(y, phi, Q, N);
% 
% % generate new bases 
% basis_estimate = basis(Q,N,theta_estimate);
% 
% z_estimate = basis_estimate * x_estimate;
% 
% normalized_RMSE = norm(z - z_estimate)^2 / norm(z)^2;
% 
% display(normalized_RMSE);

% x_e = pinv(basis_estimate) * z;

% % compare it with Over-complete Fourier Bases
% theta = zeros(Q*N/2,1);
% fourier_bases = basis(Q,N,theta);
% 
% A_ISTA = phi * fourier_bases;
% alpha = 0.1;
% temp = pinv(phi * fourier_bases) * y;
% lambda = alpha * norm(temp,inf);
% 
% [x_e,status] = l1_ls(A_ISTA,A_ISTA',M,Q*N,y,lambda,0.001,true);
% 
% coef_error = norm(x_e - x_estimate)^2 / norm(x_e)^2;

toc;