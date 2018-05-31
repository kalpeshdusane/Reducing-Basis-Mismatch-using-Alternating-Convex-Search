function [ theta_curr ] = ISTA(y,A,alpha,lambda,iterations)

theta_prev = 0*A'*y;
T = lambda/(2*alpha);
theta_curr = theta_prev + (A'*(y - A*theta_prev))/alpha ;
theta_curr = sign(theta_curr).*(max(0, abs(theta_curr)- T));
%threshold = 1e-6;
if iterations > 0 
    for k = 1:iterations 
        theta_curr = theta_curr + (A'*(y - A*theta_curr))/alpha ;
        theta_curr = sign(theta_curr).*(max(0, abs(theta_curr)- T));
    end
else
    threshold = 1e-6;
    while abs(theta_curr - theta_prev) > threshold
        theta_prev = theta_curr;
        theta_curr = theta_curr + (A'*(y - A*theta_curr))/alpha ;
        theta_curr = sign(theta_curr).*(max(0, abs(theta_curr)- T));
    end

end
end