clear;
close all;

addpath('results');

h = figure;
set(h, 'position', [560   234   560   714]);

subplot 311;
load('prediction_phq_w0.mat');
plot([1 1],[0 .2],'g','linewidth',4); hold on;
errorbar(mean(R2,2), std(R2,[],2)/sqrt(size(R2,2)),'b');
load('prediction_gad_w0.mat');
errorbar(mean(R2,2), std(R2,[],2)/sqrt(size(R2,2)),'r');
set(gca,'xtick',1:5);
xlabel('Window #');
ylabel('R^2');
ylim([0 .2]);
xlim([1 5]);
legend('Assessment','PHQ-9','GAD-7','location','eastoutside');

subplot 312;
load('prediction_phq_w3.mat');
plot([3 3],[0 .2],'g','linewidth',4); hold on;
errorbar(mean(R2,2), std(R2,[],2)/sqrt(size(R2,2)),'b');
load('prediction_gad_w3.mat');
errorbar(mean(R2,2), std(R2,[],2)/sqrt(size(R2,2)),'r');
set(gca,'xtick',1:5);
xlabel('Window #');
ylabel('R^2');
ylim([0 .2]);
xlim([1 5]);
legend('Assessment','PHQ-9','GAD-7','location','eastoutside');

subplot 313;
load('prediction_phq_w6.mat');
plot([5 5],[0 .2],'g','linewidth',4); hold on;
errorbar(mean(R2,2), std(R2,[],2)/sqrt(size(R2,2)),'b');
load('prediction_gad_w6.mat');
errorbar(mean(R2,2), std(R2,[],2)/sqrt(size(R2,2)),'r');
set(gca,'xtick',1:5);
xlabel('Window #');
ylabel('R^2');
ylim([0 .2]);
xlim([1 5]);
legend('Assessment','PHQ-9','GAD-7','location','eastoutside');

h = figure;
set(h, 'position', [742   235   560   713]);
subplot 311;
load('prediction_audit.mat');
plot([1 1],[-.05 .2],'g','linewidth',4); hold on;
errorbar(mean(R2,2), std(R2,[],2)/sqrt(size(R2,2)),'b');
load('prediction_dast.mat');
errorbar(mean(R2,2), std(R2,[],2)/sqrt(size(R2,2)),'r');
set(gca,'xtick',1:5);
xlabel('Window #');
ylabel('R^2');
ylim([-.05 .2]);
xlim([1 5]);
legend('Assessment','AUDIT','DAST','location','eastoutside');

subplot 312;
load('prediction_spin.mat');
plot([1 1],[-.05 .2],'g','linewidth',4); hold on;
errorbar(mean(R2,2), std(R2,[],2)/sqrt(size(R2,2)),'b');
set(gca,'xtick',1:5);
xlabel('Window #');
ylabel('R^2');
ylim([-.05 .2]);
xlim([1 5]);
legend('Assessment','SPIN','location','eastoutside');

subplot 313;
plot([1 1],[-.05 .2],'g','linewidth',4); hold on;
for i=1:5,
    load(sprintf('prediction_big5_%d.mat',i));
    errorbar(mean(R2,2), std(R2,[],2)/sqrt(size(R2,2)));
end
set(gca,'xtick',1:5);
xlabel('Window #');
ylabel('R^2');
ylim([-.05 .2]);
xlim([1 5]);
legend('Assessment','Extraversion','Agreeableness','Conscientiousness','Neuroticism','Openness','location','eastoutside');

figure;
subplot 211;
plot([5 5],[-.05 .2],'g','linewidth',4); hold on;
load('prediction_phq_weekend.mat');
errorbar(mean(R2,2), std(R2,[],2)/sqrt(size(R2,2)),'b');
load('prediction_phq_weekday.mat');
errorbar(mean(R2,2), std(R2,[],2)/sqrt(size(R2,2)),'r');
legend('assessment','weekend','weekday','location','eastoutside');
set(gca,'xtick',1:5);
xlabel('Window #');
ylabel('R^2');
ylim([0 .2]);
xlim([1 5]);
title('PHQ-9 Prediction');
subplot 212;
plot([5 5],[-.05 .2],'g','linewidth',4); hold on;
load('prediction_gad_weekend.mat');
errorbar(mean(R2,2), std(R2,[],2)/sqrt(size(R2,2)),'b');
load('prediction_gad_weekday.mat');
errorbar(mean(R2,2), std(R2,[],2)/sqrt(size(R2,2)),'r');
legend('assessment','weekend','weekday','location','eastoutside');
set(gca,'xtick',1:5);
xlabel('Window #');
ylabel('R^2');
ylim([0 .2]);
xlim([1 5]);
title('GAD-7 Prediction');