function [train, validation, test] = SplitData(A)
% Train/validation/test are going to be matrices of dimensions N_u x N_g which 
% are going to represent the edges of user i which are taken for given dataset

N_u=size(A)(1,1);
N_g=size(A)(1,2);

train = zeros(N_u,N_g);
validation = zeros(N_u,N_g);
test = zeros(N_u,N_g);
  
% First, we seperate for test
for i=1:N_u
  whereone = find(A(i,:)==1);
  len=length(whereone);
  % Here, it can be 0 for some user so our test dataset will be 0 for him
  rand_test_ind = ceil(rand(1, round(3/10*length(whereone))) * length(whereone));
  test(i,whereone(rand_test_ind)) = 1;
endfor
  
% Now for training, including validation
for i=1:N_u
  whereone = find(A(i,:)==1);
  whereoneT = find(test(i,:)==1);
  [tf, idx] = ismember(whereoneT,whereone);
  whereone(idx) = [];
   
  len=length(whereone);
  rand_val_ind = ceil(rand(1, round(3/10*length(whereone))) * length(whereone));
  validation(i,whereone(rand_val_ind)) = 1; 

% The rest of the training set
  whereone(rand_val_ind) = [];
  train(i, whereone) = 1;
endfor

  
endfunction
