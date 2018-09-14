function [biasAcc, biasGyro] = getSensorsBias()

staticGyr = csvread("static_5sec/Gyroscope.csv");
biasGyro = mean(staticGyr(:, 2:4));

Acc_1 = csvread("AccBias/Position_1/Accelerometer.csv");
ax1 = mean(Acc_1(:,2)); ay1 = mean(Acc_1(:,3)); az1 = mean(Acc_1(:,4));
Acc_2 = csvread("AccBias/Position_2/Accelerometer.csv");
ax2 = mean(Acc_2(:,2)); ay2 = mean(Acc_2(:,3)); az2 = mean(Acc_2(:,4));
Acc_3 = csvread("AccBias/Position_3/Accelerometer.csv");
ax3 = mean(Acc_3(:,2)); ay3 = mean(Acc_3(:,3)); az3 = mean(Acc_3(:,4));
Acc_4 = csvread("AccBias/Position_4/Accelerometer.csv");
ax4 = mean(Acc_4(:,2)); ay4 = mean(Acc_4(:,3)); az4 = mean(Acc_4(:,4));
Acc_5 = csvread("AccBias/Position_5/Accelerometer.csv");
ax5 = mean(Acc_5(:,2)); ay5 = mean(Acc_5(:,3)); az5 = mean(Acc_5(:,4));
Acc_6 = csvread("AccBias/Position_6/Accelerometer.csv");
ax6 = mean(Acc_6(:,2)); ay6 = mean(Acc_6(:,3)); az6 = mean(Acc_6(:,4));

% Sxx = (ax2 - ax4) / 2;
% Syy = (ay1 - ay3) / 2;
% Szz = (az5 - az6) / 2;

biasAcc(1) = (ax1 + ax3 + ax5 + ax6) / 4;
biasAcc(2) = (ay2 + ay4 + ax5 + ax6) / 4;
biasAcc(3) = (az1 + az2 + az3 + az4) / 4;