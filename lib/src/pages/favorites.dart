import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blocs/auth_bloc.dart';
import '../blocs/cart_bloc.dart';
import '../models/product.dart';
import '../routes.dart';
import '../widgets/appbar.dart';
import '../widgets/drawer.dart';

class Favorites extends StatefulWidget {
  const Favorites({
    Key key,
  }) : super(key: key);
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  _FavoritesState();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartBloc>(context);
    final authBloc = Provider.of<AuthBloc>(context);

    return Scaffold(
      backgroundColor: Color(0xFF3B3B3B),
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: StreamBuilder<List<Product>>(
        stream: authBloc.getFavorites(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: TextStyle(color: Colors.yellow),
              ),
            );

          if (snapshot?.data?.length == 0)
            return Center(
              child: Text(
                'لا توجد منتجات تتوافق مع اختيارك.',
                style: TextStyle(color: Colors.yellow),
              ),
            );
          return GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: snapshot?.data?.length ?? 0,
            itemBuilder: (context, index) {
              if (snapshot.hasData && snapshot.data.length == 0)
                return Center(
                  child: Text(
                    'لا توجد منتجات تتوافق مع اختيارك.',
                    style: TextStyle(color: Colors.yellow),
                  ),
                );
              return _buildproductCard(snapshot.data[index], cart, context);
            },
          );
        },
      ),
    );
  }

  Widget _buildproductCard(
      Product product, CartBloc cart, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed(Routes.PRODUCT_DETAILS, arguments: product),
      child: Container(
        height: 150,
        margin: EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width / 2.5,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFE09900), width: 1),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          image: DecorationImage(
            image: NetworkImage(
              product?.image ??
                  'https://g7y6h3a7.rocketcdn.me/wp-content/uploads/2019/12/placeholder.png',
              // scale: 2,
            ),
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          product.title,
                          style: TextStyle(color: Colors.white),
                        ),
                      ))),
            ),
          ],
        ),
      ),
    );
  }
}
