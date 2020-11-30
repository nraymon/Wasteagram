import 'package:flutter/material.dart';
import 'screens/posts_lists.dart';
import 'screens/show_post.dart';
import 'screens/add_post.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.

  final routes = {
    PostsListState.routeName: (context) => PostsList(),
    ShowPost.routeName: (context) => ShowPost(),
    AddPostState.routeName: (context) => AddPost()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: routes,
    );
  }
}