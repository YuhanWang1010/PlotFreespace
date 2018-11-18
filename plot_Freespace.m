clear;
clc;
cla;
%Load data
[fileName, pathName] = uigetfile({'*.mat'},'File Selector');
fullPathName = strcat(pathName, fileName);
data = load(fullPathName);


minCyc = 1;
maxCyc = max(data.FreeSpaceInt_cycleArr)-min(data.FreeSpaceInt_cycleArr)+1;
for i = minCyc:maxCyc
    a = plotFreespace_cycle(i, data);
    view(270,90);
    hold on;
    b = plotStationaryDetMem_cycle(i, data);
    c = plotMovingDetMem_cycle(i, data);
    title(strcat("Cycle",string(i)));
    d = slaveOrMaster(data); % 0 = master, 2 = Slave
    e = plotHostCar(d);
    legend('Freespace', 'StationaryDet', 'MovingDet', 'HostVehilcle');
    xlim([-40,160]);
    if (d == 0)
        ylim([-20, 160]);
    else
        ylim([-160,20]);
    end
    hold off;
    F(i) = getframe(gcf);
    pause(0.1);
end

video = VideoWriter(strcat(fileName(1:end-4),'.avi'),'Uncompressed AVI');
video.FrameRate = 7;
open(video);
writeVideo(video,F);
close(video);

function a = plotFreespace_cycle(i, data)
corresponding_location = find(data.FreeSpaceInt_cycleArr == i);
posX = data.FreeSpaceInt_PosX(corresponding_location);
posY = data.FreeSpaceInt_PosY(corresponding_location);
a = plot(posX, posY, 'b-x');
end

function b = plotStationaryDetMem_cycle(i, data)
position = find(data.FreeSpaceInt_Detmem_cycleArr==0);
last = position(sum(data.FreeSpaceInt_Detmem_FirstCycleD(1:i)));
first = last - data.FreeSpaceInt_Detmem_FirstCycleD(i) + 1;
posStationary = find(data.FreeSpaceInt_Detmem_isStationar(first:last) == 1);
posX_stationary = data.FreeSpaceInt_Detmem_PosX(posStationary);
posY_stationary = data.FreeSpaceInt_Detmem_PosY(posStationary);
b = scatter(posX_stationary, posY_stationary, 'd');
end

function c = plotMovingDetMem_cycle(i, data)
position = find(data.FreeSpaceInt_Detmem_cycleArr==0);
last = position(sum(data.FreeSpaceInt_Detmem_FirstCycleD(1:i)));
first = last - data.FreeSpaceInt_Detmem_FirstCycleD(i) + 1;
posMoving     = find(data.FreeSpaceInt_Detmem_isStationar(first:last) == 0);
posX_moving = data.FreeSpaceInt_Detmem_PosX(posMoving);
posY_moving = data.FreeSpaceInt_Detmem_PosY(posMoving);
c = scatter(posX_moving, posY_moving, 'filled');
end

function d = slaveOrMaster(data)
maxY = max(data.FreeSpaceInt_PosY);
minY = min(data.FreeSpaceInt_PosY);
if (abs(maxY)>abs(minY))
    d = 0;
else
    d = 2;
end
end

function e = plotHostCar(d)
y = [0, -0.9, -1.8, -1.8, -0.9,  0, -1.8, -1.8, 0, 0];
x = [0,    0,    0,   -1,    0, -1,   -1, -4,  -4, 0];
x = x.*5;
y = y.*5;
if(d == 2)
    e = plot(x,-y,'LineWidth',2);
else
    e = plot(x,y,'LineWidth',2);
end
end