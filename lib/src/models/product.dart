import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
   String id,
      title,
      des,
      image,
      categoryId,
      price,
      oldPrice,
      fav,
      quantity,
      order,
      orderedbyid,
      orderedbyemail,
      orderedbyname,
      orderedbyphone,
      isfinished,
      testquant;

  Product(
      {this.id,
      this.title,
      this.des,
      this.image,
      this.fav,
      this.categoryId,
      this.price,
      this.oldPrice,
      this.quantity,
      this.order,
      this.orderedbyid,
      this.orderedbyemail,
      this.orderedbyname,
      this.orderedbyphone,
      this.isfinished,
      this.testquant});

  factory Product.fromSnapShot(DocumentSnapshot doc) {
    Map data = doc.data();
    return Product(
        id: doc.id,
        title: data['title'] ?? 'Name',
        des: data['desc'] ?? 'Default Description',
        image: data['image'] ?? '',
        price: data['price'].toString() ?? "0.0",
        oldPrice: data['oldPrice'].toString() ?? "0.0",
        categoryId: data['categoryid'] ?? "",
        fav: "",
        quantity: data['quantity'],
        order: data['order'],
        orderedbyid: data['orderedbyid'],
        orderedbyemail: data['orderedbyemail'],
        orderedbyname: data['orderedbyname'],
        orderedbyphone: data['orderedbyphone'],
        isfinished: data['isfinished'],
        testquant: data['testquant']);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'desc': des,
      'image': image,
      'categoryid': categoryId,
      'oldPrice': oldPrice.toString(),
      'price': price.toString(),
      'fav': fav ?? "",
      'quantity': quantity,
      'order': order,
      'orderedbyid': orderedbyid,
      'orderedbyemail': orderedbyemail,
      'orderedbyname': orderedbyname,
      'orderedbyphone': orderedbyphone,
      'isfinished': isfinished,
      'testquant': testquant,
    };
  }

  @override
  String toString() =>
      'Product(id:$id,name:$title,price:$price,oldPrice:$oldPrice,categoryId:$categoryId,fav:$fav,quantity:$quantity,order:$order,orderedbyid:$orderedbyid,orderedbyemail:$orderedbyemail,orderedbyname:$orderedbyname,orderedbyphone:$orderedbyphone,isfinished:$isfinished,testquant:$testquant)';
}
