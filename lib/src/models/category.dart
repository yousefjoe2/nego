import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String id, name, image;

  Category({this.id, this.name, this.image});

  Category.map(dynamic obj) {
    this.id = obj['id'];
    this.name = obj['name'];
    this.image = obj['image'] ?? '';
  }

  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();

    return Category(
      id: doc.id,
      name: data['name'] ?? '',
      image: data['image'] ??
          'https://image.freepik.com/free-vector/hunting-tackle-equipment-icons-set-with-rifles-knives-survival-kit1284-10758.jpg',
    );
  }

  @override
  String toString() => 'Category(id:$id,name : $name)';
}
