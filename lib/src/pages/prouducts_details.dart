import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/appbar.dart';

class ProductDetails extends StatefulWidget {
  final String productId;

  const ProductDetails({Key key, this.productId}) : super(key: key);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

Product product;

class _ProductDetailsState extends State<ProductDetails> {
  TextEditingController _email;
  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Container(
              height: 270.0,
              child: GridTile(
                child: Container(
                  width: double.infinity,
                  child: Image.network(
                      'https://cdn.pixabay.com/photo/2014/09/30/22/49/guns-467710_960_720.jpg'),
                ),
                footer: Container(
                  color: Colors.white,
                  child: ListTile(
                    title: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            product?.title?.toString() ?? 'Hybrid Rocket WNS',
                            style: Theme.of(context).textTheme.subtitle1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(product?.price?.toString() ?? '\$999.00'),
                        ),
                        Expanded(
                          child: FavoriteButton(
                            iconColor: Colors.red,
                            valueChanged: (_isFavorite) {
                              print('Is Favorite : $_isFavorite');
                            },
                          ),
                        ),
                        Expanded(
                          child: Icon(
                            Icons.shopping_basket,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
                child: Text(product?.des?.toString() ??
                    'Damage types. Melee: Cavalry Saber. Tools: Knife. Two Handed: Mosin-Nagant M1891 Bayonet, Nitro Express Rifle .')),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(child: Text('review')),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.grey.withOpacity(0.3),
              elevation: 0.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Your Review",
                    icon: Icon(Icons.rate_review),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.grey.withOpacity(0.3),
              elevation: 0.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Your Name",
                    icon: Icon(Icons.person),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.grey.withOpacity(0.3),
              elevation: 0.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Email",
                    icon: Icon(Icons.alternate_email),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: FlatButton(
              onPressed: () {},
              child: Text('send'),
            ),
          )
        ],
      ),
    );
  }
}
