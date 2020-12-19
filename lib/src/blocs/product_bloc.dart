import 'package:rxdart/rxdart.dart';

import '../models/product.dart';
import '../services/firestore_service.dart';

class ProductBloc {
  final _name = BehaviorSubject<String>();
  final _price = BehaviorSubject<String>();
  final _image = BehaviorSubject<String>();
  final _type = BehaviorSubject<String>();
  final _db = FirestoreService();

  Stream<String> get name => _name.stream;
  Stream<String> get type => _type.stream;
  Stream<String> get image => _image.stream;
  Stream<String> get price => _price.stream;
  Function(String) get changeName => _name.sink.add;
  Function(String) get changeType => _type.sink.add;
  Function(String) get changePrice => _price.sink.add;
  Function(String) get changeImage => _image.sink.add;

  Stream<List<Product>> getProducts({String categoryId, String subCategory}) {
    return _db.fetchProducts(
        categoryId: categoryId, subCategoryId: subCategory);
  }

  dispose() {
    _name.close();
    _price.close();
    _type.close();
    _image.close();
  }
}
