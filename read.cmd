#include <QtXml/QXmlStreamReader>
#include <QDebug>

int main() {
    // 创建一个QXmlStreamReader对象并打开XML文件
    QFile file("your_xml_file.xml");
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "无法打开XML文件";
        return 1;
    }

    QXmlStreamReader xml(&file);

    // 开始解析XML
    while (!xml.atEnd() && !xml.hasError()) {
        // 读取下一个XML标记
        xml.readNext();

        // 检查标记类型
        if (xml.isStartElement()) {
            // 处理开始标记
            qDebug() << "开始标记: " << xml.name().toString();

            // 如果需要，可以访问标记的属性
            QXmlStreamAttributes attributes = xml.attributes();
            foreach (const QXmlStreamAttribute &attribute, attributes) {
                qDebug() << "属性名: " << attribute.name().toString()
                         << " 属性值: " << attribute.value().toString();
            }
        } else if (xml.isEndElement()) {
            // 处理结束标记
            qDebug() << "结束标记: " << xml.name().toString();
        } else if (xml.isCharacters() && !xml.isWhitespace()) {
            // 处理元素文本
            qDebug() << "文本: " << xml.text().toString();
        }
    }

    // 如果解析遇到错误，则打印错误信息
    if (xml.hasError()) {
        qDebug() << "XML解析错误: " << xml.errorString();
        return 1;
    }

    // 关闭文件
    file.close();

    return 0;
}






//node_test.js
const log4js = require("log4js");
const http = require('http');

log4js.configure({
  appenders: { cheese: { type: "file", filename: "cheese.log" } },
  categories: { default: { appenders: ["cheese"], level: "info" } },
});






// 2、创建http
var server = http.createServer(); // 创建一个web容器 静态服务器
// 3、监听请求事件
server.on('request', function (request, response) {
    // 监听到请求之后所做的操作
    // request 对象包含：用户请求报文的所有内容
    // 我们可以通过request对象，获取用户提交过来的数据

    // response 响应对象,用来响应一些数据
    // 当服务器想要向客户端响应数据的时候，就必须使用response对象

    // 响应html代码，
    // 有些浏览器会显示乱码，可以通过设置http响应报文的响应头来解决
    response.setHeader('Content-Type', 'text/html;charset=utf-8');
    response.write('<h1>hello world！</h1>');
    response.end();
})
// 4、监听端口，开启服务
server.listen(8080, function(){
	const logger = log4js.getLogger("cheese");
	/*logger.trace("Entering cheese testing");
	logger.debug("Got cheese.");
	logger.info("Cheese is Comté.");
	logger.warn("Cheese is quite smelly.");
	logger.error("Cheese is too ripe!");
	logger.fatal("Cheese was breeding ground for listeria.");
*/

	logger.info("服务器已经启动，可访问以下地址：");
	logger.info("http://localhost:8080");
})


//service.js
let Service = require('node-windows').Service;
 
let svc = new Service({
  name: 'node_test',    //服务名称
  description: '测试项目服务器', //描述
  script: 'D:/OpenSource/node_test/node_test.js' //nodejs项目要启动的文件路径
});
 
svc.on('install', () => {
  svc.start();
  if(svc.exists){
    console.log('服务安装成功')
  }
});
 
svc.install();


//uninstall.js
let Service = require('node-windows').Service;
 
let svc = new Service({
  name: 'node_test',    //服务名称
  description: '测试项目服务器', //描述
  script: 'D:/OpenSource/node_test/node_test.js' //nodejs项目要启动的文件路径
});
 
svc.on('uninstall', () => {
    if (!svc.exists) {
        console.log('服务卸载完成');
    }
});
 
svc.uninstall();


参考https://github.com/openssl/openssl/blob/master/NOTES-WINDOWS.md

https://www.openssl.org/source/
下载openssl-1.1.1v.tar.gz (SHA256) (PGP sign) (SHA1)
释放到目录 C:\openssl-1.1.1v\openssl-1.1.1v

https://www.activestate.com/products/perl/
https://www.nasm.us/


mkdir c:\openssl_lib\static_lib\win32
mkdir c:\openssl_lib\shared_dll\win32
mkdir c:\openssl_lib\shared_dll\win64
mkdir c:\openssl_lib\static_lib\win64

VS2015 x86 Native Tools Command Prompt
VS2015 x64 Native Tools Command Prompt

进入目录C:\openssl-1.1.1v\openssl-1.1.1v

32位
perl Configure VC-WIN32 no-asm no-shared --prefix=C:\openssl_lib\static_lib\win32
perl Configure VC-WIN32 no-asm --prefix=C:\openssl_lib\shared_dll\win32

64位
perl Configure VC-WIN64A no-asm no-shared --prefix=C:\openssl_lib\static_lib\win64
perl Configure VC-WIN64A no-asm --prefix=C:\openssl_lib\shared_dll\win64


Debug版
debug-VC-WIN32
debug-VC-WIN64A


nmake clean

perl Configure VC-WIN64A no-asm no-shared --prefix=C:\openssl_lib\static_lib\win64
nmake
nmake install



perl Configure VC-WIN64A no-asm --prefix=C:\openssl_lib\shared_dll\win64
nmake
nmake install

