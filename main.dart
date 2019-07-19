import 'dart:convert';

import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'dart:io';

main() async {
  var jsonFile = File('data.json');
  var sink = jsonFile.openWrite();
  var client = Client();
  Response response = await client.get('https://firebase.google.com/products/#develop-products'); //выбираем сайт

  var document = parse(response.body); //Используем парсер
  List<Element> links =
      document.body.querySelectorAll('a[data-category="product-grid"]');

  List<Map<String, dynamic>> linkMap = [];

 for (var link in links) {
   link.text = link.text.replaceAll(new RegExp(r'\n\s+'),  ''); //Регулярное выражение чтобы убрать пробелы и переходы на новую строку
    linkMap.add({
      'title': link.text,
    });
    
  }
  print(json.encode(linkMap)); //делаем енкод в JSOn

  sink.write(json.encode(linkMap));
  await sink.flush();
  await sink.close();
}
