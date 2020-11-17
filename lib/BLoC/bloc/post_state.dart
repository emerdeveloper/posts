part of 'post_bloc.dart';

@immutable
abstract class PostState extends Equatable {

  @override
  List<Object> get props => [];
}

class PostLoadingState extends PostState {

  @override
  String toString() => 'PostLoading';
}

class PostLoadedState extends PostState {
  final List<Post> posts;

  PostLoadedState([this.posts]);
  
  @override
  List<Object> get props => [posts];

  @override
  String toString() => 'PostLoaded';
}

class PostNoLoadedState extends PostState {

  @override
  String toString() => 'PostNoLoaded';
}

class PostCreatingState extends PostState {

  @override
  String toString() => 'PostCreatingState';
}

class PostCreatedState extends PostState {

  @override
  String toString() => 'PostCreatedState';
}

class ImagePickedState extends PostState {

  @override
  String toString() => 'ImagePickedState';
}
