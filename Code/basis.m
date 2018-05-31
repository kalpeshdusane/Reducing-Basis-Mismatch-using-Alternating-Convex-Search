function [output_basis] = basis(Q,N,theta)
% If Q = 1 and all theta are 0 then it represents DFT
 
output_basis = zeros(N,Q*N);
for n = 0:N-1
    sqrt_term = sqrt(2/N);
    for k = 1:(Q*N/2)
        temp = sqrt_term * cos(2* pi * n * ((k-1)/(Q*N) + theta(k)));
        output_basis(n+1,k) = temp;
    end    
    for k = (Q*N/2 + 1) : Q*N
%         display((N - k + 1));
%         temp = (-1) * sqrt_term * sin(2* pi * n * ((N - k)/(Q*N) - theta(1+mod((N - k + 1),(Q*N/2)))));
        temp = (-1) * sqrt_term * sin(2* pi * n * ((N - k)/(Q*N) - theta(Q*N - k + 1)));
        output_basis(n+1,k) = temp;    
    end
end

end