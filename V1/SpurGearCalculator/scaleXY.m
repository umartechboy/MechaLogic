function [psx, psy] = scaleXY(px, py, sx, sy)

H = [sx,   0,   0; ...
    0,    sy,   0; ...
    0,                0,    1; ...
    ];
T = H * [px; py; 1];
psx = T(1);
psy = T(2);

end