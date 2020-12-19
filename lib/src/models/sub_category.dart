import 'package:cloud_firestore/cloud_firestore.dart';

class SubCategory {
  final String id;
  final String name;
  final String image;

  SubCategory({
    this.id,
    this.name,
    this.image,
  });

  factory SubCategory.fromFirestore(DocumentSnapshot doc) {
    Map firestore = doc.data();
    return SubCategory(
      id: doc.id,
      image: firestore['image'] ??
          'https://image.freepik.com/free-vector/hunting-tackle-equipment-icons-set-with-rifles-knives-survival-kit_1284-10758.jpg',
      name: firestore['name'],
    );
  }
  factory SubCategory.fromMap(dynamic obj) {
    return SubCategory(
      id: obj['id'],
      image: obj['image'],
      name: obj['name'],
    );
  }

  @override
  String toString() => 'SubCategory(id: $id, name: $name, image: $image)';
}
