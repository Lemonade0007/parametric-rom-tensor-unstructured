function [phi,beta,energy]=POD_multi(Data, tol)
global means;
global phi_num;
means=mean(Data, 2);
% stds =std(Data,0, 'all');
Data= bsxfun(@minus, Data, means);

%Data = Data / stds;
[m,n]=size(Data);

% SVD
Q=Data'*Data;
[V,D]=eig(Q);
[~,ind] = sort(diag(D),"descend");
D = D(ind,ind);

V = V(:,ind);
total_energy=sum(diag(D));
energy=0;
for j=1:n
    energy=energy+D(j,j);
    if energy>tol*total_energy
        phi_num=j;
        fprintf('Explained variance: %.4f%%\n', 100*energy/total_energy);
        break;
    end
end


phi=zeros(m,phi_num);

for j=1:phi_num
    phi(:,j)=Data*V(:,j)/D(j,j);
    %disp(D(j,j));
end
leg=sqrt(sum(phi.^2));  % Calculate the norm of each column
phi=bsxfun(@rdivide,phi,leg);   % Normalize
phi=fillmissing(phi,"constant",0);  % Fill in 0 for missing values
beta=phi'*Data;   % Calculate POD coefficients
end