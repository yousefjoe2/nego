import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blocs/category_bloc.dart';
import '../models/category.dart';
import '../routes.dart';

class CategoriesSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    var categoriesBloc = Provider.of<CategoriesBloc>(context);
    return FutureBuilder<List<Category>>(
        future: categoriesBloc.getcategories(),
        builder: (context, snapshot) {
          if (snapshot.data == null) return Center();
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: snapshot?.data?.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(Routes.SUBCATEGORIES,
                      arguments: snapshot?.data[index]?.id);
                },
                child: Container(
                    margin: EdgeInsets.only(bottom: height / 25),
                    height: height / 3,
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: Color(0xFFE09900),
                        width: 3,
                      ),
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.black26],
                      ),
                      image: DecorationImage(
                        image: NetworkImage(snapshot?.data[index]?.image ??
                            'http://kwu.hashtaj.com/wp-content/uploads/2020/08/1.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(snapshot?.data[index]?.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23.0,
                                )),
                          ),
                        ),
                      ],
                    )),
              );
            },
          );
        });
  }
}
