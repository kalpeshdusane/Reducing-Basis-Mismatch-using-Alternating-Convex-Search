function [z] = generate_input(Q,N,S)

z = zeros(1,N);
z = z(:);
a = -1/(2 * Q * N);
b = 1/(2 * Q * N);
k = floor(((Q*N)/2 - 1) * rand(1,1));
% theta = zeros(1,k);
% theta = theta(:);
theta = (b - a) .* rand(1,k) + a;
theta = theta(:);
f = zeros(1,k);
f = f(:);
for i = 1:k
    f(i) = i/(Q*N) + theta(i);
end
phase = (2* pi) * rand(1, S/2);

sqrt_term = sqrt(2/N);
for i = 1:N
    sum_term = 0;
    for j = 1:S/2
        % here i is directly taken as index
        temp = cos(2 * pi *(f(j) + theta(j)) * i + phase(1,j));
        sum_term = sum_term + temp;
    end
    z(i) = sqrt_term * sum_term;
end

end