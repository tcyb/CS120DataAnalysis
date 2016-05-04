clear;
close all;

addpath('../functions');
addpath('../Regressors');

n_bootstrap = 12*2;
n_tree = 100;

% delete(gcp('nocreate'));
% pool = parpool(24);

load('../FeatureExtraction/features_biweekly_all.mat');
% load('../FeatureExtraction/features_biweekly_weekend.mat');
% load('../FeatureExtraction/features_biweekly_weekday.mat');
% load('../FeatureExtraction/features_biweekly_offday.mat');
% load('../FeatureExtraction/features_biweekly_workday.mat');
load('../Assessment/phq9.mat');
load('../Assessment/gad7.mat');
load('../Assessment/spin.mat');
load('../Assessment/tipi.mat');
load('../Assessment/psqi.mat');
load('../Demographics/demo_basic.mat');
load('../Demographics/demo_baseline.mat');

% PHQ-9 change
% from baseline to week 3
cnt = 1;
for i = 1:length(phq.w3),
    ind = find(strcmp(subject_phq.w0, subject_phq.w3{i}));
    if ~isempty(ind),
        subject_phq03{cnt} = subject_phq.w3{i};
        phq03(cnt) = phq.w3(i) - phq.w0(ind);
        cnt = cnt+1;
    end
end
        
% from week 3 to 6
cnt = 1;
for i = 1:length(phq.w6),
    ind = find(strcmp(subject_phq.w3, subject_phq.w6{i}));
    if ~isempty(ind),
        subject_phq36{cnt} = subject_phq.w6{i};
        phq36(cnt) = phq.w6(i) - phq.w3(ind);
        cnt = cnt+1;
    end
end

% target assessment
assessment = psqi.w6;
subject_assessment = subject_psqi.w6;

% remove if NaN (for big5 only) %%%%%%%%%%
indnan = isnan(assessment);
assessment(indnan) = [];
subject_assessment(indnan) = [];

% which 2-week blocks to consider for the analysis
win_to_analyze = 1;%[1 2 3 4 5];

R2 = zeros(length(win_to_analyze), n_bootstrap);

for win = win_to_analyze,
    
    fprintf('win #%d\n',win);
    
    cnt = 1;
    target = [];
    feature_new = [];
    
    for i=1:length(subject_assessment),

        % find subject in feature data
        ind_ft = find(strcmp(subject_feature, subject_assessment{i}));
        
        % skip if subject doesn't have data up to current 2-week block
        if size(feature{ind_ft},1)<win,
            continue;
        end
        
        % find subject in Big5 data
        ind_tipi = find(strcmp(subject_tipi, subject_assessment{i}));

        % find subject in demo data
        ind_demo_basic = find(strcmp(subject_basic, subject_assessment{i}));
        ind_demo_baseline = find(strcmp(subject_baseline, subject_assessment{i}));
        
        if ~isempty(ind_ft),
            target(cnt,1) = assessment(i);
            feature_new{cnt} = [feature{ind_ft}(win,:), ...
                age(ind_demo_basic), female(ind_demo_basic), ...   % adding in age and gender
                alone(ind_demo_baseline), sleepalone(ind_demo_baseline), employed(ind_demo_baseline), numjobs(ind_demo_baseline)]; % adding in other demo info
%                 tipi(ind_tipi, :)]; % adding big5
            %subject_analyze{cnt} = subject_assessment{i};
            cnt = cnt+1;
        else
            disp('subject from assessment was not found in feature data.');
        end
        
    end
    
    feature_all = combine_subjects(feature_new);
    
    % zscore
    % feature_all = myzscore(feature_all);

    % breaking data into 'meta-training' and 'meta-test' for feature selection
    ind_metatrain = randsample(1:size(feature_all,1), size(feature_all,1)*.5, false);
    ind_metatest = 1:size(feature_all,1);
    ind_metatest(ind_metatrain) = [];
    
    feature_metatrain = feature_all(ind_metatrain,:);
    target_metatrain = target(ind_metatrain);
    feature_metatest = feature_all(ind_metatest,:);
    target_metatest = target(ind_metatest);

    ind_good = 1;
    R2(win,:) = rf_regressor(feature_metatrain(:,ind_good), target_metatrain, n_tree, n_bootstrap);
    fprintf('R2: %.3f (%.3f)\n', mean(R2(win,:)), std(R2(win,:))/sqrt(n_bootstrap));
    fprintf('first pass...\n');
    for i=2:size(feature_metatrain,2),
        R2_new = rf_regressor(feature_metatrain(:,[ind_good, i]), target_metatrain, n_tree, n_bootstrap);
        if mean(R2_new)>mean(R2(win,:)),
            ind_good = [ind_good, i];
            R2(win,:) = R2_new;
            fprintf('New R2: %.3f (%.3f)\n', mean(R2(win,:)), std(R2(win,:))/sqrt(n_bootstrap));
            fprintf('% d', ind_good);
            fprintf('\n');            
        end
    end
    fprintf('second pass...\n');
    for i=1:length(ind_good),
        inds = ind_good([1:i-1,i+1:end]);
        inds(isnan(inds)) = [];
        R2_new = rf_regressor(feature_metatrain(:,inds), target_metatrain, n_tree, n_bootstrap);
        if mean(R2_new)>mean(R2(win,:)),
            ind_good(i) = nan;
            R2(win,:) = R2_new;
            fprintf('New R2: %.3f (%.3f)\n', mean(R2(win,:)), std(R2(win,:))/sqrt(n_bootstrap));
            fprintf('% d', ind_good);
            fprintf('\n');            
        end
    end
    ind_good(isnan(ind_good)) = [];
    fprintf('final set: ');
    fprintf('%d ',ind_good);
    fprintf('\n');

    fprintf('Meta-Training R2: %.3f (%.3f)\n', mean(R2(win,:)), std(R2(win,:))/sqrt(n_bootstrap));
    
    R2_metatest(win,:) = rf_regressor(feature_metatest(:,ind_good), target_metatest, n_tree, n_bootstrap);

    fprintf('Meta-Test R2: %.3f (%.3f)\n', mean(R2_metatest(win,:)), std(R2_metatest(win,:))/sqrt(n_bootstrap));
    
%     target_all = combine_subjects(target_all);
%     out_all = combine_subjects(out_all);
    
end

% save('prediction.mat', 'R2', 'out_all', 'target_all');
save('results/prediction.mat', 'R2');
