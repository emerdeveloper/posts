import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:posts/BLoC/bloc/post_bloc.dart';
import 'package:posts/Model/Post.dart';
import 'package:posts/repository/post_respository.dart';

class PostPage extends StatefulWidget {
  PostPage({Key key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final PostRepository _postRepository = PostRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Publicaciones'),
      ),
      body: BlocProvider<PostBloc>(
        create: (context) =>
            PostBloc(postRespository: _postRepository)..add(ShowPostsEvent()),
        child: _createConteinerList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Crear publicación',
        onPressed: () => Navigator.pushNamed(context, 'createPost'))
    );
  }

  Widget _createConteinerList() {
    return BlocBuilder<PostBloc, PostState>(builder: (context, state) {
      if (state is PostLoadingState) {
        return _createLoading();
      }
      if (state is PostNoLoadedState) {
        return _createError();
      }
      if (state is PostLoadedState) {
        return _showPost(state.posts);
      }
      return Container();
    });
  }

  Widget _createLoading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _createError() {
    return Center(
        child: Column(
      children: <Widget>[
        Icon(Icons.error_outline_rounded),
        Text('Hubo un error inesperado al obtener las publicaciones')
      ],
    ));
  }

  Widget _showPost(List<Post> posts) {
    return Container(
        child: posts.length == 0
            ? Center(
                child: Text('No hay publicaciones disponibles'),
              )
            : ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return _createCardItem(posts[index]);
                }));
  }

  Widget _createCardItem(Post post) {
    TransformationController _transformationController = TransformationController();
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.all(14.0),
      child: Container(
          padding: EdgeInsets.all(14.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        post.date,
                        style: Theme.of(context).textTheme.subtitle1,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        post.time,
                        style: Theme.of(context).textTheme.subtitle1,
                        textAlign: TextAlign.center,
                      )
                    ]),
                SizedBox(height: 18.0),
                InteractiveViewer(
                  transformationController: _transformationController,
                  child: Center(
                    child: FadeInImage(
                      placeholder: AssetImage('assets/loading.gif'), 
                      image: NetworkImage(post.image),
                      fit: BoxFit.cover,
                      height: 300.0),
                  ),
                  onInteractionEnd: (ScaleEndDetails scalesEnd) {
                    _transformationController.value = Matrix4.identity();
                  },
                ),
                SizedBox(height: 10.0),
                Text(
                  post.description,
                  style: Theme.of(context).textTheme.subtitle2,
                  textAlign: TextAlign.center,
                )
              ])),
    );
  }
}
