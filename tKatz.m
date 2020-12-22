function score = tKatz(lambda, S, A, N_u, N_g, beta)
% Calculating the score matrix for the purpose of affiliation recommendation 
% Based on the Graph Proximity Model

% We will take care of k in a way that if a change in magnitude of corresponding
% entries is less than some chosen epsilon than iteration stops

C = [lambda*S, A; A', zeros(N_g, N_g)];

epsilon = 1e-5;
diffr = zeros(N_u, N_g);
diffr(:,:) = epsilon;

if lambda == 0
  score = beta*A*A'*A;
  prevscore = zeros(N_u, N_g);
  k = 2;
  while(sum(sum((score - prevscore) > diffr))>0)
  prevscore=score;
  score = prevscore + beta^k*(A*A')^k*A;
  k = k+1;
  endwhile
  return
endif

if lambda > 0
  score = beta*C(1:N_u,N_u+1:end);
  prevscore = zeros(N_u, N_g);
  k = 2;
  while(sum(sum((score - prevscore) > diffr))>0)
  prevscore=score;
  score = prevscore + beta^k*(C^k)(1:N_u,N_u+1:end);
  k = k+1;
  endwhile
endif


endfunction