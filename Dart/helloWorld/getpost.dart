import 'dart:io';


/// 启动后，浏览器输入 http://localhost:8080/?id=22
main() async{
  var requestServer=await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);

  print('监听 localhost地址，端口号为${requestServer.port}');

  //监听请求
  await for(HttpRequest request in requestServer){
    handleMessage(request);
  }
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
       print('value:$values');
     }
  });
}

void handlePOST(HttpRequest request){

}