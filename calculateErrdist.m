function rrmse = calculateErrdist(ground_truth, predicted_data)
    % Size check
    if size(ground_truth) ~= size(predicted_data)
        error('Input must be of the same size.');
    end

    % Calculate rRMSE
    mse = mean((ground_truth - predicted_data).^2,2);
    rrmse = sqrt(mse./mean(predicted_data.^2,2));
end