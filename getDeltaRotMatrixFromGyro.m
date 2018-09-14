function deltaRotMat = getDeltaRotMatrixFromGyro(gyro, dt)

w = 1;
x = 0.5 * dt * gyro(1);
y = 0.5 * dt * gyro(2);
z = 0.5 * dt * gyro(3);

sinr = 2.0 * (w * x + y * z);
cosr = 1.0 - 2.0 * (x * x + y * y);
roll = atan2(sinr, cosr);

sinp = 2.0 * (w * y - z * x);
if (abs(sinp) >= 1)
    if (sinp >= 0) 
        pitch = pi / 2;
    else
        pitch = -pi / 2;
    end
else
    pitch = asin(sinp);
end

siny = 2.0 * (w * z + x * y);
cosy = 1.0 - 2.0 * (y * y + z * z);
yaw = atan2(siny, cosy);

deltaRotMat(1, 1) = cos(yaw)*cos(pitch); deltaRotMat(1, 2) = cos(yaw)*sin(pitch)*sin(roll) - sin(yaw)*cos(roll); deltaRotMat(1, 3) = cos(yaw)*sin(pitch)*cos(roll) + sin(yaw)*sin(roll);
deltaRotMat(2, 1) = sin(yaw)*cos(pitch); deltaRotMat(2, 2) = sin(yaw)*sin(pitch)*sin(roll) + cos(yaw)*cos(roll); deltaRotMat(2, 3) = sin(yaw)*sin(pitch)*cos(roll) - cos(yaw)*sin(roll);
deltaRotMat(3, 1) = -sin(pitch); deltaRotMat(3, 2) = cos(pitch)*sin(roll); deltaRotMat(3, 3) = cos(pitch)*cos(roll);