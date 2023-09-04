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
