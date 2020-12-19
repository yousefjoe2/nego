import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
// import 'package:firebase_auth/firebase_auth.dart';

import '../models/category.dart';
import '../models/product.dart';
import '../models/show.dart';
import '../models/sub_category.dart';
import '../models/user.dart';
import '../blocs/cart_bloc.dart';

final rxPrefs = RxSharedPreferences.getInstance();

class FirestoreService {
  // Firebase
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addUser(User user) {
    return _db.collection('users').doc(user.userId).set(user.toMap());
  }

  Future<User> fetchUser(String userId) {
    print(userId);
    return _db
        .collection('users')
        .doc(userId)
        .get()
        .then((snapshot) => User.fromFirestore(snapshot.data()));
  }

  Future<void> setProduct(Product product) {
    return _db.collection('products').doc(product.id).set(product.toMap());
  }

  Future<List<Category>> fetchCategories() {
    return _db.collection('categories').get().then(
        (value) => value.docs.map((e) => Category.fromFirestore(e)).toList());
  }

  Stream<List<SubCategory>> fetchSubCategories({String categoryId}) {
    var ref =
        _db.collection('categories').doc(categoryId).collection('subCategory');

    return ref.snapshots().map((list) =>
        list.docs.map((doc) => SubCategory.fromFirestore(doc)).toList());
  }

  Stream<List<Product>> fetchProducts(
      {String categoryId, String subCategoryId}) {
    var ref = _db
        .collection('categories')
        .doc(categoryId)
        .collection('subCategory')
        .doc(subCategoryId)
        .collection('products');
    return ref.snapshots().map(
        (list) => list.docs.map((doc) => Product.fromSnapShot(doc)).toList());
  }

  //-----Shows--------
  Future<List<Show>> fetchShows() {
    return _db
        .collection('shows')
        .get()
        .then((docs) => docs.docs.map((e) => Show.fromSnapShot(e)).toList());
  }

  Future<void> deleteShow({String showId}) {
    return _db.collection('shows').doc(showId).delete();
  }

  //-----Favorites--------
  Stream<List<Product>> fetchFavs({String userId}) {
    var ref = _db.collection('favorites').doc(userId).collection('products');
    return ref.snapshots().map(
        (list) => list.docs.map((doc) => Product.fromSnapShot(doc)).toList());
  }

  Future<void> setFavorite({Product product, String userId}) {
    var ref = _db.collection('favorites').doc(userId).collection('products');

    return ref.add(product.toMap());
  }

  Future<void> deleteFavorite({String userId, String productId}) {
    var ref = _db.collection('favorites').doc(userId).collection('products');

    return ref.doc(productId).delete();
  }

  //-----Orders-----
  Future<bool> saveOrder(
      {List<Product> products,
      String userId,
      String quantity,
      var list_quantity}) async {
    var ref = _db.collection('orders');
    print("XXXXXXXXXXXX");
    print("ZZZZZZZZZZZZZZZZZZZZZZ");
    var x = 0;
    await products.forEach((element) async {
      element.isfinished = 'false';
      element.orderedbyid = userId;
      element.orderedbyemail = await rxPrefs.getString('user_email');
      element.orderedbyphone = await rxPrefs.getString('user_phone');
      element.orderedbyname = await rxPrefs.getString('user_name');
      element.testquant = list_quantity[x];
      element.quantity = quantity;
      ref.add(element.toMap()).then((value) {
        ref.doc(value.id).update({
          'order': value.id,
        });
      });
      x++;
    });

    // products.forEach((element) {


    //   print(CartBloc().getPrice(element));
    //   // print(element.);
    // });
    // print(products[0]);

    return true;
  }
}
