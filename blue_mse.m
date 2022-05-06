function [blue_mse]=blue_mse(noisy_distances, anchor_location, sigma2, target_location)

mse_vector=zeros(10,1);
for i = 1:10
    for j = 1:1000
         tv_est_blue = blue_tdoa(noisy_distances(:, j, i), anchor_location, sigma2(i));
            mse_norm = norm(tv_est_blue - target_location).^2;
            mse_vector(i) = mse_vector(i) + mse_norm;

    mse_vector = mse_vector / 1000;
    blue_mse =mse_vector;
    end
end

end