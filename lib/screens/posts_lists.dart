import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';
import 'package:wasteagram/screens/show_post.dart';
import 'dart:core';
import 'package:wasteagram/models/post.dart';

class PostsList extends StatefulWidget {
  @override
  PostsListState createState() => PostsListState();
}

class PostsListState extends State<PostsList> {
  static const routeName = "/";
  static int waste = 0;

  static var url = '';

  File image;

  LocationData locationData;
  var locationService = Location();

  @override
  void initState() {
    super.initState();
    //waste = 0;
    loadWaste();
  }

  void loadWaste() async {
    var test = await Firestore.instance.collection('posts').getDocuments();
    if (test.documents.length > 0) {
      for (int i = 0; i < test.documents.length; ++i) {
        waste += test.documents[i]['quantity'];
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wasteagram - ${waste.toString()}"),
        centerTitle: true,
      ),
      body: getFirePosts(),
      floatingActionButton: addPostFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Stream<QuerySnapshot> getFireStoreData() {
    return Firestore.instance
        .collection('posts')
        .orderBy('date', descending: true)
        .snapshots();
  }

  Widget getFirePosts() {
    return StreamBuilder(
      stream: getFireStoreData(),
      builder: (content, snapshot) {
        if (snapshot.hasData &&
            snapshot.data.documents != null &&
            snapshot.data.documents.length > 0) {
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                var post = snapshot.data.documents[index];
                return postTile(post);
              });
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<dynamic> getImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    image = File(pickedFile.path);
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('${Timestamp.now().seconds.toString()}.jpg');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    url = await storageReference.getDownloadURL();
  }

  Widget postTile(var post) {
    return Semantics(
        label: 'tile of wasted items post',
        onTapHint:
            'When pressed, this will take you to a more detailed view of the post',
        child: Padding(
          padding: EdgeInsets.fromLTRB(2.0, 4.0, 2.0, 2.0),
          child: ListTile(
            leading: postTileLeading(post),
            title: postTileTitle(post),
            trailing: postTileTrailing(post),
            onTap: () {
              Navigator.of(context).pushNamed(ShowPost.routeName,
                  arguments: Post(
                      dateTime: post['date'],
                      url: post['imageURL'],
                      wasteQuantity: post['quantity'],
                      longitude: post['longitude'],
                      latitude: post['latitude']));
            },
          ),
        ));
  }

  Widget postTileLeading(var post) {
    return Semantics(
        label: 'thumbnail of a picture of waste',
        child: Image.network(
          post['imageURL'],
          width: 50,
          height: 50,
        ));
  }

  Widget postTileTitle(var post) {
    return Semantics(
        label: 'date the picture of wasted items was taken',
        child: Text(DateFormat('EEEE, MMM, dd')
            .format(DateTime.fromMillisecondsSinceEpoch(
                post['date'].seconds * 1000))
            .toString()));
  }

  Widget postTileTrailing(var post) {
    return Semantics(
        label: 'number of wasted items',
        child: Text(post['quantity'].toString()));
  }


  Widget addPostFAB(){
    return Semantics(
        label: 'button for adding a post',
        onTapHint:
        'Will bring up the camera to take a picture and ask for number of waste items',
        child: FloatingActionButton(
          elevation: 7,
          child: Icon(Icons.camera_enhance),
          onPressed: () async {
            //await getImage();
            Navigator.of(context).pushNamed('add_post',
                arguments: Post(
                    url: null,
                    latitude: null,
                    longitude: null,
                    dateTime: null,
                    wasteQuantity: null
                ));
          },
        ));
  }

}
