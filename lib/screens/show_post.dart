import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wasteagram/models/post.dart';

class ShowPost extends StatelessWidget {

  static const routeName = "show_post";

  //ShowPost({this.date, this.imageURL, this.quant, this.location});

  @override
  Widget build(BuildContext context) {

    final Post post = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text("Wasteagram"),
          centerTitle: true,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              children: [
                detailedPostDate(post, context),
                detailedPostImage(post, context),
                detailedPostWaste(post, context),
                detailedPostLocation(post, context)
              ],
            ),
          ),
        ));
  }

  Widget detailedPostDate(Post post, BuildContext context){
    return SizedBox(
      height: widgetHeight(.1, context),
      child: Semantics(
          label: 'date the image was taken',
          child: Padding(
            padding: EdgeInsets.all(18.0),
            child: Text(DateFormat('EEEE, MMM, DDD')
                .format(DateTime.fromMillisecondsSinceEpoch(
                post.dateTime.seconds * 1000))
                .toString(), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 22),),
          )),
    );
  }

  Widget detailedPostImage(Post post, BuildContext context){
    return Center(
      child: SizedBox(
          height: widgetHeight(.35, context),
          child: Semantics(
            label: 'Image of waste',
            image: true,
            child: Image.network(post.url),)
      ),
    );
  }

  Widget detailedPostWaste(Post post, BuildContext context){
    return Center(
      child: SizedBox(
        height: widgetHeight(.13, context),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
          child: Text('Item(s): ${post.wasteQuantity.toString()}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),),
        ),
      ),
    );
  }

  Widget detailedPostLocation(Post post, BuildContext context){
    return Center(
      child: SizedBox(
        height: widgetHeight(.15, context),
        child: Semantics(
            label: 'location where image was taken',
            child: Flex(
              direction: Axis.vertical,
              children: [
                Text(
                  "Location: (${post.latitude.toString()}, ${post.longitude.toString()})", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),)
              ],
            )),
      ),
    );
  }
  
  double widgetHeight(double heightMod, BuildContext context){
    return MediaQuery.of(context).size.height * heightMod;
  }

}
