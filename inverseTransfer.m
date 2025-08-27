function vec = inverseTransfer(griddata, transmatrix)
    % Determine vector length
    maxVal = max(transmatrix(:));
    vec = zeros(maxVal + 1,1);

    % Store the count for each grid point
    counts = zeros(maxVal + 1,1);

    % Iterate through transmatrix and griddata
    for i = 1:size(transmatrix, 1)
        for j = 1:size(transmatrix, 2)
            % Get the current index
            id = transmatrix(i, j) + 1;

            % Check index
            if id <= maxVal + 1
                % Sum up the values and update the count
                vec(id) = vec(id) + griddata(i, j);
                counts(id) = counts(id) + 1;
            end
        end
    end

    % Average over all the values for each grid point
    for i = 1:maxVal + 1
        if counts(i) > 0
            vec(i) = vec(i) / counts(i);
        end
    end
end