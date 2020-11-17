
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

import 'package:posts/Model/Post.dart';

class PostRepository {
  final firestoreReference = FirebaseFirestore.instance.collection('posts');

  Stream<List<Post>> getPosts() {
    return firestoreReference.orderBy('dateCreated', descending: true).snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.isEmpty ? List<Post>() :
      snapshot.docs.map((document) => Post.fromSnapshot(document)).toList();
    });
  }

  Future<void> createPost(File image, String description) async {
    final Reference storageReference = FirebaseStorage.instance.ref().child("Images");
    var dateTime = DateTime.now();
    final UploadTask uploadTask = storageReference.child('${dateTime.toString()}.jpg').putFile(image);
    await uploadTask.then((TaskSnapshot taskSnapshot) async {
       await taskSnapshot.ref.getDownloadURL().then((dynamic imageUrl) {

        Post post = Post(
        imageUrl.toString(), 
        description, 
        _getDateFormat(dateTime), 
        _getTimeFormat(dateTime), 
        null,
        dateTime.microsecondsSinceEpoch.toString());
    
        _savePost(post);
      });
    });
  }

  String _getDateFormat(DateTime dateTime) {
    var formatDate = DateFormat('MMM d, yyy');
    return formatDate.format(dateTime);
  }

  String _getTimeFormat(DateTime dateTime) {
    var formatDate = DateFormat('EEEE, hh:mm aaa');
    return formatDate.format(dateTime);
  }

  Future<void> _savePost(Post post) {
    return firestoreReference.doc().set(
      {
        'image': post.image,
        'description': post.description,
        'date': post.date,
        'time': post.time,
        'dateCreated': post.dateCreated
      }
    );
  }

}