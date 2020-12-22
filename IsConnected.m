function score = IsConnected(S)
% Checks if matrix is connected

N_u = size(S,1); 
  
suma = zeros(N_u, N_u);

for i = 1 : (N_u - 1)
  suma = suma + S^i;
endfor

score = isempty(find(suma == 0));
% Returns 1 if connected, otherwise 0

endfunction