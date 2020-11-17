import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts/BLoC/bloc/post_bloc.dart';

import 'package:posts/UI/create_post_page.dart';
import 'package:posts/UI/post_page.dart';

Map<String, WidgetBuilder> getAplicationRoutes() {
  return <String, WidgetBuilder> {
    '/'           : (BuildContext context) => PostPage(),
    'createPost'  : (BuildContext context) => CreatePostPage(
                  onSave: (File image, String description) { 
                    BlocProvider.of<PostBloc>(context).add(CreatePostEvent(image, description));
                   },
                   onImagedPicked: () {
                    BlocProvider.of<PostBloc>(context).add(ImagePickedEvent());
                   } 
    ),
  };
}