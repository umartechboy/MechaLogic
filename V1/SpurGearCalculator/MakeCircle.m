function [x, y] = MakeCircle(r, res)
%% MakeCircle Generates a circle centered at origin with given radius and resolution
thRes = res / r;
x = [];
y = [];
for ii = 0:thRes:2*pi
    x(end + 1) = r * cos(ii);
    y(end + 1) = r * sin(ii);
end
end