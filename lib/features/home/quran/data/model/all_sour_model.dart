// "suwar": [
// {
// "id": 1,
// "name": "الفاتحة",
// "start_page": 1,
// "end_page": 1,
// "makkia": 1,
// "type": 0
// }

import 'package:islamic_app/features/home/quran/domain/entities/all_sour_entity.dart';

class  AllSourModel  extends AllSourEntity{
  const AllSourModel({required super.id,required super.name, required super.makia});


  factory AllSourModel.fromJson(Map<String ,dynamic> json){
    return AllSourModel(id: json['id'], name: json['name'], makia:json ['makkia']);
  }

  Map<String,dynamic> toJson(){
    return {"id":id,"name":name,"makkia":makia};

}

}