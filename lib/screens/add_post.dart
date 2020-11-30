import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'dart:io';
import 'posts_lists.dart';
import 'package:wasteagram/widgets/semantic_text_field.dart';
import 'package:wasteagram/models/post.dart';

// GET IMAGE IN INIT STATE?

class AddPost extends StatefulWidget {
  @override
  AddPostState createState() => AddPostState();
}

class AddPostState extends State<AddPost> {
  static const routeName = "add_post";
  Post post;

  final formKey = GlobalKey<FormState>();

  LocationData locationData;
  var locationService = Location();

  var image;

  String url = '';

  @override
  void initState() {
    super.initState();
    getLocation();
    getImage();
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
    post.url = url;
//    print(url);
  }

  @override
  Widget build(BuildContext context) {
    Post post = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text('Wasteagram'),
          centerTitle: true,
        ),
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        body: addBuilder(post));
  }

  Future getStuff() async{
    //await getImage();
    //await getLocation();
  }

  Widget addBuilder(var post) {
    return FutureBuilder(
      future: getLocation(),
      builder: (context, snapshot) {
        if (locationData != null) {
          return Form(
            key: formKey,
            child: Column(
              children: [
                Container(
                  height: screenHeight() * .25,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    child: Semantics(
                        label: 'image of waste items',
                        button: false,
                        child: Image.file(image)),
                  ),
                ),
                Container(
                  child: semanticTextField(post),
                ),
                Spacer(),
                Expanded(child: uploadButton(post)),
              ],
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future setLocation(Post post) {
    post.latitude = locationData.latitude;
    post.longitude = locationData.longitude;
  }

  Widget uploadButton(Post post) {
    return SizedBox(
        height: screenHeight() * .23,
        width: screenWidth(),
        child: Semantics(
            label: 'upload button',
            button: true,
            onTapHint: 'uploads the picture and post data',
            child: FlatButton(
              color: Colors.blue,
              splashColor: Colors.blueAccent,
              child: Icon(
                Icons.cloud_upload,
                size: 60,
              ),
              onPressed: () async {
                if (formKey.currentState.validate()) {
                  formKey.currentState.save();
                  await setLocation(post);
                  await Firestore.instance
                      .collection('posts')
                      .add(post.toMap());
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(PostsListState.routeName);
                }
              },
            )));
  }

  Future getLocation() async {
    try {
      var _serviceEnabled = await locationService.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await locationService.requestService();
        if (!_serviceEnabled) {
          print('Failed to enable service. Returning.');
          return;
        }
      }

      var _permissionGranted = await locationService.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await locationService.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          print('Location service permission not granted. Returning.');
        }
      }

      locationData = await locationService.getLocation();
    } on PlatformException catch (e) {
      print('Error: ${e.toString()}, code: ${e.code}');
      locationData = null;
    }
    locationData = await locationService.getLocation();
    setState(() {});

  }

  double screenHeight() {
    return MediaQuery.of(context).size.height;
  }

  double screenWidth() {
    return MediaQuery.of(context).size.width;
  }
}
