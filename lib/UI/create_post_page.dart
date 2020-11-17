import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:posts/BLoC/bloc/post_bloc.dart';

typedef OnSaveCallBack = Function(File image, String description);
typedef OnImagePickedCallBack = Function();

class CreatePostPage extends StatefulWidget {
  final OnSaveCallBack onSave;
  final OnImagePickedCallBack onImagedPicked;
  CreatePostPage({Key key, @required this.onSave, @required this.onImagedPicked}) : super(key: key);

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {

  File simpleImage;
  String description;
  final formKey = GlobalKey<FormState>();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear publicación'),
      ),
      body: Center(
        child: _createContainer()
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_photo_alternate),
        tooltip: 'Seleccionar foto',
        onPressed: _pickeImage,
      ),
    );
  }

  Future _pickeImage() async {
    ImagePicker picker = ImagePicker();
    await picker.getImage(
      source: ImageSource.gallery
      ).then((PickedFile file) {
        simpleImage = File(file.path);
        widget.onImagedPicked();
      });
  }

  Widget _createContainer() {
    return BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostCreatedState) {
            Navigator.pop(context, true);
          }
        },
        child: BlocBuilder<PostBloc, PostState>(builder: (context, state) {
          if (simpleImage == null) {
            return Text('Selecciona una foto');
          } 
          if (state is PostCreatingState) {
            return _createLoading();
          }
          // if (state is PostCreatedState) {
          //   _myCallback(() {
          //     Navigator.pop(context, true);
          //   });
          // }
          if (state is ImagePickedState) {
            return _enableCreatePost();
          }
          return Container();
        })
      );
  }

  Widget _enableCreatePost() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(key: formKey,
          child: Column(children: [
            Image.file(simpleImage, height: 300.0, width: 600.0, fit: BoxFit.cover),
            SizedBox(height: 15.0),
            TextFormField(
              decoration: InputDecoration(hintText: 'Escriba una descripción', labelText: 'Descripción'),
              validator: _valdateDescription,
              onSaved: (String text) => description = text,
            ),
            SizedBox(height: 15.0,),
            RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              shape: StadiumBorder(),
              child: Text('Crear publicación'),
              onPressed: _createPost)
          ]),
        ),
      ),
    );
  }

  String _valdateDescription(String text) {
    return text.isEmpty ? 'Descripción es requerida' : null;
  }

  void _createPost() {
    if (_isValidForm()) {
      formKey.currentState.save();
      widget.onSave(simpleImage, description);
    }
  }

  bool _isValidForm() {
    return formKey.currentState.validate();
  }

  Widget _createLoading() {
    return Center(child: CircularProgressIndicator());
  }

  void _myCallback(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
}
}