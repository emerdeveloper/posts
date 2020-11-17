import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:posts/BLoC/bloc/post_bloc.dart';
import 'package:posts/BLoC/simple_bloc_delegate.dart';
import 'package:posts/repository/post_respository.dart';
import 'package:posts/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostBloc>(
      create: (context) => PostBloc(postRespository: PostRepository()),
      child: MaterialApp(
        title: 'Flutter Posts',
        //home: PostPage()
        initialRoute:  '/',
        routes: getAplicationRoutes(),
      )
    );
  }
}