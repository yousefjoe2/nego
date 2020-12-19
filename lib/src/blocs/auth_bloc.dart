import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';
import 'package:flutter/material.dart';
import '../routes.dart';

import '../models/product.dart';
import '../models/user.dart';
import '../services/firestore_service.dart';

final RegExp regExpEmail = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

class AuthBloc {
  AuthBloc() {
    this.getFavorites();
  }
  final _loading = BehaviorSubject<bool>();
  final _email = BehaviorSubject<String>();
  final _name = BehaviorSubject<String>();
  final _phone = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _user = BehaviorSubject<User>();
  final _errorMessage = BehaviorSubject<String>();
  final _favorites = BehaviorSubject<List<Product>>.seeded([]);
  final Auth.FirebaseAuth _auth = Auth.FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final _rxPrefs = RxSharedPreferences.getInstance();

  //Get Data
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get name => _email.stream;
  Stream<String> get phone => _email.stream;
  Stream<String> get password => _password.stream.transform(validatePassword);
  Stream<bool> get isValid =>
      CombineLatestStream.combine2(email, password, (email, password) => true);
  Stream<User> get user => _user.stream;
  Stream<String> get errorMessage => _errorMessage.stream;
  Stream<bool> get isLoading => _loading.stream;
  Stream<List<Product>> get favorites => _favorites.stream;
  String get userId => _user.value.userId;
  String get getPhone => _user.value.phone;

  //Set Data
  Function(List<Product>) get setFavorites => _favorites.sink.add;
  Function(String) get changeEmail => _email.sink.add;
  Function(bool) get changeIsLoading => _loading.sink.add;
  Function(String) get changeName => _name.sink.add;
  Function(String) get changePhone => _phone.sink.add;
  Function(String) get changePassword => _password.sink.add;
  String get getEmail => _user.value.email;
  bool get getIsLoading => _loading.value;
  String get getName => _user.value.name;

  //Transformers
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (regExpEmail.hasMatch(email.trim())) {
      sink.add(email.trim());
    } else {
      sink.addError('Must Be Valid Email Address');
    }
  });
  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 8) {
      sink.add(password.trim());
    } else {
      sink.addError('Must Be 8 Character Minimum');
    }
  });

  //Functions
  Future<void> signupEmailAndPassword() async {
    changeIsLoading(true);
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
        email: _email.value.trim(),
        password: _password.value.trim(),
      );

      //name: _name.value.trim()
      var user = User(
          userId: authResult.user.uid,
          email: _email.value.trim(),
          name: _name.value,
          phone: _phone.value);
      await _firestoreService.addUser(user);
      _fcm.subscribeToTopic('new-product');
      changeIsLoading(false);
    } on PlatformException catch (error) {
      print("PlatformException");
      changeIsLoading(false);
      _errorMessage.sink.add(error.message);
    } on FirebaseException catch (error) {
      print("FirebaseException");
      changeIsLoading(false);
      if (error.code == 'user-not-found') {
        _errorMessage.sink.add('No user found for that email.');
      } else if (error.code == 'wrong-password') {
        _errorMessage.sink.add('Wrong password provided for that user.');
      } else {
        _errorMessage.sink.add(error.code);
      }
    } on Exception catch (error) {
      print("Exception");
      changeIsLoading(false);
      _errorMessage.sink.add(error.toString());
    } finally {
      print("final");
      changeIsLoading(false);
    }
  }

  Future<void> loginEmailAndPassword(BuildContext context) async {
    changeIsLoading(true);
    try {
      final authResult = await _auth.signInWithEmailAndPassword(
          email: _email.value.trim(), password: _password.value.trim());

      // var user = await  authResult.user.uid;
      var user_id = await authResult.user.uid;
      var user = await _firestoreService.fetchUser(user_id);

      _user.sink.add(user);

      _fcm.subscribeToTopic('new-product');

      var user_email = await authResult.user.email;

      _rxPrefs.setString('user_id', user_id);
      _rxPrefs.setString('user_email', user_email);

      var datauser = await FirebaseFirestore.instance
          .collection('users')
          .doc('$user_id')
          .get();

      _rxPrefs.setString('user_name', datauser.data()['name']);
      _rxPrefs.setString('user_phone', datauser.data()['phone']);
      print(datauser.data()['phone']);

      changeIsLoading(false);
      Navigator.pushReplacementNamed(context, Routes.HOME);
    } on PlatformException catch (error) {
      print("PlatformException");
      changeIsLoading(false);
      _errorMessage.sink.add(error.message);
    } on FirebaseException catch (error) {
      print("FirebaseException");
      changeIsLoading(false);
      _errorMessage.sink.add(error.code);
    } on Exception catch (error) {
      print("exception");
      changeIsLoading(false);
      print(error.toString());
      _errorMessage.sink.add(error.toString());
    } finally {
      print("final");
      changeIsLoading(false);
    }
  }

  Future<void> updateUserDate() async {
    changeIsLoading(true);
    await _firestoreService.addUser(User(
        userId: authBloc.userId,
        email: getEmail,
        name: getName,
        phone: getPhone));
    changeIsLoading(false);
  }

  Future<bool> isLoggedIn() async {
    if (_auth.currentUser == null) return false;
    print(_auth.currentUser.uid);
    var user = await _firestoreService.fetchUser(_auth.currentUser.uid);
    if (user == null) return false;

    _user.sink.add(user);
    return true;
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user.sink.add(null);
  }

  clearErrorMessage() {
    _errorMessage.sink.add('');
  }

  Stream<List<Product>> getFavorites() {
    if (_auth.currentUser == null) return null;
    _firestoreService
        .fetchFavs(userId: _auth.currentUser?.uid)
        .map((favs) => setFavorites(favs));
    return favorites;
  }

  Stream<dynamic> hasFav({String productId}) {
    return _rxPrefs.getStream(productId);
  }

  Future<bool> favProduct({Product product}) async {
    if (!await _rxPrefs.containsKey(product.id))
      // this.hasFav(productId: product.id);
      _rxPrefs.setString(product.id, product.id);
    else
      await _rxPrefs.remove(product.id);

    return true;
  }

  Future<bool> unFavProduct({String productId}) async {
    return await _rxPrefs.remove(productId);
  }

  Future<bool> saveOrder(List<Product> prducts, String userId, String quantity,
      var list_quantity) async {
    return _firestoreService.saveOrder(
        products: prducts,
        userId: userId,
        quantity: quantity,
        list_quantity: list_quantity);
  }

  dispose() {
    _email.close();
    _name.close();
    _phone.close();
    _password.close();
    _user.close();
    _favorites.close();
    _errorMessage.close();
    _loading.close();
    _rxPrefs.dispose();
  }
}

final authBloc = AuthBloc();
