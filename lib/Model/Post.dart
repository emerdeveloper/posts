
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;

class Post {
  final String image, description, date, time, id, dateCreated;

  Post(this.image, this.description, this.date, this.time, this.id, this.dateCreated);
  
  static Post  fromSnapshot(DocumentSnapshot snapshot) {
    return Post(
      snapshot.get('image'),
      snapshot.get('description'),
      snapshot.get('date'),
      snapshot.get('time'),
      snapshot.id,
      snapshot.get('dateCreated'));
  }
}