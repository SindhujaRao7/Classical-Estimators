function [x_mle_final] = mle_tdoa(noisy_distances,anchor_location,x_0)
%Create MLE estimator for Transvahan coordinates
%also plot this MLE estimation on mapimage.jpeg
%noisy_distances=noisy_distances(:,1,1);
format bank;
max_iter=50;
%step size for Gradient descent
a = 0.2; 
 % A matrix to get Cn
A=[1 -1 0 0;1 0 -1 0; 1 0 0 -1];
%Taking last sigma2 from the given vector
sigma2_i = 0.1; 
%modified covariance vector
Cn = sigma2_i.*(A * transpose(A));
%get its inverse
Cn_inv = inv(Cn);
D= zeros(3,1);
%Define gradient here
delD = zeros(2,3);
r=zeros(3,1);
d= zeros(4,1);
x_mle = zeros(2,max_iter);
x_mle(:,1)=x_0; %
k =1;
t =1;
%Getting the D(x) vector
for iter= 1:max_iter
    for j = 1:4
        %each distance is a norm from transvahan_location to anchor_location
        d(j) = norm(x_mle(:,iter)-anchor_location(:,j));
    end
end
%create Vector D
for j = 1:3
    D(j) = d(j) - d(j+1);
end
r = (A* noisy_distances); %Getting r vector
for iter= 1:max_iter
        for j = 1:3
                for k = 1:2
              
                    delD(k, j) = abs(((x_mle(k, iter) - anchor_location(k, j)) / d(j)) - ((x_mle(k, iter) - anchor_location(k, j+1)) / d(j+1)));
                    
                end
        end
    delD =a.*delD;
	%Iteration for GD
    x_mle(:,iter+1) = x_mle(:,iter) - delD * Cn_inv * (r-D);
end
x_mle_final=x_mle(:,end);
end

