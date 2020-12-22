function [sensitivity, onemspecificity] = AvgSenSpec(score, train, test, gi, n)
% Function which returns average sensitivity and average (1-specificity)
% sensitivity = TP/(TP + FN)
% specificity = TN/(TN + FP)
% TP...true positives, FN...false negatives, TN...true negatives, FP...false positives

N_u = size(train, 1);
N_g = size(train, 2);

denominator = zeros(1, N_u);

for i = 1 : N_u
  denominator(i) = length(find(test(i, :) == 1));
endfor

suma1 = 0;
suma2 = 0;

recommend = GroupRecommend(score, gi);

for i = 1 : N_u
  gidx1 = gi(find(test(i, :) == 1));
  gidx2 = gi(find(test(i, :) == 0));
  
  res = recommend(i, :);
  % (res\gi(find(train(i,:) == 1)))
  res = WSsetdiff(res, gi(find(train(i,:) == 1)));
  res = res(1:n);
  
  nel = 0;
  for j = 1 : length(gidx1)
    if(sum(res == gidx1(j))) == 1
      nel = nel + 1;
    endif
  endfor
  
  if(denominator(i) != 0)
    suma1 = suma1 + nel/denominator(i);
  endif
  
  % (gidx2\gi(find(train(i,:) == 1)))
  gidx2 = WSsetdiff(gidx2, gi(find(train(i,:) == 1)));
  %length(gidx2) = TN + FP
  
  % (gidx2\res)
  TN = WSsetdiff(gidx2, res);
  
  suma2 = suma2 + length(TN)/length(gidx2);  
  
endfor

sensitivity = 1/N_u * suma1;

specificity = 1/N_u * suma2;

onemspecificity = 1 - specificity;

endfunction