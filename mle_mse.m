function [mle_mse]=mle_mse(noisy_distances, anchor_location, x_0, target_location)

mse_vector=zeros(10,1);
for i = 1:10
    for j = 1:1000
         tv_est_mle = mle_tdoa(noisy_distances(:, j, i), anchor_location, x_0);
    
            mse_norm = norm(tv_est_mle - target_location).^2;
            mse_vector(i) = mse_vector(i) + mse_norm;

    mse_vector = mse_vector / 1000;
    mle_mse =mse_vector;
    end
end

end