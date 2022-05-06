function [x_crlb_final] = crlb_tdoa(target_location,anchor_location)
%format shortEng
%format bank
x_crlb_final = zeros(10,1);
sigma2_i = 0.1; 
%modified covariance vector
A=[1 -1 0 0;1 0 -1 0; 1 0 0 -1; 0 1 -1 0; 0 1 0 -1; 0 0 1 -1]; 
Cn = sigma2_i.*(A * transpose(A));
%get its inverse
Cn_inv = inv(Cn);
D= zeros(3,1);
%Define gradient here
delD = zeros(2,3);
r=zeros(3,1);
d= zeros(4,1);
I=zeros(2,2);

k =1;
t =1;

%Getting the D(x) vector
    for j = 1:4
        %each distance is a norm from transvahan_location to anchor_location
        d(j) = norm(target_location-anchor_location(:,j));
    end

%create Vector D
for j = 1:3
    D(j) = d(j) - d(j+1);
end
        for j = 1:3
                for k = 1:2
                    delD(k, j) = abs(((target_location(k,:) - anchor_location(k, j)) / d(j)) - ((target_location(k, :) - anchor_location(k, j+1)) / d(j+1)));
                    %delD(k, j) = ((target_location(k,:) - anchor_location(k, j)) / d(j)) - ((target_location(k, :) - anchor_location(k, j+1)) / d(j+1));
                end
        end
   for i = 1:3
       for j=1:3
           I(1,1) = I(1,1) + Cn_inv(i,j) * (delD(1, i) * delD(1, j) + delD(1, j) * delD(1, i));
           I(1,2) = I(1,2) + Cn_inv(i,j) * (delD(2, i) * delD(1, j) + delD(2, j) * delD(1, i));
           I(2,1) = I(1,2);
           I(2,2) = I(2,2) + Cn_inv(i,j) * (delD(2, i) * delD(2, j) + delD(2, j) * delD(2, i));

       end
   end
    I_inv = (1/2).*inv(I);

for i = 1:10
    x_crlb_final(i,:) = I_inv(1,1)+I_inv(1,1);

end

end