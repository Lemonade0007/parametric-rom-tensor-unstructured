function [max_abs_err, mean_rel_err, rmse, rrmse] = calculateErrors(ground_truth, predicted_data)
    % Size check
    if length(ground_truth) ~= length(predicted_data)
        error('Input must be in the same size.');
    end

    % Calculate Max Abs Error
    max_abs_err = max(abs(ground_truth - predicted_data));

    % Initialization
    mean_rel_err = 0;
    sum = 0;
    num_order = 10^(floor(log10(abs(max(ground_truth)))));

    % Calculate Mean Relative Error
    for i = 1:length(predicted_data)
        if ground_truth(i) > 0.05 * num_order
            rel_err = abs(ground_truth(i) - predicted_data(i)) / (ground_truth(i) + 0.001 * num_order);
            mean_rel_err = mean_rel_err + rel_err;
            sum = sum + 1;
        end
    end

    if sum > 0
        mean_rel_err = mean_rel_err * 100 / sum;
    else
        mean_rel_err = NaN; % No valid value
    end

    % Calculate RMSE&rRMSE
    mse = mean((ground_truth - predicted_data).^2);
    rmse = sqrt(mse);
    rrmse = sqrt(mse/mean(predicted_data.^2));
end