function [x_blue_final] = blue_tdoa(noisy_distances,anchor_location,sigma2_i)
%Create BLUE estimator for Transvahan coordinates
%also plot this BLUE estimation on mapimage.jpeg
%noisy_distances=noisy_distances(:,1,1);
x_blue_final=zeros(2,1);
r=zeros(6,1);
r_new=zeros(6,1);
H = zeros(6,5);
% A matrix to get r
A=[1 -1 0 0;1 0 -1 0; 1 0 0 -1; 0 1 -1 0; 0 1 0 -1; 0 0 1 -1]; 
r= A*noisy_distances;
%sigma2_i = 0.1;
B=[4 1 1 1 1 0;1 4 1 1 0 1;1 1 4 0 1 1;1 1 0 4 1 1;1 0 1 1 4 1; 0 1 1 1 1 4];
Ce = ((2*(sigma2_i)^2).*B);
%Take its inverse
Ce_inv = inv(Ce);
k = 1;
for i = 1:4
    for j = (i+1):4
        r_new(k) = abs((r(k)).^2 - norm(anchor_location(:, i)).^2 - norm(anchor_location(:, j)).^2) ;
        k = k + 1;
    end
end
k=1;
for i =1:3
    for j = i+1:4
        H(k,1) = -2*(anchor_location(1,i) - anchor_location(1,j));
        H(k,2) = -2*(anchor_location(2,i) - anchor_location(2,j));

        H(k,(j+1))=-2*r(k);
        k = k + 1;
    end
end
x_blue = inv(transpose(H) * Ce_inv * H) * transpose(H) * Ce_inv * r_new;
x_blue_final(1,1) = x_blue(1,1);
x_blue_final(2,1) = x_blue(2,1);
end