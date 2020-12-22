function suma = Val(score, train, test, gi, n)
% Function which counts how many in n recommendations are good recommendations, per every user

N_u = size(train, 1);
N_g = size(train, 2);

suma = 0;

recommend = GroupRecommend(score, gi);

for i = 1 : N_u
  gidx1 = gi(find(test(i, :) == 1));
  
  res = recommend(i, :);
  res = WSsetdiff(res, gi(find(train(i,:) == 1)));
  res = res(1:n);
  
  nel = 0;
  for j = 1 : length(gidx1)
    if(sum(res == gidx1(j))) == 1
      nel = nel + 1;
    endif
  endfor
  
  suma = suma + nel;  
  
endfor

endfunction