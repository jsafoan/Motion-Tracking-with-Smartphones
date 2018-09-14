%NOTE: Need Static Data alongside for most recent Bias

Acc = csvread("9m_15Steps/Accelerometer.csv");
Gyr = csvread("9m_15Steps/Gyroscope.csv");
MaF = csvread("9m_15Steps/MagneticField.csv");
[biasAcc, biasGyro] = getSensorsBias();     %Must be new Static Data as Bias changes everyday
t = Acc(:,1); t = (t - t(1)) .* 10^-9;
localAcc = [Acc(:, 2) - biasAcc(1), Acc(:, 3) - biasAcc(2), Acc(:, 4) - biasAcc(3)];
localGyr = Gyr(:, 2:4) - biasGyro;
localMaF = MaF(:, 2:4);
minSize = min(min(size(localAcc, 1), size(localGyr, 1)), size(localMaF, 1));

g = 9.8062; % Gravity at Champaign
rotMatrix = zeros(3, 3, minSize);
globalAcc = zeros(minSize, 3);

rotMatrix(:, :, 1) = getRotationMatrixFromGravityMagnet(mean(localAcc(1:20, :)), mean(localMaF(1:20, :)));
for i = 2 : minSize
    rotMatrix(:, :, i) = rotMatrix(:, :, i - 1) * getDeltaRotMatrixFromGyro(localGyr(i, :), t(i) - t(i - 1));
    globalAcc(i,:) = (rotMatrix(:,:,i) * localAcc(i,:)')';
end


magNoGZ = globalAcc(:,3) - mean(globalAcc(:,3));
[locs, pks] = countSteps(magNoGZ);
numSteps = (numel(pks) - 1) * 2;


velx = cumtrapz(t(1:size(globalAcc, 1)), globalAcc(:, 1));
vely = cumtrapz(t(1:size(globalAcc, 1)), globalAcc(:, 2));

disx = trapz(t(1:size(globalAcc, 1)), velx);
disy = trapz(t(1:size(globalAcc, 1)), vely);
dist = sqrt(disx^2 + disy^2);


if(dist > 6)        %Starts to diverge beyond 6m distance approx
    
    magNoG = globalAcc(:,3) - mean(globalAcc(:,3)); 
    minPeakHeight = 1.80*std(magNoG);   %Change 1.78(threshold) to adjust to accuracy
    [pks,locs] = findpeaks(magNoG, 'MINPEAKHEIGHT', minPeakHeight);
    locs = transpose(locs);


    %Reset orientation at every step
        locs = transpose(locs);
        locs = cat(1,1,locs);
    for i=1:size(locs,1);   
      if i+1 <= size(locs,1)        %so matrix doesnt exceed dimensions
         for j = locs(i)+1 : locs(i+1)-1 %Integrate gyro in between two locs
            rotMatrix(:, :, j) = rotMatrix(:, :, j - 1) * getDeltaRotMatrixFromGyro(localGyr(j, :), t(j) - t(j - 1));
            newglobalAcc(j,:) = (rotMatrix(:,:,j) * localAcc(j,:)')';
         end
      end
       %Get from acc and mag for every locs
       rotMatrix(:, :, locs(i)) = getRotationMatrixFromGravityMagnet(mean(localAcc(1:20, :)), mean(localMaF(1:20, :))); 
    end
 
velx = cumtrapz(t(1:size(newglobalAcc, 1)), newglobalAcc(:, 1));
vely = cumtrapz(t(1:size(newglobalAcc, 1)), newglobalAcc(:, 2));

disx = trapz(t(1:size(newglobalAcc, 1)), velx);
disy = trapz(t(1:size(newglobalAcc, 1)), vely);
dist = sqrt(disx^2 + disy^2);
    
end 
