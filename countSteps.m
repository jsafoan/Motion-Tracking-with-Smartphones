function [locs, pks] = countSteps(magNoGZ)
edgPts = []; locs = []; pks = []; currState = "stop";
for i = 1 : size(magNoGZ) - 5
    if (currState == "move" & magNoGZ(i:i + 5) > -0.5 & magNoGZ(i:i + 5) < 0.5 & mean(magNoGZ(i:i + 5)) < 0.2) 
        edgPts = [edgPts, i];
        currState = "stop";
    end
    if (currState == "stop" & (magNoGZ(i:i + 5) < -1 | magNoGZ(i:i + 5) > 1))
        edgPts = [edgPts, i];
        currState = "move";
    end
end

if (~isempty(edgPts))
    [~, index] = min(abs(magNoGZ(1:edgPts(1))));
    locs = [locs, index]; pks = [pks, magNoGZ(index)];
    for i = 1 : (size(edgPts, 2) - 2)/2
        [~, index] = min(abs(magNoGZ(edgPts(i * 2):edgPts(i * 2 + 1))));
        locs = [locs, edgPts(i * 2) + index];
        pks = [pks, magNoGZ(edgPts(i * 2) + index)];
    end
    [~, index] = min(abs(magNoGZ(edgPts(end):end)));
    locs = [locs, edgPts(end) + index]; pks = [pks, magNoGZ(edgPts(end) + index)];
end