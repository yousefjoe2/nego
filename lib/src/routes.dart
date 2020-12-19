import 'package:flutter/material.dart';

import 'pages/about.dart';
import 'pages/cart.dart';
import 'pages/checkout.dart';
import 'pages/favorites.dart';
import 'pages/home.dart';
import 'pages/login.dart';
import 'pages/products_list.dart';
import 'pages/profile.dart';
import 'pages/signup.dart';
import 'pages/sub_categories.dart';
import 'widgets/product_details.dart';

abstract class Routes {
  static const String LOGIN = 'login';
  static const String SIGNUP = 'signup';
  static const String HOME = 'home';
  static const String CART = 'cart';
  static const String ABOUT = 'about';
  static const String ACCOUNT = 'profile';
  static const String PRODUCT_DETAILS = 'ProductDetails';
  static const String PRODUCTS = 'Products';
  static const String SUBCATEGORIES = 'subCategories';
  static const String FAVORITES = 'favorites';
  static const String CHECKOUT = 'checkout';
  static MaterialPageRoute routes(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) {
        switch (settings.name) {
          case HOME:
            return HomePage();
          case CART:
            return Cart();
          case SUBCATEGORIES:
            return SubCategoryPage(categoryId: settings.arguments);
          case PRODUCTS:
            return ProductsWidget(categoryArgs: settings.arguments);
          case FAVORITES:
            return Favorites();
          case PRODUCT_DETAILS:
            return ProductDetailsPage(product: settings.arguments);
          case LOGIN:
            return Login();
          case SIGNUP:
            return SignUp();
          case ACCOUNT:
            return ProfilePage();
          case ABOUT:
            return About();
          // case CHECKOUT:
          //   return CheckOutPage();
          default:
            return HomePage();
        }
      },
    );
  }
}
