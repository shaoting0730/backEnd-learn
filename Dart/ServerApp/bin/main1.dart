import 'dart:io';
import 'package:http_server/http_server.dart';
import 'package:path/path.dart';

main() async {
  //获取文件根目录
  var webPath=dirname(dirname(Platform.script.toFilePath()))+'/webApp';
  VirtualDirectory staticFiles=new VirtualDirectory(webPath);
  //允许目录监听
  staticFiles.allowDirectoryListing=true;
  //处理访问根目录
  staticFiles.directoryHandler=(dir,request){
    var indexUri=new Uri.file(dir.path,).resolve('index.html');
    staticFiles.serveFile(new File(indexUri.toFilePath()), request);
  };
  //处理访问不存在的页面
  staticFiles.errorPageHandler=(request){
    if(request.uri.pathSegments.last.contains('.html')){
      staticFiles.serveFile(new File(webPath+'/404.html'), request);
    }else{
      handleMessage(request);
    }
  };
  var requestServer = await HttpServer.bind(InternetAddress.loopbackIPv6, 8080);
  print('监听 localhost地址，端口号为${requestServer.port}');
  //监听请求
  await requestServer.forEach(staticFiles.serveRequest);
}

void handleMessage(HttpRequest request){
  try{
    if(request.method == 'GET'){
      handleGET(request);
    }else if(request.method == 'POST'){
      handlePOST(request);
    }else{
      request.response..statusCode = HttpStatus.methodNotAllowed
        ..write('暂时不支持')
        ..close();
    }
  }catch(e){
    print('出现了一个异常，异常为：$e');
  }
}

void handleGET(HttpRequest request){
  // 获取参数
  var id = request.uri.queryParameters['id'];
  request.response
    ..statusCode=HttpStatus.ok
    ..write('当前查询的id=$id')
    ..close();
  request.headers.forEach((key, values) {
    print('key:&key');
    for(String value in values){
      print('value:$value');
    }
  });
}

void handlePOST(HttpRequest request){

}
