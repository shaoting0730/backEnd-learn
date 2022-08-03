import 'package:http_server/http_server.dart';
import 'dart:io';

main() async {
  VirtualDirectory staticFiles=new VirtualDirectory('.');

  var requestServer = await HttpServer.bind(InternetAddress.loopbackIPv6, 8080);

  print('监听 localhost地址，端口号为${requestServer.port}');


  //监听请求
  await for(HttpRequest request in requestServer){
    writeHeaders(request);
    if(request.uri.toString()=='/'||request.uri.toString()=='/index.html'){
      staticFiles.serveFile(new File('webApp/index.html'), request);
    }else{
      handleMessage(request);
    }
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
      print('value:$value');
    }
  });
}

void handlePOST(HttpRequest request){

}

void writeHeaders(HttpRequest request){
  List<String> headers=[];
  request.headers.forEach((key, values) {
    String header='$key：';
    for (String value in values) {
      header +='$value , ';
    }
    headers.add(header.substring(0,header.length-2));
  });
  writeLog('${headers.join('\n')}');
}

void writeLog(String log) async{
  var date=DateTime.now();
  var year=date.year;
  var month=date.month;
  var day=date.day;
  var hour=date.hour;
  var minute=date.minute;

  //如果recursive为true，会创建命名目录及父级目录
  Directory directory=await new Directory('log/$year-$month-$day').create(recursive: true);

  File file = new File('${directory.path}/$hour:$minute.log');
  file.exists().then((isExists){
    String logAddTime='time：${date.toIso8601String()}\n$log';
    file.writeAsString(isExists?'\n\n$logAddTime':logAddTime, mode: FileMode.append);
  });
}