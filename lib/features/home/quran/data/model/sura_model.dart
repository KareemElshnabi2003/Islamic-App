// "surah": {
// "number": 1,
// "name_arabic": "الفاتحة",
// },

import 'package:islamic_app/features/home/quran/domain/entities/sura_entity.dart';

class  SuraModel  extends SuraEntity{
  const SuraModel({required super.id,required super.name});


  factory SuraModel.fromJson(Map<String ,dynamic> json){
    return SuraModel(id: json['number'], name: json['name_arabic']);
  }

  Map<String,dynamic> toJson(){
    return {"number":id,"name":name};

  }

}