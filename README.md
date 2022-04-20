# LIDAR-Modeling

We write the distance data obtained from the lidar scanning scene into a text document from the serial port and import it into MATLAB for processing. SOR denoising algorithm is used to remove most of the isolated and miscellaneous points, and a 3d model is preliminarily obtained through simple feature extraction and surface fitting.

我们将激光雷达扫描场景获得的距离数据从串口写入文本文档，导入MATLAB进行处理，其中，使用SOR去噪算法去除大部分孤立杂点，通过简单的特征提取、曲面拟合，并初步获得三维模型。 



During this period, we tried DBSCAN denoising algorithm, which is more suitable for point cloud images with relatively uniform distribution in space. Besides, the algorithm has a huge amount of computation and is slow in calculation, so it was not adopted. We tried to use griddata function to interpolate and fit the surface, but the effect was not good. This function is more suitable for point cloud fitting surface with obvious function rules.

Previously, we tried to use Kalman filtering algorithm to smooth the data, but due to the requirements of radar scanning rate and limited by the huge amount of data, we have not found a suitable algorithm.

期间，我们尝试了DBSCAN去噪算法，该算法更适用于在空间内分布较均匀的点云图，且该算法运算量巨大，计算较慢，故未采用。我们尝试了使用 griddata函数来插值拟合曲面，但是效果不佳，该函数更适合有明显函数规律的点云拟合曲面。
最初，我们尝试使用Kalman滤波算法对数据进行平滑，但由于对雷达扫描速率的要求和受限于庞大的数据量，尚未找到合适的算法。



### **ModelingShows.m**   
The main program of build visual model for the initial filter maximum and minimum, coordinate system conversion

### **TxtToDataArrray.m**  
Categorize data from a text file in a particular format and transform it into a matrix

### **sph2rec.m**   
The spherical coordinate system converts the rectangular coordinate system, left-handed, phi starts with + Z, theta starts with +x, and rotates counterclockwise

### **SOR.m**   
SOR denoising algorithm

