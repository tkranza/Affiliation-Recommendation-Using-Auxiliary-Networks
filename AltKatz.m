function score = AltKatz(lambda, S, A, beta)
% Alternative way to calculate Katz measure

N_u = size(A,1);
N_g = size(A,2);  
  
C = [lambda * S, A; A', zeros(N_g, N_g)];

score = (inv(eye(N_u + N_g) - beta*C) - eye(N_u+N_g))(1:N_u, (N_u+1):end);


endfunction