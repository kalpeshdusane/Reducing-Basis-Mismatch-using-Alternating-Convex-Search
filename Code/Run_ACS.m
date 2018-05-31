function [ normalized_RMSE, coef_error, diff_x, time ] = Run_ACS(S,Q,phi,N,M)
% S - sparsity
% Q - degree of overcompleteness
% phi - sensing matrix
% N - input signal length
% M - output signal length

z = generate_input(Q,N,S);

temp = 0 ;
for i = 1:N
    temp = temp + z(i)*z(i);
end
temp = temp / N;
sigma = sqrt(temp) / (100);

% noise
noise = sigma * randn(M,1);

% output_signal 
y = phi * z + noise;
c_s = fix(clock);
[x_estimate, theta_estimate] = ACS(y, phi, Q, N);
c_e = fix(clock);
time = abs(c_e(6)-c_s(6)) + abs(c_e(5) - c_s(5)) * 60; 
% generate new bases 
basis_estimate = basis(Q,N,theta_estimate);

z_estimate = basis_estimate * x_estimate;

normalized_RMSE = norm(z - z_estimate)^2 / norm(z)^2;

% display(normalized_RMSE);

% compare it with Over-complete Fourier Bases
theta = zeros(Q*N/2,1);
fourier_bases = basis(Q,N,theta);

A_ISTA = phi * fourier_bases;
alpha = 0.1;
temp = pinv(phi * fourier_bases) * y;
lambda = alpha * norm(temp,inf);

[x_e,~] = l1_ls(A_ISTA,A_ISTA',M,Q*N,y,lambda,0.001,true);

diff_x = norm(x_e - x_estimate);
coef_error = diff_x^2 / norm(x_e)^2;

end