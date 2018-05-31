function [x_e, theta_e] = ACS(y, A, Q, N)
% y - output signal M x 1
% A - sensing matrix M x N (phi)
% Q - degree of overcompleteness
% N - number of signals

% hyper-parameters
alpha = 0.1;
beta = 0.1;
TOL = 10^(-5);
prev_f = 0;
% how fine you have to do coordinate descent?
no_of_parts = 10;
range = 1/(no_of_parts*Q*N);
start_range = -(1/(2*Q*N));
end_range = (-1)*start_range;
%initialize
theta = zeros(Q*N/2,1);
t = 0;
max_iteration = 200;
sqrt_term = sqrt(2/N);

while true
%     display(t);
    t=t+1;
    basis_estimate = basis(Q,N,theta);
%     temp = (A * basis_estimate)' * y;
    temp = pinv(A * basis_estimate) * y;
    lambda = alpha * norm(temp,inf);
    
    % get estimate of x using l2-l1 problem using ISTA
%     lambda_ISTA = 33;
%     lambda_ISTA = 1;
    A_ISTA = A * basis_estimate;
%     alpha_ISTA = max(eig(A_ISTA'*A_ISTA))+.5;
    [M,~] = size(A_ISTA);
    [x_e,~] = l1_ls(A_ISTA,A_ISTA',M,Q*N,y,lambda,0.001,true);
%     x_e = ISTA(y,A_ISTA,alpha_ISTA,lambda_ISTA,-1);
%     x_e = zeros(N,1);    
    k_ACS = beta * norm(x_e,2);
    for i = 1:Q * N
        % for subset S
        if abs(x_e(i)) >= k_ACS
%             solve for theta
%             Coordinate descent
            theta_estimate = []; 
            values = start_range:range:end_range;
            for j = start_range:range:end_range
%                 theta(index_j) = j;
                for m = 0:N-1
                    if i <= (Q*N)/2
                        basis_estimate(m+1,i) = sqrt_term * cos(2*pi*m*((i - 1)/(Q*N) + j));
                    else
                        basis_estimate(m+1,i) = (-1) * sqrt_term * sin(2*pi*m*((N-i)/(Q*N) - j));
                    end
                end
%                 basis_estimate(i) = j;
                temp = norm(y - A * basis_estimate * x_e)^2;
                theta_estimate = [theta_estimate temp];
            end
            [~,index] = min(theta_estimate);
            % Get the min value
%             basis_estimate(i) = values(index);
            index_j = i;
            if i > (Q*N)/2
                index_j = Q*N - i + 1;
            end
            theta(index_j) = values(index);
        end
    end
    curr_f = norm(y - A * basis_estimate * x_e)^2 + lambda * norm(x_e,1);
%     curr_y = A * basis_estimate * x_e;
    if (abs((curr_f - prev_f) / prev_f) < TOL) || (t > max_iteration)
        break;
    end
    prev_f = curr_f;
end

theta_e = theta;


end