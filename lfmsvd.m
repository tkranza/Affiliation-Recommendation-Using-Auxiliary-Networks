function [score] = lfmsvd(lambda, S, A, D, d)
% SVD method of lfm

N_u = size(A)(1,1);
N_g = size(A)(1,2);

C = [lambda*S, A; A', D];

[U,S,V] = svd(C);

V1 = U(1:N_u, 1:d);
L = S(1:d, 1:d);
V2 = V((N_u + 1):end, 1:d);

score = V1 * L * V2';

endfunction