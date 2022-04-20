% 需要输入三个参数，a代表点云 n*3
% sig是标准差的倍数参数
% k是临近点个数
% 无默认参数，matlab的默认参数sig=1，k=4
% 返回idx为噪声索引
% point为去除噪声的点
function [idx, point] = SOR(a,sig,k)%基于空间分布的去噪算法
    idx = zeros(length(a(:,1)),1);
    %搜索k邻近点。计算距离
    [~,d] = knnsearch(a(:,1:3),a(:,1:3),'k',k+1);%本身的点加距离相近的k个点
    %求距离的平均值
    d = sum(d,2);%按行求和
    mean_d = mean(d);
    %噪声阈值
    noise = mean_d + sig * std(d);
    %小于噪声阈值的就是去噪后的索引值
    idx1 = find(d < noise);
    %噪声值是0，保留的点是1
    idx(idx1,:) = 1;
    point = a(idx1,:);
end
%（适合于空间内点分布不均匀的云图）