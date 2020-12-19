import 'package:rxdart/rxdart.dart';

import '../models/product.dart';

class CartBloc {
  final _quentity = BehaviorSubject<double>.seeded(0);
  final _price = BehaviorSubject<double>.seeded(0);
  // final testquant = BehaviorSubject<double>.seeded(0);
  final List<Product> _cartItems = [];
  final Map<String, double> _cartItemsNumber = {};

  //? getters
  Stream<double> get price => _price.stream;
  Stream<double> get quentity => _quentity.stream;
  Map<String, double> get cartItemsNumber => _cartItemsNumber;

  //? setters
  Function(double) get inPrice => _price.sink.add;
  Function(double) get inQuantity => _quentity.sink.add;

  //* [addToCart] adds items from the shop to the cart
  void addToCart(Product product) {
    if (!_cartItems.contains(product)) {
      _quentity.value++;
      _cartItemsNumber[product.id] = 1;
      _cartItems.add(product);
    } else {
      _cartItemsNumber[product.id]++;
    }
    _price.value += double.parse(product.price);
  }

  //* [removeFromCart] removes items from the cart, back to the shop

  void removeFromCart(Product product) {
    if (_cartItems.contains(product) && _cartItemsNumber[product.id] > 0) {
      print("AAAAAAAAAAAAAAAAAAAAAAAA");
      print("asdAAAAAAAAAAAAAAAAAAAAAAAASSS");
      print(_quentity.value);
      if (_quentity.value > 0) {
        _quentity.value--;
      }
    } else if (_cartItemsNumber[product.id] == 1) {
      _cartItems.remove(product);
    }
    if (_cartItemsNumber[product.id] > 1) {
      _cartItemsNumber[product.id]--;
    }
    _price.value -= double.parse(product.price);
  }

  List<Product> get cartItems => _cartItems;

  getPrice(Product product) {
    var total = _cartItemsNumber[product.id] * double.parse(product.price);
    if (total < 0) {
      return 0;
    }
    return total;
  }

  getProductQuenitiy(Product product) {
    return _cartItemsNumber[product.id];
  }

  // getproducttestquent(Product product) {
  //   return _cartItemsNumber[product.id].;
  // }

  dispose() {
    _price.close();
    _quentity.close();
  }
}
