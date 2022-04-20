% SOR去噪
% 曲面拟合,拆分图形，
% alphaShape绘制曲面

%% 导入文件，取出坐标并转换，初步筛出极大极小值
tic
DataSource = '2203291134拖把.txt';
ReadValume = 100000000;
Dist = 3;
Phi =1;%没起作用
Theta = 2;
[disArray,ThetaArray,PhiArray] = TxtToDataArray(DataSource,ReadValume,Dist,Phi,Theta);
%datak = Kalman3([disArray,ThetaArray,PhiArray],length(disArray));
[x,y,z]=sph2rec(disArray,ThetaArray,PhiArray);
i=70;
while(i>0)
    x(x==max(x))=[0];
    y(y==max(y))=[0];
    z(z==max(z))=[0];
    x(x==min(x))=[0];
    y(y==min(y))=[0];
    z(z==min(z))=[0];
    i=i-1;
end

scatter3(x,y,z,3,z,'filled');
title('SOR去噪前')
daspect([1 1 1]);%设置当前坐标区的数据纵横比
xlabel("x(mm)");
ylabel("y(mm)");
zlabel("z(mm)");
axis([200,1300,-100,1200,-500,1000])
h=colorbar;
set(get(h,'label'),'string','高度')
data = ([x y z]);

%% griddata来插值拟合曲面（失败）
%目标曲面的大小，需要先生成一个栅格
%一般与点云大小相当
% xn = linspace(0,1000*pi,1000);
% yn = linspace(0,1000*pi,1000);
% [Xn,Yn] = meshgrid(xn,yn);
% %利用griddata来插值，从xyz生成栅格数据
% %最后一个为插值方法，包linear cubic natural nearest和v4等方法
% %v4方法耗时长但较为准确
% Array1 = reshapeArray(x);
% Array2 = reshapeArray(y);
% Array3 = reshapeArray(z);
% %Zn = griddata(x,y,z,Xn,Yn,'nearest'); 
% Zn = griddata(Array1,Array2,Array3,Xn,Yn,'natural'); 
% surf(Xn,Yn,Zn);shading interp
% figure
% mesh(Zn,Xn,Yn);
% hold on
% plot3(x,y,z,'r+','MarkerSize',3)


%% SOR去噪 （适合于空间内点分布不均匀的云图）
[idx, a] = SOR(data,0.001,1);
figure
scatter3(a(:,1),a(:,2),a(:,3),3,a(:,3),'filled');
title('SOR去噪后')
daspect([1 1 1]);%设置当前坐标区的数据纵横比
xlabel("x(mm)");
ylabel("y(mm)");
zlabel("z(mm)");
axis([200,1300,-100,1200,-500,1000])
h=colorbar;
set(get(h,'label'),'string','高度')

%% DBSCAN去噪（速度慢，效果一般，适合于空间内点分布均匀的云图）
% dataclass  = DBSCANfunc(data);

%% 绘制去噪后图形
% daspect([1 1 1]);%设置当前坐标区的数据纵横比
% xlabel("x(mm)");
% ylabel("y(mm)");
% zlabel("z(mm)");
% axis([200,1300,-100,1200,-500,1000])
% h=colorbar;
% set(get(h,'label'),'string','高度')


%% 曲面拟合,拆分图形
ptCloud = pointCloud(a);
% 设置点到平面的最小距离
maxDistance = 500;
% 设置平面参考法向量
referenceVector = [0,0,1];
% % 将最大角度距离设置为8.8度
% maxAngularDistance = 1;
% 执行平面拟合,并提取内点、外点索引
%[model,inlier_Idx,outlier_Idx] = pcfitplane(ptCloud,maxDistance,referenceVector);
[model,inlier_Idx,outlier_Idx,meanError] = pcfitplane(ptCloud,maxDistance,referenceVector);
model
meanError
% 提取拟合平面点云
cloud_plane = select(ptCloud,inlier_Idx);
% 提取外点点云
cloud_outlier = select(ptCloud,outlier_Idx);
% figure;
% pcshow(ptCloud);
% title('包含平面的点云')
% hold on;
figure;
pcshow(cloud_plane);
xlabel("x(mm)");
ylabel("y(mm)");
zlabel("z(mm)");
title('平面拟合点云')

figure;
pcshow(cloud_outlier);
xlabel("x(mm)");
ylabel("y(mm)");
zlabel("z(mm)");
title('外点点云')

figure;
pcshowpair(cloud_plane,cloud_outlier)
xlabel("x(mm)");
ylabel("y(mm)");
zlabel("z(mm)");
title('平面内点、外点比较')

%% alphaShape绘图
 shp = alphaShape(cloud_plane.Location(:,1),cloud_plane.Location(:,2),cloud_plane.Location(:,3),17);
figure
plot(shp,'FaceColor','blue');
 hold on;
 shp = alphaShape(cloud_outlier.Location(:,1),cloud_outlier.Location(:,2),cloud_outlier.Location(:,3),70);
plot(shp,'FaceColor','blue');
axis([200,1300,-100,1200,-500,1000]);
xlabel("x(mm)");
ylabel("y(mm)");
zlabel("z(mm)");

%% 
toc
disp(['运行时间: ',num2str(toc)]);

