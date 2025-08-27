clear;
warning('off','all')
addpath('dace')
addpath('tensor_toolbox-v3.6')

% Load data
load("data(2).mat") % Your data here
% load('full.mat')
transmatrix = readmatrix("transmatrix(2).txt"); % Your transmatrix here

% Tensor construction
for i = 1:30
    griddata = transfer(data_train(:,i),transmatrix);
    if i == 1
        [m, n] = size(griddata);
        data_matrix = zeros(m, n, 20);
    end
    data_matrix(:,:,i) = griddata;
end

% Remove average field
mean_matrix = mean(data_matrix, 3);
mean_matrix_expanded = repmat(mean_matrix, 1, 1, size(data_matrix, 3));
data_matrix = data_matrix - mean_matrix_expanded;

T = tensor(data_matrix);
% Tucker decomposition by tensor_toolbox
tucker_model = hosvd(T,0.005); % Set tolerance
% tucker_model = tucker_als(T,[64 64 13]);
core_tensor = tucker_model.core; % Core tensor
factor_matrices = tucker_model.U; % Mode matrices
factor_matrix = tucker_model.U{3}; % Parameter-varying coefficients

% Reconstruction error on training data (with average field)
fprintf('rRMSE on training data: %.4f%%\n', norm(T - tensor(tucker_model)) / norm(data_matrix + mean_matrix_expanded, 'fro') * 100);

tic;
% kriging interpolation
theta=[4.2,0.6]; % Vx
% theta=[0.4,0.6]; % P
[dmodel,~] = dacefit(input_train,factor_matrix,@regpoly1,@corrgauss,theta);
[new_factor] = predictor(input_test, dmodel);

% % fitrgp interpolation
% for i = 1:size(factor_matrix,2)
%     model = fitrgp(input_train, factor_matrix(:,i), 'KernelFunction', 'ardsquaredexponential', 'BasisFunction', 'pureQuadratic');
%     new_factor(:,i) = predict(model, input_test);
% end

% Prediction
predicted_data = ttm(tucker_model.core, {tucker_model.U{1}, tucker_model.U{2}, new_factor}, [1, 2, 3]);
preds = [];

% Add back average field and inverse transfer
for i=1:100
    pred = inverseTransfer(double(predicted_data(:,:,i)) + mean_matrix, transmatrix);
    preds = [preds pred];
end
time = toc;

% Calculate errors
errors = [];

for i=1:100
    [max_abs_err, mean_rel_err, rmse, rrmse] = calculateErrors(data_test(:,i), preds(:,i));
    errors(end+1)=rrmse;
end
errdist = calculateErrdist(data_test, preds) * 100;
% full = [full errdist];
% save('full.mat','full');

% Print results
fprintf('rRMSE: %.4f%%\n', sum(errors));
core = size(core_tensor);
fprintf('Compression ratio: %.4f\n', size(data_train, 1)*size(data_train, 2)/(core(1)*core(2)*core(3)+core(1)*m+core(2)*n+core(3)*size(data_train, 2)));
fprintf('Time elapsed: %.4fs\n\n', time);