import 'package:rxdart/rxdart.dart';

import '../models/category.dart';
import '../models/sub_category.dart';
import '../services/firestore_service.dart';

class CategoriesBloc {
  final _name = BehaviorSubject<String>();
  final _type = BehaviorSubject<String>();
  final _db = FirestoreService();

  Stream<String> get name => _name.stream;
  Stream<String> get type => _type.stream;

  Function(String) get changeName => _name.sink.add;
  Function(String) get changeType => _type.sink.add;

  Future<List<Category>> getcategories() async {
    return await _db.fetchCategories();
  }

  Stream<List<SubCategory>> getSubCategories({String categoryId}) {
    return _db.fetchSubCategories(categoryId: categoryId);
  }

  dispose() {
    _name.close();
    _type.close();
  }
}
