import 'package:rxdart/rxdart.dart';

import '../models/show.dart';
import '../services/firestore_service.dart';

class ShowsBloc {
  final _loading = BehaviorSubject<bool>.seeded(false);
  final _name = BehaviorSubject<String>();
  final _price = BehaviorSubject<String>();
  final _desc = BehaviorSubject<String>();
  final _db = FirestoreService();

  Stream<String> get name => _name.stream;
  Stream<bool> get isLoading => _loading.stream;
  Stream<String> get desc => _desc.stream;

  Stream<String> get price => _price.stream;

  Function(String) get changeName => _name.sink.add;
  Function(bool) get changeIsLoading => _loading.sink.add;
  Function(String) get changeDesc => _desc.sink.add;
  Function(String) get changePrice => _price.sink.add;

  Future<List<Show>> getShows() {
    return _db.fetchShows();
  }

  Future<void> deleteShow({String showId}) {
    changeIsLoading(true);
    _db.deleteShow(showId: showId);
    changeIsLoading(false);
    return null;
  }

  dispose() {
    _name.close();
    _price.close();
    _loading.close();
    _desc.close();
  }
}
