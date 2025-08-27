function griddata = transfer(vec, transmatrix)
    % Initialization
    griddata = zeros(size(transmatrix));
    
    % Iterate through transmatrix
    for i = 1:size(transmatrix, 1)
        for j = 1:size(transmatrix, 2)
            % Get the current index
            id = transmatrix(i, j) + 1; % MATLAB starts from 1
            
            % Check index
            if id <= length(vec)
                % Assign value from vec to griddata
                griddata(i, j) = vec(id);
            else
                % Deal with out-of-bound element
                griddata(i, j) = 0;
                warning("transmatrix does not match")
            end
        end
    end
end