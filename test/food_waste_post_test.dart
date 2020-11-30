import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasteagram/models/post.dart';

void main(){

  test('Post created from Map should have appropriate property values', (){

    final date = Timestamp.now();
    const url = 'NULL';
    const quantity = 3;
    const latitude = 3.0;
    const longitude = 1.0;

    final wastePost = Post.fromMap({
      'date': date,
      'url': url,
      'quantity': quantity,
      'latitude': latitude,
      'longitude': longitude
    });

    expect(wastePost.dateTime, date);
    expect(wastePost.url, url);
    expect(wastePost.wasteQuantity, quantity);
    expect(wastePost.latitude, latitude);
    expect(wastePost.longitude, longitude);

  });

  test('Post should successfully convert itself to a map', (){
    final date = Timestamp.now();
    const url = 'https://wwww.newurl.edu.gov';
    const quantity = 1;
    const latitude = 85.9983432;
    const longitude = -73.482945;
    final post = Post(dateTime: date, url: url, wasteQuantity: quantity, latitude: latitude, longitude: longitude);

    Map<String, dynamic> postMap = post.toMap();

    expect(postMap['date'], date);
    expect(postMap['imageURL'], url);
    expect(postMap['quantity'], quantity);
    expect(postMap['latitude'], latitude);
    expect(postMap['longitude'], longitude);

  });

}