clear;
warning('off','all')
addpath('dace')

global means;
global phi_num;

% Load data
load("data(2).mat") % Your data here
% load('full.mat')

% Set tolerance (e.g., at least 90% energy captured)
tol = 0.9;
[phi,beta1,energy]=POD_multi(data_train, tol);
Y=beta1';

tic;
% kriging interpolation
% theta=[4.2,0.6]; % Vx
theta=[0.4,0.6]; % P
[dmodel,~] = dacefit(input_train,Y,@regpoly1,@corrgauss,theta);
[beta_predict] = predictor(input_test, dmodel);

% % fitrgp interpolation
% for i = 1:size(Y,2)
%     model = fitrgp(input_train, Y(:,i), 'KernelFunction', 'ardsquaredexponential', 'BasisFunction', 'pureQuadratic');
%     beta_predict(:,i) = predict(model, input_test);
% end

% Prediction
pred=phi*beta_predict';
pred=pred+means;
time = toc;

% Calculate errors
errors = [];

for i=1:100
    [max_abs_err, mean_rel_err, rmse, rrmse] = calculateErrors(data_test(:,i), pred(:,i));
    
    errors(end+1)=rrmse;

    % fprintf('Max Abs Error: %.4f\n', max_abs_err);
    % fprintf('Mean Relative Error: %.4f%%\n', mean_rel_err);
    % fprintf('RMSE: %.4f\n', rmse);
end

% Calculate error distribution
errdist = calculateErrdist(data_test, pred) * 100;
% full = [full errdist];
% save('full.mat','full');

% Print results
fprintf('Number of POD modes: %.0f\n', phi_num)
fprintf('rRMSE: %.4f%%\n', sum(errors));
fprintf('Compression ratio: %.4f\n', size(data_train, 1)*size(data_train, 2)/(phi_num*(size(data_train, 1)+size(data_train, 2))));
fprintf('Time elapsed: %.4fs\n\n', time);