function [rotMat] = getRotationMatrixFromGravityMagnet(gravity, magnet)

    % The global coordinate framework is:
    % X: East
    % Y: Norht
    % Z: Up

    % The returned rotMat has the following physical meaning:
    % The 1st column of rotMat is the device's x vector, in global framework
    % Similarly, 2nd column for device's y, 3rd column for device's z

    assert(length(gravity)==3);
    assert(length(magnet)==3);

    Ax = gravity(1);
    Ay = gravity(2);
    Az = gravity(3);

    Ex = magnet(1);
    Ey = magnet(2);
    Ez = magnet(3);

    Hx = Ey * Az - Ez * Ay;
    Hy = Ez * Ax - Ex * Az;
    Hz = Ex * Ay - Ey * Ax;

    normH = sqrt(Hx * Hx + Hy * Hy + Hz * Hz);

    if normH < 0.1
        error('Cannot compute rotation matrix.');
        rotMat = [];
    else
        invH = 1.0 / normH;
        Hx = Hx * invH;
        Hy = Hy * invH;
        Hz = Hz * invH;

        invA = 1.0 / sqrt(Ax * Ax + Ay * Ay + Az * Az);
        Ax = Ax * invA;
        Ay = Ay * invA;
        Az = Az * invA;

        Mx = Ay * Hz - Az * Hy;
        My = Az * Hx - Ax * Hz;
        Mz = Ax * Hy - Ay * Hx;

        rotMat = [Hx, Hy, Hz; Mx, My, Mz; Ax, Ay, Az];
    end

end