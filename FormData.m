function [A,S,userindex,groupindex]= FormMatrix(X, Y, k)
% function which creates friendship network and affiliation network matrices
% k is a parameter which represents wanted number of users, i.e. N_u
% in the end, N_u could be lower

% X - user to user link matrix
% Y - user to group link matrix

uniq1 = unique(Y(:,1));
last_user = uniq1(k);
userindex = uniq1(1:k);
% users are already sorted in ascending order in given .txt file

% We have to calculate which is the last row in Y, i.e. last appearance of last_user
for i=1:length(Y(:,1))
  if Y(i,1) > last_user
    break
  endif
endfor

last_row=i-1;

% Creating the matrix A
firstdim = k;
seconddim = size(unique(Y(1:last_row,2)))(1,1);

A = zeros(firstdim, seconddim);
groupindex = unique(Y(1:last_row,2));

for i = 1:firstdim
  ix = find(Y(:,1)==userindex(i));
  lenix = length(ix);
  for n = 1:lenix
    for j = 1:seconddim
      if(Y(ix(n),2))==groupindex(j)
      % becuase of this, groups in columns of A will be sorted by groupindex
        A(i,j) = 1;
      endif
    endfor
  endfor
endfor
% Supposed Matrix A is created


% Creating the matrix S
S = zeros(firstdim, firstdim);

for i = 1:firstdim
  ix = find(X(:,1)==userindex(i));
  lenix = length(ix);
  for n = 1:lenix
    for j = 1:firstdim
      if(X(ix(n),2))==userindex(j)
        S(i,j) = 1;
      endif
    endfor
  endfor
endfor
% Supposed Matrix S is created


% Now, we have to set right the matrice in way that they dont have null-rows
% because, those are useless, and if we delete a row in S
% then we have to delete if from A aswell

lenS = firstdim;
rowsS = zeros(1, lenS);

for i=1:lenS
  if S(i,:) == zeros(1, lenS)
    rowsS(i) = 1;
  endif
endfor

userdel = find(rowsS == 1);

% Now we have to delete users from S and A which correspond to userdel, i.e. rows
  S(userdel,:)=[];
  S(:,userdel)=[];
  A(userdel,:)=[];

% We have to set right userindex
userindex = setdiff(userindex, userindex(userdel));
  
% We have to check if there aren't empty groups, if there are then delete them
% because we altered matrix A, so it is possible
colA=zeros(1, length(groupindex));
for i = 1 : length(groupindex)
  if A(:,i) == zeros(userindex,1)
    colA(i) = 1;
  endif 
endfor

groupdel = find(colA == 1);
A(:,groupdel)=[];
groupindex = setdiff(groupindex, groupindex(groupdel));

endfunction












