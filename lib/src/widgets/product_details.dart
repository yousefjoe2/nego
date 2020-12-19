import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../blocs/auth_bloc.dart';
import '../blocs/cart_bloc.dart';
import '../models/product.dart';
import '../routes.dart';
import 'appbar.dart';

// ignore: must_be_immutable
class ProductDetailsPage extends StatefulWidget {
  final Product product;
  bool _fav = false;
  ProductDetailsPage({
    Key key,
    this.product,
  }) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState(product);
}

class _ProductDetailsPageState extends State<ProductDetailsPage>
    with TickerProviderStateMixin<ProductDetailsPage> {
  final Product product;

  _ProductDetailsPageState(this.product);

  @override
  Widget build(BuildContext context) {
    var halfOfScreen = MediaQuery.of(context).size.height / 1.5;
    final cartBloc = Provider.of<CartBloc>(context);

    return Scaffold(
      backgroundColor: Color(0xFFE09900),
      resizeToAvoidBottomPadding: false,
      appBar: MyAppBar(),
      body: Builder(builder: (context) {
        return Container(
          height: double.infinity,
          child: Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              Image(
                image: NetworkImage(product.image),
                height: halfOfScreen,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child:
                    productDetailsSection(product: product, cartBloc: cartBloc),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget productDetailsSection({Product product, CartBloc cartBloc}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    return Container(
      padding: EdgeInsets.all(8),
      height: 320,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 8),
                child: Text(
                  product.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 8),
                child: Text(
                  "Old Price",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 8),
                child: Text(
                  "\$${product.oldPrice.toString() ?? 0.0}",
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 8),
                child: Text(
                  "Price",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 8),
                child: Text(
                  "\$${product.price.toString()}",
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(left: 8),
                child: Text(
                  product.des,
                  maxLines: 10,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          auth.currentUser != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        cartBloc.addToCart(product);
                        Flushbar(
                          backgroundColor: Color(0xFFCEA54C),
                          message: "(${product.title}) added to Cart ❤️",
                          duration: Duration(seconds: 3),
                        )..show(context);
                      },
                      color: Color(0xFFE09900),
                      padding: EdgeInsets.only(
                          top: 12, left: 20, right: 20, bottom: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                      child: Text(
                        "Add To Cart",
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        authBloc..favProduct(product: product);
                        setState(() {
                          widget._fav = !widget._fav;
                        });
                      },
                      color: Color(0xFFE09900),
                      padding: EdgeInsets.only(
                          top: 12, left: 20, right: 20, bottom: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                      child: Icon(
                        FontAwesomeIcons.grinHearts,
                        color: widget._fav ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                )
              : FlatButton(
                  color: Colors.orange,
                  child: Text(
                    'تسجيل ',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, Routes.SIGNUP),
                )
        ],
      ),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
    );
  }
}
