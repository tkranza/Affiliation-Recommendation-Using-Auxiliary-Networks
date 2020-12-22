function C = WSsetdiff(A, B)
% Without sort set difference
% Function which returns the set difference of sets A i B (A\B), similar to setdiff(),
% but elements stay in the original order

A(find(ismember(A, B))) = [];

C = A;

endfunction