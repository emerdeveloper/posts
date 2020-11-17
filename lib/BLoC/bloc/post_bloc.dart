import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:posts/Model/Post.dart';
import 'package:posts/repository/post_respository.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository _postRespository;
  StreamSubscription _postSubscription;

  PostBloc({@required PostRepository postRespository})
      : assert(postRespository != null),
        _postRespository = postRespository,
        super(PostLoadingState());

  @override
  Stream<PostState> mapEventToState(
    PostEvent event,
  ) async* {
    if (event is ShowPostsEvent) {
      yield* _mapLoadPostToState();
    } else if (event is CreatePostEvent) {
      yield* _mapCreatePostToState(event);
    } else if (event is PostCreatedEvent) {
      yield* _mapCreatedPostToState(event);
    } else if (event is NewPostPublishedEvent) {
      yield* _mapNewPostPublishedToState(event);
    } else if (event is ImagePickedEvent) {
      yield* _mapImagePickedToState();
    }
  }

  Stream<PostState> _mapLoadPostToState() async* {
    yield PostLoadingState();
    _postSubscription?.cancel();
    try {
      _postSubscription = _postRespository.getPosts().listen(
        lisenerChanges
        );
    } catch (e) {
      print(e);
      yield PostNoLoadedState();
    }
  }

  void lisenerChanges(List<Post> posts) {
    add(NewPostPublishedEvent(posts));
  }

  Stream<PostState> _mapCreatePostToState(CreatePostEvent event) async* {
    yield PostCreatingState();
    await _postRespository.createPost(event.image, event.description);
    add(PostCreatedEvent());
  }

  Stream<PostState> _mapCreatedPostToState(PostCreatedEvent event) async* {
    yield PostCreatedState();
  }

  Stream<PostState> _mapNewPostPublishedToState(NewPostPublishedEvent event) async* {
    yield PostLoadedState(event.posts);
  }

  Stream<PostState> _mapImagePickedToState() async* {
    yield ImagePickedState();
  }

  @override
  Future<void> close() {
    _postSubscription?.cancel();
    return super.close();
  }
}
