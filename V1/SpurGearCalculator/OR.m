pitch = 12;
[x1, y1, PCD1] = MakeGear1(28, 20, pitch, .1, 2, 2);
[x2, y2, PCD2] = MakeGear1(22, 20, pitch, .1, 2, 2);
[x3, y3, PCD3] = MakeGear1(16, 20, pitch, .1, 2, 2);
figure; 
hold on;
%[x2, y2] = rotateZ(x2, y2, 0.13);
plot(x1 - PCD1 / 2 - PCD2, y1); axis equal;
plot(x2, y2);
plot(x3 + PCD3 / 2 + PCD2, y3);

[cx1, cy1] = MakeCircle(3, 0.1);
[cx2, cy2] = MakeCircle(3, 0.1);
[cx3, cy3] = MakeCircle(3, 0.1);

plot(cx1 - PCD1 / 2 - PCD2, cy1);
plot(cx2, cy2);
plot(cx3 + PCD3 / 2 + PCD2, cy3);

