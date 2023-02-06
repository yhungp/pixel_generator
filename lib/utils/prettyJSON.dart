import 'dart:convert';

prettyJson(Map map){
  JsonEncoder encoder = const JsonEncoder.withIndent('  ');
  String prettyprint = encoder.convert(map);
  
  return prettyprint;
}