// import 'dart:convert';

// import 'package:firebase_auth/firebase_auth.dart' as Auth;
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:rx_shared_preferences/rx_shared_preferences.dart';

// import '../blocs/blocs.dart';
// import '../widgets/appbar.dart';
// import '../widgets/text_style.dart';

// class CheckOutPage extends StatefulWidget {
//   @override
//   _CheckOutPageState createState() => _CheckOutPageState();
// }

// class _CheckOutPageState extends State<CheckOutPage> {
//   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

//   @override
//   Widget build(BuildContext context) {
//     final cart = Provider.of<CartBloc>(context);
//     return Scaffold(
//       key: _scaffoldKey,
//       resizeToAvoidBottomPadding: false,
//       appBar: MyAppBar(),
//       body: Builder(builder: (context) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             Container(
//               height: MediaQuery.of(context).size.height * 0.75,
//               child: ListView.builder(
//                 itemCount: cart.cartItems.length,
//                 itemBuilder: (context, i) {
//                   // var totalprice = int.parse(cart.cartItems[i].price) *
//                   //     int.parse(cart.cartItems[i].testquant);
//                   return Container(
//                     margin: const EdgeInsets.only(bottom: 25),
//                     child: Row(
//                       children: <Widget>[
//                         Expanded(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15.0),
//                               color: Colors.white,
//                             ),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(10)),
//                               ),
//                               child:
//                                   Image.network("${cart.cartItems[i].image}"),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 15),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 "Product: ${cart.cartItems[i].title}",
//                               ),

//                               // Text(
//                               //   "Total: ${totalprice}",
//                               // ),
//                               SizedBox(height: 15),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Spacer(),
//             RaisedButton(
//               onPressed: () {
//                 showThankYouBottomSheet(context);
//                 print('hello');
//               },
//               child: Text(
//                 "Complete Order",
//                 style: CustomTextStyle.textFormFieldMedium.copyWith(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               color: Colors.orangeAccent,
//               textColor: Colors.white,
//             )
//           ],
//         );
//       }),
//     );
//   }

//   showThankYouBottomSheet(BuildContext context) {
//     final auth = Provider.of<AuthBloc>(context, listen: false);
//     final user = Auth.FirebaseAuth.instance.currentUser;
//     final cart = Provider.of<CartBloc>(context, listen: false);
//     return _scaffoldKey.currentState.showBottomSheet((context) {
//       return Container(
//         height: 400,
//         decoration: BoxDecoration(
//             color: Colors.white,
//             border: Border.all(color: Colors.grey.shade200, width: 2),
//             borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(16), topLeft: Radius.circular(16))),
//         child: Column(
//           children: <Widget>[
//             Expanded(
//               child: Container(
//                 child: Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Image(
//                     image: AssetImage("assets/images/ic_thank_you.png"),
//                     width: 300,
//                   ),
//                 ),
//               ),
//               flex: 5,
//             ),
//             Expanded(
//               child: Container(
//                 margin: EdgeInsets.only(left: 16, right: 16),
//                 child: Column(
//                   children: <Widget>[
//                     RichText(
//                         textAlign: TextAlign.center,
//                         text: TextSpan(children: [
//                           TextSpan(
//                             text: "\nThank you for your purchase.",
//                             style: CustomTextStyle.textFormFieldMedium.copyWith(
//                                 fontSize: 14, color: Colors.grey.shade800),
//                           )
//                         ])),
//                     SizedBox(height: 10),
//                     Text(user.displayName),
//                     SizedBox(height: 10),
//                     Text(user.email),
//                     RaisedButton(
//                       onPressed: () async {
//                         print(cart.cartItems[0].quantity);
//                         print(user.uid);

//                         final rxPrefs = RxSharedPreferences.getInstance();
//                         var json_quantity =
//                             await rxPrefs.getString('list_quantity');
//                         var map_quantity = jsonDecode(json_quantity);
//                         var list_quantity = map_quantity.values.toList();

//                         auth.saveOrder(cart.cartItems, user.uid, 'no notes',
//                             list_quantity);
//                         Navigator.of(context).pop();
//                       },
//                       padding: EdgeInsets.only(left: 48, right: 48),
//                       child: Text(
//                         "Save Order",
//                         style: CustomTextStyle.textFormFieldMedium
//                             .copyWith(color: Colors.white),
//                       ),
//                       color: Colors.orangeAccent,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(24))),
//                     )
//                   ],
//                 ),
//               ),
//               flex: 5,
//             )
//           ],
//         ),
//       );
//     },
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(16), topRight: Radius.circular(16))),
//         backgroundColor: Colors.white,
//         elevation: 2);
//   }
// }

// // class thanksyoupage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Container(
// //         height: 400,
// //         decoration: BoxDecoration(
// //             color: Colors.white,
// //             border: Border.all(color: Colors.grey.shade200, width: 2),
// //             borderRadius: BorderRadius.only(
// //                 topRight: Radius.circular(16), topLeft: Radius.circular(16))),
// //         child: Column(
// //           children: <Widget>[
// //             Expanded(
// //               child: Container(
// //                 child: Align(
// //                   alignment: Alignment.bottomCenter,
// //                   child: Image(
// //                     image: AssetImage("assets/images/ic_thank_you.png"),
// //                     width: 300,
// //                   ),
// //                 ),
// //               ),
// //               flex: 5,
// //             ),
// //             Expanded(
// //               child: Container(
// //                 margin: EdgeInsets.only(left: 16, right: 16),
// //                 child: Column(
// //                   children: <Widget>[
// //                     RichText(
// //                         textAlign: TextAlign.center,
// //                         text: TextSpan(children: [
// //                           TextSpan(
// //                             text: "\nThank you for your purchase.",
// //                             style: CustomTextStyle.textFormFieldMedium.copyWith(
// //                                 fontSize: 14, color: Colors.grey.shade800),
// //                           )
// //                         ])),
// //                     SizedBox(height: 10),
// //                     Text(user.displayName),
// //                     SizedBox(height: 10),
// //                     Text(user.email),
// //                     SizedBox(height: 10),
// //                     Text(user.phoneNumber),
// //                     RaisedButton(
// //                       onPressed: () {
// //                         auth.saveOrder(cart.cartItems, user.uid);
// //                         Navigator.of(context).pop();
// //                       },
// //                       padding: EdgeInsets.only(left: 48, right: 48),
// //                       child: Text(
// //                         "Save Order",
// //                         style: CustomTextStyle.textFormFieldMedium
// //                             .copyWith(color: Colors.white),
// //                       ),
// //                       color: Colors.orangeAccent,
// //                       shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.all(Radius.circular(24))),
// //                     )
// //                   ],
// //                 ),
// //               ),
// //               flex: 5,
// //             )
// //           ],
// //         ),
// //       );,
// //     );
// //   }
// // }
