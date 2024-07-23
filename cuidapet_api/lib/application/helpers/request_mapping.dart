import 'dart:convert';

abstract class RequestMapping {

 final Map<String, dynamic> data;

 RequestMapping.empty() : data = {};

 RequestMapping(String dataRequest) : this.data = jsonDecode(dataRequest){
  map();
 }
 void map();
}