function [score] = LFM(lambda, S, A, D, d)
% We calculate rank-d dominant spectral aproximation, because C is going to be
% real square symmetric matrix that will be possible, and we take d
% first (greatest) eigenvalues (vectors)

N_u = size(A)(1,1);
N_g = size(A)(1,2);

C = [lambda*S, A; A', D];

[V, LAMBDA] = eig(C);

% Now we sort matrix LAMBDA so that eigenvalues are in descending order
% then, we sort the eigenvectors in matric V by same order

[S I] = sort(diag(LAMBDA), "descend");
LAMBDA_novi = diag(S);

V_novi = zeros(N_u + N_g, N_u + N_g);
for i=1:(N_u + N_g)
  V_novi(:, i) = V(:, I(i));
endfor

V1 = V_novi(1:N_u, 1:d);
L = LAMBDA_novi(1:d, 1:d);
V2 = V_novi((N_u + 1):end, 1:d);

score = V1 * L * V2';


% We will get aproximations because numbers are very small
% we won't get exact values
endfunction