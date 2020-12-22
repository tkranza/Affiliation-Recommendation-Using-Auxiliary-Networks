%% Affiliation Recommendation using Auxiliary Networks

%clear ; close all; clc

%% ==================== Part 1: Setting Up The Data ============================

% run the lower code if you want to change or experiment
% make sure to download the necessary .txt files 

%X = load("release-youtube-links.txt");
% size(unique(X(:,1)))(1,1)
% 570774
% size(unique(X(:,2)))(1,1)
% 1137638
% size(unique(X))
% unique 1138499

%Y = load("release-youtube-groupmemberships.txt");
% size(unique(Y(:,1)))(1,1)
% 94238
% size(unique(Y(:,2)))(1,1)
% 30087

%[A,S,ui,gi] = FormData(X,Y,1000);
%dlmwrite('matrix A.txt', A);
%dlmwrite('group index.txt', gi);
%dlmwrite('matrix S.txt', S);
%dlmwrite('user index.txt', ui);
A=dlmread('matrix A.txt');
gi=dlmread('group index.txt');
S=dlmread('matrix S.txt');
ui=dlmread('user index.txt');
%for 500 it took 15 min
%for 1000 about 50 min

N_u = size(A)(1,1);
N_g = size(A)(1,2);

fprintf('Adjacency matrix of affiliation network A calculated.\n');
fprintf('Adjacency matrix of friendship network S calculated.\n');

% We have a connected graph, to check uncomment lower code (takes time)
% IsConnected(S)

fprintf('Visualizing given adjacency matrix.\n');
imagesc(A');
ylabel('Groups');
xlabel('Users');

fprintf('Program paused. Press enter to continue.\n');
pause;

%% =============== Part 2: Descriptive Statistics For Our Data =================

fprintf('Descriptive Statistics for our network:\n');
fprintf('Number of users in our network: %d\n', N_u);
fprintf('Number of groups in our network: %d\n', N_g);
fprintf('Average number of groups per user: %d\n', mean(sum(A,2)));
fprintf('Minimum number of groups per user: %d\n', min(sum(A,2)));
fprintf('Mode of number of groups per user: %d\n', mode(sum(A,2)));
fprintf('Average number of users per group: %d\n', mean(sum(A)));
fprintf('Mode of number of users per group: %d\n', mode(sum(A)));
fprintf('Minimum number of users per group: %d\n', min(sum(A)));
fprintf('Average number of friends per user: %d\n', mean(sum(S)));
fprintf('Mode of number of friends per user: %d\n', mode(sum(S)));

fprintf('Program paused. Press enter to continue.\n');
pause;

%% ==================== Part 3: Train, Validation, Test Datasplit ==============
% A is split into 3 parts(datasets): train, validation, test
% using the validation set we will choose the best parameters for the 2 models,
% and on test dataset we will evaluate their final performance

[train, validation, test] = SplitData(A);

fprintf('Data successfully split into train, validation and test.\n');

fprintf('Program paused. Press enter to continue.\n');
pause;

%% ==================== Part 4: Validation Process =============================

LAMBDA = zeros(1, 15);
LAMBDA(2:5) = [0.01 0.02 0.04 0.08];
for i = 1 : 10
  LAMBDA(i+5) = i * 10^(-1);
endfor  

beta = zeros(1, 25);
for i = 1 : length(beta)
  if(mod(i, 2) == 1)
    beta(i) = 1 * 10^(-(i-1)/2);
  endif
  if(mod(i, 2) == 0)
    beta(i) = 3 * 10^(-(i)/2);
  endif
endfor 

d = 10:10:100;

% lower code takes time, results are already entered
% 2s are found parameter for n = [2 4 6 8 10 12] and val(n=25)

%Validation for Katz(C)
%bestlambdaKC = LAMBDA(1);
%bestbetaKC = beta(1);
%bestval = 0;
%for i = 1 : length(LAMBDA)
  %for j = 1 : length(beta)
    %val = Val(AltKatz(LAMBDA(i), S, train, beta(j)), train+test, validation, gi, 15);
    %if(val > bestval)
      %bestval = val;
      %bestlambdaKC = LAMBDA(i);
      %bestbetaKC = beta(j);
    %endif
  %endfor
%endfor

bestlambdaKC = 0.02;
bestbetaKC = 0.01;
%bestlambdaKC2 = 0.4;
%bestbetaKC2 = 0.03;

%Validation for Katz(A)
%bestbetaKA = beta(1);
%bestval = 0;
%for j = 1 : length(beta)
  %val = Val(AltKatz(0, S, train, beta(j)), train+test, validation, gi, 15);
  %if(val > bestval)
    %bestval = val;
    %bestbetaKA = beta(j);
  %endif
%endfor

bestbetaKA = 1*10^(-12);
%bestbetaKA2 = 3*10^(-10);

%Validation for LFM(C)
%bestlambdaLFMC = LAMBDA(1);
%bestdLFMC = d(1);
%bestval = 0;
%for i = 1 : length(d)
  %for j = 1 : length(LAMBDA)
    %val = Val(LFM(LAMBDA(j), S, train, zeros(N_g, N_g), d(i)), train+test, validation, gi, 15);
    %if(val > bestval)
      %bestval = val;
      %bestdLFMC = d(i);
      %bestlambdaLFMC = LAMBDA(j);
    %endif
  %endfor
%endfor

bestlambdaLFMC = 0.7;
bestdLFMC = 40;
#bestlambdaLFMC2 = 0.7;
#bestdLFMC2 = 10;

%Validation for LFM(A)
%bestdLFMA = d(1);
%bestval = 0;
%for i = 1 : length(d)
  %val = Val(LFM(0, S, train, zeros(N_g, N_g), d(i)), train+test, validation, gi, 15);
  %if(val > bestval)
    %bestval = val;
    %bestdLFMA = d(i);
  %endif
%endfor

bestdLFMA = 20;
%bestdLFMA2 = 10;

%Validation for LFM(C, D)
%bestlambdaLFMCD = LAMBDA(1);
%bestdLFMCD = d(1);
%bestval = 0;
%for i = 1 : length(d)
  %for j = 1 : length(LAMBDA)
    %val = Val(LFM(LAMBDA(j), S, train, train'*train, d(i)), train+test, validation, gi, 15);
    %if(val > bestval)
      %bestval = val;
      %bestdLFMCD = d(i);
      %bestlambdaLFMCD = LAMBDA(j);
    %endif
  %endfor
%endfor

bestlambdaLFMCD = 0.8;
bestdLFMCD = 20;
%bestlambdaLFMCD2 = 1;
%bestdLFMCD2 = 10;

fprintf('Best parameters found for Katz(A): Beta = %d\n', bestbetaKA);
fprintf('Best parameters found for Katz(C): Beta = %d, Lambda =  %d\n', bestbetaKC, bestlambdaKC);
fprintf('Best parameters found for LFM(A): d = %d\n', bestdLFMA);
fprintf('Best parameters found for LFM(C): d = %d, Lambda =  %d\n', bestlambdaLFMC, bestdLFMC);
fprintf('Best parameters found for LFM(C, D) where D = t(A)*A : d = %d, Lambda =  %d\n', bestdLFMCD, bestlambdaLFMCD);

fprintf('Program paused. Press enter to continue.\n');
pause;

%% ==================== Part 5: Generating Score Matrices ======================

n = [5, 10, 15, 20, 25, 30];

fprintf('Calculating score matrices...\n');

score1 = AltKatz(0, S, train, bestbetaKA);
senspec1 = zeros(2, length(n));
for i=1:length(n)
  [senspec1(1,i), senspec1(2,i)] = AvgSenSpec(score1, (train+validation), test, gi, n(i));
endfor

fprintf('1/4 Done...\n');

score2 = AltKatz(bestlambdaKC, S, train, bestbetaKC);
senspec2 = zeros(2, length(n));
for i=1:length(n)
  [senspec2(1,i), senspec2(2,i)] = AvgSenSpec(score2, (train+validation), test, gi, n(i));
endfor

fprintf('2/4 Done...\n');

score3 = LFM(0, S, train, zeros(N_g, N_g), bestdLFMA);
senspec3 = zeros(2, length(n));
for i=1:length(n)
  [senspec3(1,i), senspec3(2,i)] = AvgSenSpec(score3, (train+validation), test, gi, n(i));
endfor

fprintf('3/4 Done...\n');

score4 = LFM(bestlambdaLFMC, S, train, zeros(N_g, N_g), bestdLFMC);
senspec4 = zeros(2, length(n));
for i=1:length(n)
  [senspec4(1,i), senspec4(2,i)] = AvgSenSpec(score4, (train+validation), test, gi, n(i));
endfor

fprintf('4/4 Done...\n');

%
%score5 = LFM(bestlambdaLFMCD, S, train, train'*train, bestdLFMCD);
%senspec5 = zeros(2, length(n));
%for i=1:length(n)
  %[senspec5(1,i), senspec5(2,i)] = AvgSenSpec(score5, (train+validation), test, gi, n(i));
%endfor

%fprintf('5/5 Done...\n');
%

fprintf('Program paused. Press enter to continue.\n');
pause;

%% ==================== Part 6: Plotting =======================================
% plotting

% Global evaluation metric
k = sum(sum(test));
a = zeros(1, 4);
fprintf('Calculating precision...\n');
a(1) = Prec(score1, train, test, k);
fprintf('1/4 Done...\n');
a(2) = Prec(score2, train, test, k);
fprintf('2/4 Done...\n');
a(3) = Prec(score3, train, test, k);
fprintf('3/4 Done...\n');
a(4) = Prec(score4, train, test, k);
fprintf('4/4 Done...\n');
figure;
bar(a)
ylabel("% Precision")
hold off;
labels = ['Katz(A)'; 'Katz(C)'; 'LFM(A)'; 'LFM(C)'];
set(gca, 'XTickLabel', labels);

%
% different from the paper, LFM(C, D) is worse than LFM(C)
% Comparing the effect of choosing different D for LFM model
%figure; plot(senspec4(2,:), senspec4(1,:), '+-');
%title('Various choices of D'), xlabel('(1 - avg. Specificity)'),
%ylabel('avg. Sensitivity')
%hold on; plot(senspec5(2,:), senspec5(1,:), '*-g');
%hold off;
%legend('LFM(C)', 'LFM(C, D)')
%

% Comparison of different models
figure; plot(senspec1(2,:), senspec1(1,:), '+-');
title('avg. Sensitivity vs (1 - avg. Specificity)'), xlabel('(1 - avg. Specificity)'),
ylabel('avg. Sensitivity')
hold on; plot(senspec2(2,:), senspec2(1,:), 'o-r'); 
plot(senspec3(2,:), senspec3(1,:), '*-g'); plot(senspec4(2,:), senspec4(1,:), 'x-y');
hold off;
legend('Katz(A)', 'Katz(C)', 'LFM(A)', 'LFM(C)')











