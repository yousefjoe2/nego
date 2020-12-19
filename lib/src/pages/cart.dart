import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:negpchi/src/blocs/auth_bloc.dart';
import 'package:negpchi/src/pages/home.dart';
import 'package:negpchi/src/widgets/text_style.dart';
import 'package:provider/provider.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

import '../blocs/cart_bloc.dart';
import '../models/product.dart';
import '../widgets/appbar.dart';

int indexoflistquantit = 0;
final rxPrefs = RxSharedPreferences.getInstance();
Map<String, String> list_quantit = {};

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartBloc>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: MyAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Cart",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: cart.cartItems.length,
                itemBuilder: (context, i) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 25),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.white,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child:
                                  Image.network("${cart.cartItems[i].image}"),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "${cart.cartItems[i].title}",
                              ),
                              Text(
                                "${cart.cartItems[i].price}",
                              ),
                              SizedBox(height: 15),
                              MyCounter(product: cart.cartItems[i]),
                              RaisedButton(
                                color: Colors.red,
                                onPressed: () {
                                  setState(() {
                                    list_quantit.remove(cart.cartItems[i].id);
                                    cart.cartItems.remove(cart.cartItems[i]);
                                    print(list_quantit);
                                  });
                                },
                                child: Text('Remove'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    showThankYouBottomSheet(context);
                    print('hello');
                  },
                  child: Text(
                    "Complete Order",
                    style: CustomTextStyle.textFormFieldMedium.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  color: Colors.orangeAccent,
                  textColor: Colors.white,
                ),
                // SizedBox(width: 30),
                // Expanded(
                //   child: Padding(
                //     padding: const EdgeInsets.only(right: 25),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.end,
                //       children: <Widget>[
                //         StreamBuilder<double>(
                //             stream: cart.price,
                //             builder: (context, snapshot) {
                //               if (snapshot.hasData) {
                //                 var mytotalprice = snapshot.data;
                //                 if (mytotalprice < 0) {
                //                   mytotalprice = 0;
                //                 }
                //                 return Text("\$ ${mytotalprice}",
                //                     style:
                //                         Theme.of(context).textTheme.headline6);
                //               }

                //               return Container();
                //             }),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  showThankYouBottomSheet(BuildContext context) {
    final auth = Provider.of<AuthBloc>(context, listen: false);
    final user = Auth.FirebaseAuth.instance.currentUser;
    final cart = Provider.of<CartBloc>(context, listen: false);
    return _scaffoldKey.currentState.showBottomSheet((context) {
      return Container(
        height: 400,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200, width: 2),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image(
                    image: AssetImage("assets/images/ic_thank_you.png"),
                    width: 300,
                  ),
                ),
              ),
              flex: 5,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: <Widget>[
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                            text: "\nThank you for your purchase.",
                            style: CustomTextStyle.textFormFieldMedium.copyWith(
                                fontSize: 14, color: Colors.grey.shade800),
                          )
                        ])),
                    SizedBox(height: 10),
                    Text(user.displayName),
                    SizedBox(height: 10),
                    Text(user.email),
                    RaisedButton(
                      onPressed: () async {
                        // TODO: السبب ان شيلت الزرار اللي لما كنت بدوس علية كان بيعمل
                        //rxPrefs.setString('list_quantity')
                        //لازم اضيفة

                        var json_quantity =
                            await rxPrefs.getString('list_quantity');
                        print('gettttttttttttttt');
                        print('myyyyyygettttstttttssttttstt');
                        print(json_quantity);
                        var map_quantity = jsonDecode(json_quantity);
                        print(map_quantity);
                        var list_quantity = map_quantity.values.toList();
                        print(list_quantity);
                        auth.saveOrder(cart.cartItems, user.uid, 'no notes',
                            list_quantity);
                        Navigator.of(context).pop();
                      },
                      padding: EdgeInsets.only(left: 48, right: 48),
                      child: Text(
                        "Save Order",
                        style: CustomTextStyle.textFormFieldMedium
                            .copyWith(color: Colors.white),
                      ),
                      color: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                    )
                  ],
                ),
              ),
              flex: 5,
            )
          ],
        ),
      );
    },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        backgroundColor: Colors.white,
        elevation: 2);
  }
}

class MyCounter extends StatefulWidget {
  final Product product;

  const MyCounter({Key key, this.product}) : super(key: key);

  @override
  _MyCounterState createState() => _MyCounterState();
}

class _MyCounterState extends State<MyCounter> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartBloc>(context);
    var numOfItems = cart.cartItemsNumber['${widget.product.id}'] ?? 0;

    list_quantit[widget.product.id] = numOfItems.toInt().toString();

    rxPrefs.setString('list_quantity', jsonEncode(list_quantit));
    print(list_quantit);
    var x = 10;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SizedBox(width: 15),
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orangeAccent,
                ),
                child: Icon(
                  Icons.remove,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                setState(() {
                  if (numOfItems.toInt() >= -1) {
                    numOfItems--;

                    cart.removeFromCart(widget.product);
                  }
                });
              },
            ),
            SizedBox(width: 10),
            Text(
              numOfItems.toInt().toString(),
              style: GoogleFonts.tajawal()
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            SizedBox(width: 10),
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orangeAccent,
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                setState(() {
                  numOfItems++;
                  cart.addToCart(widget.product);
                });
              },
            ),
            SizedBox(width: 15),
          ],
        ),
        // RaisedButton(
        //   onPressed: () {
        //     removefrommap();
        //   },
        //   child: Text('Remove'),
        // ),
      ],
    );
  }
}
