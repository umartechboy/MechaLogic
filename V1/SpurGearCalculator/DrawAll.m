%% Source of inspiration for this code is a video by Soumitra Vadnerker on 
% Youtube at https://www.youtube.com/watch?v=3bkw7C5z60E where he teaches
% how to make an involute spur gear in Autodesk AutoCad. I've converted
% the same steps to Matlab Code which outputs all the points in sequence
% to form a graphic path.
% Some work is still needed in order to use this code for prototypes but it
% it can easily be done in applications like Autodesk AutoCAD, Adobe Illustrator,
% Freeware InkSpace etc.

% The main function is MakeGear1 which asks for:
%   1: N = Number of teeth required
%   2: PA = Pressure Angle (in degrees)
%   3: Pitch = Teeth Pitch (in millimeters/inches or units of similar scale)
%   4: lRes = linear resolution of the output image (in same units as the Pitch)
%   5: ACDFac = (default = 2), Addendum Circle Dia factor (A. C. Dia = ToothThickness * 2 * (N + ACDFac) / pi)
%   6: DCDFac = (default = 2), Dedendum Circle Dia factor (D. C. Dia = ToothThickness * 2 * (N - DCDFac) / pi)
% The function returns:
%   1: tcxAll = xCoordinates of the gear, centered on [0,0]
%   2: tcyAll = yCoordinates of the gear, centered on [0,0]
%   3: PCD = Pitch Circle DiaMeter
%   4: ACDFinal = Addendum Circle Diameter
%% The following example generates two gears and animates them.

%%
close all force
set(gca, 'color', [0 0.1 0.1])
set(gca, 'XColor', [0 0.5 0.5]);
set(gca, 'YColor', [0 0.5 0.5]);
axis equal;
grid on; hold on;

% Make a gear with 8 teeth,
[g1x, g1y, PCD1, ACD1] = MakeGear1(8, 20, 2.67, 0.01, 2, 2.5);
[g2x, g2y, PCD2, ACD2] = MakeGear1(96, 20, 2.67, 0.01, 2, 4);

% rotate it for meshing
[g1x, g1y] = rotateZ(g1x, g1y, 2 * pi / 8 / 2); 

th1 = 0.05 / PCD1 * 2;
th2 = 0.05 / PCD2 * 2;
for ii = 1:1000
    [g1x, g1y] = rotateZ(g1x, g1y, th1); 
    [g2x, g2y] = rotateZ(g2x, g2y, -th2); 
    clf;
    set(gca, 'color', [0 0.1 0.1])
    set(gca, 'XColor', [0 0.5 0.5]);
    set(gca, 'YColor', [0 0.5 0.5]);
    axis equal;
    grid on; hold on;
    plot(g1x, g1y, 'w');
    plot(g2x + PCD1/2 + PCD2/2, g2y, 'w');
    xlim([-5, 10])
    ylim([-7, 7])
    drawnow;
end


