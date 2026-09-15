
import 'package:islamic_app/features/home/radio/domain/entities/radio_entity.dart';

class RadioModel extends RadioEntity {

  const RadioModel({required super.id, required super.name, required super.url, required super.recentDate});


 factory RadioModel.fromJson(Map<String, dynamic> json) {
 return RadioModel(id: json['id'], name: json['name'], url: json['url'], recentDate: json['recent_date']);
  }

  Map<String, dynamic> toJson() {
  return {'id': id,'name':name,'url' :url,'recent_date': recentDate};


}
}