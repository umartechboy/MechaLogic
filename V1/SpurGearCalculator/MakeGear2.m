function [ tcxAll, tcyAll, Pitch, ACDFinal] = MakeGear2(N, PA, PCD, lRes, ACDFinal, DCDFac)
%% MakeFear1 generates the points of the required gear's periphery.
% The main function is MakeGear1 which asks for:
%   1: N = Number of teeth required
%   2: PA = Pressure Angle (in degrees)
%   3: PCD = Pitch Circle Diameter (any units)
%   4: lRes = linear resolution of the output image (in same units as the Pitch)
%   5: ACDFac = (default = 2), Addendum Circle Dia factor (A. C. Dia = ToothThickness * 2 * (N + ACDFac) / pi)
%   6: DCDFac = (default = 2), Dedendum Circle Dia factor (D. C. Dia = ToothThickness * 2 * (N - DCDFac) / pi)
% The function returns:
%   1: tcxAll = xCoordinates of the gear, centered on [0,0]
%   2: tcyAll = yCoordinates of the gear, centered on [0,0]
%   3: Pitch = Pitch
%   4: ACDFinal = Addendum Circle Diameter
%

%%
   PA = PA * pi / 180;
    TT = PCD  / 2 / N * pi;
    Pitch = TT * 2;
    ACDFinal = TT * 2 * (N + ACDFinal) / pi;
    DCDFac = TT * 2 * (N - DCDFac) / pi;
 
    % 
    BCD = PCD * cos(PA);
    BCR = BCD / 2;
    lastPoint = [];
    % this array will store only a single tooth profile that is located on
    % the top of the gear.
    tcx = [];
    tcy = [];
    % we need to store the point nearest to the pitch circle perphery.
    pitchPoint = [0,0];
    % Distance of this point from the pitch circle perphery.
    pitchPointRDiff = ACDFinal/2;
    for ii = 1:1000000
        % Generate the profile for one side of a single tooth
        ti = (90 - (ii - 1) * 0.001) * pi / 180;
        ti_1 = (90 - (ii - 1 - 1) * 0.001) * pi / 180;
        t0 = (90 - (-1 - 1) * 0.001) * pi / 180;
        p1x = BCR * cos (ti);
        p1y = BCR * sin(ti);

        p1_1x = BCR * cos (ti_1);
        p1_1y = BCR * sin(ti_1);

        pbx = BCR * cos (t0);
        pby = BCR * sin(t0);

        r = dist(pbx, pby, p1_1x, p1_1y);    

        p2x = p1x + r * cos (ti + pi / 2);
        p2y = p1y + r * sin(ti + pi / 2);

        pointR = dist(p2x, p2y, 0,0);
        % We don't need points outside the addendum
        if abs(pointR - PCD/2) < pitchPointRDiff
            pitchPointRDiff = abs(pointR - PCD/2);
            pitchPoint = [p2x, p2y];
        end
        % Check if this point is the nearest to the pitch circle periphery.
        if  pointR > ACDFinal/2
            break;
        end
        % We don't need points inside the dedendum
        if  pointR > DCDFac/2
            if ~isempty(lastPoint)
                if dist(lastPoint(1), lastPoint(2), p2x, p2y) >= lRes

                    tcx(end + 1) = p2x;
                    tcy(end + 1) = p2y;
                    lastPoint = [p2x, p2y];
                end
            else        
                lastPoint = [p2x, p2y];
                tcx(end + 1) = p2x;
                tcy(end + 1) = p2y;
            end
        end
    end
    % the first tooth needs to be on the top of the gear..
    % So the sides will be symmetric on the Y axis.    
    % Profile touches the base circle at the y axis. rotate it clock wise
    rotateLeft = atan2(pitchPoint(1), pitchPoint(2));
    tcxLen = length(tcx);
    for ii = 1:tcxLen 
        [prx, pry] = rotateZ(tcx(ii), tcy(ii), rotateLeft + pi / N/2);
        % the other side of the tooth is now just a mirror of the first on
        % the y axis.
        [pmx, pmy] = scaleXY(prx, pry, -1, 1);

        tcx(ii) = prx;
        tcy(ii) = pry;
        if (ii ~= tcxLen)
            tcx(2 * tcxLen - ii) = pmx;
            tcy(2 * tcxLen - ii) = pmy;
        end
    end

    % this array will store all the teeth in proper sequence and with
    % dedendum circle path.
    tcxAll = [];
    tcyAll = [];
    dthForDC = lRes / DCDFac * 2;
    for ii = N:-1:1 % itereate through all gears
        ang = ii / N * 2 * pi;
        for jj = 1:length(tcx) % transform the points to the new position
            [prx, pry] = rotateZ(tcx(jj), tcy(jj), ang);
            tcxAll(end + 1) = prx;
            tcyAll(end + 1) = pry;        
        end

        % add the section of dedendum circle in between the teeth.
        ang = (ii - 1) / N * 2 * pi;
        [prNx, prNy] = rotateZ(tcx(1), tcy(1), ang);
        thS = atan2(tcyAll(end), tcxAll(end));
        thEnd = atan2(prNy, prNx);
        for jj = thS:-dthForDC:thEnd
            tcxAll(end + 1) = DCDFac/2 * cos(jj);
            tcyAll(end + 1) = DCDFac/2 * sin(jj);
        end
    end

    % close the path
    tcxAll(end + 1) = tcxAll(1);
    tcyAll(end + 1) = tcyAll(1);

    %plot(tcxAll, tcyAll, 'w');



end

