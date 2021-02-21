%%K-fold pooling
clc
close all;
clear
%% load features and mos
load 'Win5LIDMOS'
load Win5LID_4DDCT_features;
%%input and output
input_NR = [Win5LID_4DDCT_features];%30
lower=-1; upper=1;
%% Êä³ö
output = Win5LIDMOS;
scene_num = 10;% if NBU-LF1.0 database, scene_num is 14
xulie_num = 1:scene_num;% Range of the number of database scenes 
folds_num = 2;
all_num = factorial(scene_num)/(factorial(scene_num-folds_num)*factorial(folds_num));
fork_num = zeros(all_num,folds_num);
c_num = 0;
% All combinations:Win5-LID is 45, NBU-LF1.0 is 91
for ii = 1:scene_num-1
    for jj = 2:scene_num
        if ii < jj 
            c_num = c_num + 1;
            fork_num(c_num,:) = [ii,jj];
        end
    end
end
%% k-fold cross validation
k = 0;
%%WIN5D
for i = 1:10%% one scene as one chunk
    k=k+1;
    input_code_NR{k,:}=input_NR([1+(i-1),(11+(i-1)*5):(15+(i-1)*5),(61+(i-1)*5):(65+(i-1)*5),(111+(i-1)*5):(115+(i-1)*5),(161++(i-1)*5):(165+(i-1)*5),211+(i-1)],:);
    
    output_code{k,:}=output([1+(i-1),(11+(i-1)*5):(15+(i-1)*5),(61+(i-1)*5):(65+(i-1)*5),(111+(i-1)*5):(115+(i-1)*5),(161++(i-1)*5):(165+(i-1)*5),211+(i-1)],:);
end

i=7;
j=2;
for fork=1:all_num
    test = fork_num(fork,:);
    train = xulie_num(~ismember(xulie_num,test));
    %test data
    for m=1:size(test',1)
        input_test_NR(1+22*(m-1):(22*m),:)=input_code_NR{test(m)};
        output_test(1+22*(m-1):(22*m),:)=output_code{test(m)};
    end
    %trainging data
    for n=1:size(train',1)
        input_train_NR(1+22*(n-1):(22*n),:)=input_code_NR{train(n)};
        output_train(1+22*(n-1):(22*n),:)=output_code{train(n)};
    end
    %% normalization
    [input_train_NR,MAX,MIN]=normalization(input_train_NR,lower,upper);
    input_test_NR = normalization(input_test_NR,lower,upper,MAX,MIN);
    %%SVR parameters
    cost = 2^(i-5);
    gamma = 2^(j-5);
    c_str = sprintf('%f',cost);
    g_str = sprintf('%.2f',gamma);
    libsvm_options = ['-s 3 -t 2 -g ',g_str,' -c ',c_str];
    model = svmtrain(output_train,input_train_NR,libsvm_options);
    [predict_score, ~, ~] = svmpredict(zeros(size(output_test)), input_test_NR, model);
    pearson_cc_NR(fork) = IQAPerformance(predict_score, output_test,'p');
    spearman_srocc_NR(fork) = IQAPerformance(predict_score, output_test,'s');
    rmse_NR(fork)  = IQAPerformance(predict_score, output_test,'e');
end
pearson_plcc_all = mean(abs(pearson_cc_NR));
spearman_srocc_all = mean(abs(spearman_srocc_NR));
rmse_all = mean(abs(rmse_NR));