
import 'package:islamic_app/features/home/ahadeth/domain/entities/hadeth_author_entity.dart';

class HadethAuthorModel  extends HadethAuthorEntity {
  const HadethAuthorModel({required super.key,required super.arabicName,required super.totalAhadeth});


  factory HadethAuthorModel.fromjson(Map<String, dynamic> json){
    return HadethAuthorModel(key: json["key"], arabicName: json["arabic_name"], totalAhadeth: json["total_hadiths"]);
}


Map<String ,dynamic> tojson(){
    return {"key":key,"arabic_name":arabicName,"total_hadiths":totalAhadeth};
}
}