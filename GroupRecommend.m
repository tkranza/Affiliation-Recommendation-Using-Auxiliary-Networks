function recommend = GroupRecommend (score, gi)
% Goal is to write a nice funtion to print sorted goups
% groups are sorted in descending order, and in matrix recommend are indices of groups
% if we want the n best groups for user i, we run recommend(i,1:n)

N_u = size(score, 1);
N_g = size(score, 2);

recommend = zeros(N_u,N_g);
for i = 1:N_u
  recommend(i,:)=gi;
endfor

for i = 1:N_u
  a = [score(i,:);gi'];
  [S,I]=sort(a(1,:),MODE="descend");
  result = [S;a(2,I)];
  recommend(i,:)=result(2,:);
  
endfor


endfunction
