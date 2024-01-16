#include <QCoreApplication>
#include <QDebug>

class RectangularRegion
{
public:
    static void getBoundingBox(double centerLatitude, double centerLongitude, double halfWidth, double halfHeight)
    {
        // 计算矩形区域的四个顶点经纬度
        double upperLeftLatitude = centerLatitude + halfHeight;
        double upperLeftLongitude = centerLongitude - halfWidth;

        double upperRightLatitude = centerLatitude + halfHeight;
        double upperRightLongitude = centerLongitude + halfWidth;

        double lowerLeftLatitude = centerLatitude - halfHeight;
        double lowerLeftLongitude = centerLongitude - halfWidth;

        double lowerRightLatitude = centerLatitude - halfHeight;
        double lowerRightLongitude = centerLongitude + halfWidth;

        // 打印四个顶点的经纬度
        qDebug() << "Upper Left: (" << upperLeftLatitude << ", " << upperLeftLongitude << ")";
        qDebug() << "Upper Right: (" << upperRightLatitude << ", " << upperRightLongitude << ")";
        qDebug() << "Lower Left: (" << lowerLeftLatitude << ", " << lowerLeftLongitude << ")";
        qDebug() << "Lower Right: (" << lowerRightLatitude << ", " << lowerRightLongitude << ")";
    }
};

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    // 以中国的中心区域为例，设置中心经纬度和矩形的半宽半高
    double centerLatitude = 35.8617; // 中国中心区域的纬度
    double centerLongitude = 104.1954; // 中国中心区域的经度
    double halfWidth = 5.0; // 矩形宽度的一半（示例值）
    double halfHeight = 5.0; // 矩形高度的一半（示例值）

    RectangularRegion::getBoundingBox(centerLatitude, centerLongitude, halfWidth, halfHeight);

    return a.exec();
}
