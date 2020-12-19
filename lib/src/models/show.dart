import 'package:cloud_firestore/cloud_firestore.dart';

class Show {
  final String id, name, des, image, price;

  Show({
    this.id,
    this.name,
    this.des,
    this.image,
    this.price,
  });
  factory Show.fromSnapShot(DocumentSnapshot doc) {
    Map data = doc.data();
    return Show(
      id: doc.id,
      name: data['name'] ?? 'Name',
      des: data['desc'] ?? 'Default Description',
      image: data['image'] ?? '',
      price: data['price'].toString() ?? "0.0",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'desc': des,
      'image': image,
      'price': price.toString(),
    };
  }

  @override
  String toString() => 'Show(id:$id,name:$name,price:$price)';
}
