function [disArray,ThetaArray,PhiArray] =TxtToDataArray(DataSource,ReadValume,Dist,Phi,Theta)
%{
DataSource:数据来源txt文件
ReadValume：读取数据容量
Dist、Phi、Theta：数据顺序
%}

fid=fopen(DataSource,'rt');
row=0;
while ~feof(fid)
    row=row+sum(fread(fid,ReadValume,'*char')==newline);    
end
group = row/3;
for i = 1 : group-1
    Dist =  [Dist;3+i*3];
    Phi = [Phi;1+i*3];
    Theta =  [Theta;2+i*3];
end
Dist = [Dist Dist];
Phi = [Phi Phi];
Theta = [Theta Theta];
opts = detectImportOptions(DataSource);

opts.DataLines = Phi;
PhiData =  readmatrix(DataSource,opts);
opts.DataLines = Theta;
TheaData =  readmatrix(DataSource,opts);

opts = setvartype(opts, 'Var1', 'char');%数据类型默认为double，更改为char
opts.DataLines = Dist;
disData =  readmatrix(DataSource,opts);

%平滑r,无reshape
% dec = hex2dec(disData);
% disArray = Kalman2(dec,16384);
% PhiArray = deg2rad(PhiData*0.9);
% ThetaArray =deg2rad(TheaData*0.81);

%平滑r,有reshape
% dec = hex2dec(disData);
% disArray = Kalman2(dec,16300);
% PhiArray = reshapeArray(deg2rad(PhiData*0.9));
% ThetaArray =reshapeArray(deg2rad(TheaData*0.81));
% 
%原始
disArray = hex2dec(disData);
PhiArray = deg2rad(PhiData*0.9);
ThetaArray =deg2rad(TheaData*0.81);
% 
%全部reshape
% disArray = reshapeArray(hex2dec(disData));
% PhiArray = reshapeArray(deg2rad(PhiData*0.9));
% ThetaArray =reshapeArray(deg2rad(TheaData*0.81));

