function [res] = Prec(score, train, test, n)
% Function which returns precision (global)...Precision = TP/n... (n = TP + FP)

N_u = size(test, 1);
N_g = size(test, 2);

vec = [];
for i = 1 : N_u
  vec = [vec, score(i, :)];  
endfor

[S, I] = sort(vec, 'descend');

% We have to ignore those from matrix train
%==========================================
vectrain = [];
for i = 1 : N_u
  vectrain = [vectrain, train(i, :)];  
endfor
[Strain, Itrain] = sort(vectrain, 'descend');
delel = Itrain(1:sum(sum(train)));
I = WSsetdiff(I, delel);
%==========================================

useridx = zeros(1, n);
groupidx = zeros(1, n);
for i = 1 : n
  if(I(i)/N_g != floor(I(i)/N_g))
    useridx(i) = floor(I(i)/N_g) + 1;
  else 
    useridx(i) = I(i)/N_g;
  endif

  if(mod(I(i), N_g) != 0)
    groupidx(i) = mod(I(i), N_g);
  else
    groupidx(i) = N_g;
  endif
endfor

res = 0;
for i = 1 : n
  if(test(useridx(i), groupidx(i)) == 1)
    res = res + 1;
  endif
endfor

res = res/n*100;

endfunction