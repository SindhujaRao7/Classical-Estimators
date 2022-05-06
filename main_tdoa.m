clc;
clear all;

% The data contains the following variables
% 
% 
%  Name                 	                 

%   anchor_location      a 2x4  matrix containing the two-dimensional pixel co-ordinates of the anchor nodes a1, a2, a3, and a4                     
%   target_location      a 2x1 vector containing the two-dimension pixel co-ordinates of the target, i.e., the transvahan x                     
%   true_distances       a 4x1 vector containing the pairwise distances between the Transvahan and the anchors                    
%   sigma2               a 10x1 vector containing different measurement noise variances.                   
%   noisy_distances      a 4x1000x10 tensor containing 1000 realizations of the 4 pairwise distances between the Transvahan and the anchors. The  
%                                   third dimension of the tensor contains these observations for 10 different noise variances collected in sigma2.      


load TDOA_data.mat
x_0 = zeros(2,1);  % Initialize location guess for To

est_choice = input('Enter 1 to estimate using MLE or 2 to estimate using BLUE  and 3 for MSEs = ');
switch est_choice
    case 1
        [x_mle] = mle_tdoa(noisy_distances(:,1,1),anchor_location,x_0); %MLE estimator
        fprintf("Coordinates of the Transvahan Vehicle using MLE estimation is  \n");
        disp(x_mle)
        Im = imread('mapimage.jpeg');
        figure(1); imshow(Im); hold on;
        plot(x_mle(1,1),x_mle(2,1),'x', 'MarkerSize',20);
    case 2
        [x_blue] = blue_tdoa(noisy_distances(:, 1,1), anchor_location,sigma2(3)); %BLUE estimator
        fprintf("Coordinates of the Transvahan Vehicle using BLUE estimation is  \n");
        disp(x_blue)
        Im = imread('mapimage.jpeg');
        figure(1); imshow(Im); hold on;
        plot(x_blue(1,1),x_blue(2,1),'x', 'MarkerSize',20);    
     case 3
        [x_crlb] = crlb_tdoa(target_location,anchor_location); %CRLB bound
        [mle_mse] = mle_mse(noisy_distances, anchor_location, x_0, target_location);
        [blue_mse] = blue_mse(noisy_distances, anchor_location, sigma2, target_location);
        fprintf("The MSE comparison between MLE, BLUE with respect to CRLB is as follows: \n");
        title('MSE comparison between MLE, BLUE with respect to CRLB');   
        plot(sigma2,mle_mse);
        plot(sigma2,blue_mse);
        plot(sigma2,x_crlb);
        legend('MLE','BLUE','CRLB');
        xlabel('Variance');
        ylabel('Mean-Squared Error');
    otherwise
        disp('Wrong input! Run the Program again\n');
end


     