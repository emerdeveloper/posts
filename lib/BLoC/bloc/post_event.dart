part of 'post_bloc.dart';

@immutable
abstract class PostEvent extends Equatable {

  PostEvent();

  @override
  List<Object> get props => [];
}

class ShowPostsEvent extends PostEvent { }

class CreatePostEvent extends PostEvent {
  final File image;
  final String description;

  CreatePostEvent(this.image, this.description);
  
  @override
  List<Object> get props => [image, description];

  @override
  String toString() => 'CreatePost';
} 

class PostCreatedEvent extends PostEvent {

  @override
  String toString() => 'PostCreted';
}

class ImagePickedEvent extends PostEvent {

  @override
  String toString() => 'ImagePickedEvent';
}

class NewPostPublishedEvent extends PostEvent {
  final List<Post> posts;

  NewPostPublishedEvent(this.posts);
  
  @override
  List<Object> get props => [posts];

  @override
  String toString() => 'NewPostPublishedEvent';
}