import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  Timestamp dateTime;
  String url;
  int wasteQuantity;
  double latitude;
  double longitude;

  Post({this.dateTime, this.url, this.wasteQuantity,
    this.latitude, this.longitude});

  Map<String ,dynamic> toMap(){
    return {
      'date': dateTime,
      'imageURL': url,
      'latitude': latitude,
      'longitude': longitude,
      'quantity': wasteQuantity
    };
  }

  static Post fromMap(Map<String, dynamic> convert){
    return Post(dateTime: convert['date'], url: convert['url'], wasteQuantity: convert['quantity'], latitude: convert['latitude'], longitude: convert['longitude']);
  }

}