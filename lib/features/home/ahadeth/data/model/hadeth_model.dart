

import 'package:islamic_app/features/home/ahadeth/domain/entities/hadeth_entity.dart';

class HadethModel  extends HadethEntity {
const HadethModel({required super.id,required super.collection,required super.hadethNum,required super.body});


factory HadethModel.fromjson(Map<String, dynamic> json){
return HadethModel(id: json["id"], collection: json["collection"], hadethNum: json["hadithnumber"],body: json["arabic"]);
}


Map<String ,dynamic> tojson(){
return {"id":id,"hadithnumber":hadethNum,"collection":collection,"arabic":body};
}
}