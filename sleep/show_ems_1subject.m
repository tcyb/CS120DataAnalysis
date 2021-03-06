clear;

addpath('../Functions/');

subject = '1013558';

data_dir = 'C:\Users\Sohrob\Dropbox\Data\CS120';

tab = readtable([data_dir, '\', subject, '\ems.csv'],'readvariablenames',false,'delimiter','\t');

figure;
% plot(tab.Var1, 1*ones(size(tab,1),1), '.');
hold on;
plot(tab.Var2/1000, 2*ones(size(tab,1),1), '.');
plot(tab.Var3/1000, 3*ones(size(tab,1),1), '.');
plot(tab.Var4/1000, 4*ones(size(tab,1),1), '.');
plot(tab.Var5/1000, 5*ones(size(tab,1),1), '.');
ylim([0 6]);
set_date_ticks(gca, 7);


figure;
subplot 211;
histogram((tab.Var4-tab.Var3)/1000/3600,24);
xlabel('sleep duration (hours)');
subplot 212;
histogram((tab.Var5-tab.Var2)/1000/3600,24);
xlabel('bed duration (hours)');