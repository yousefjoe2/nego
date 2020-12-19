import 'package:animated_card/animated_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blocs/category_bloc.dart';
import '../models/category.dart';

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    var categoriesBloc = Provider.of<CategoriesBloc>(context);
    return AnimatedCard(
      direction: AnimatedCardDirection.top,
      initDelay: Duration(milliseconds: 1),
      duration: Duration(seconds: 2),
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        width: double.infinity,
        height: height / 5,
        child: FutureBuilder<List<Category>>(
          future: categoriesBloc.getcategories(),
          initialData: [],
          builder: (context, snapshot) {
            if (snapshot?.data == null || snapshot.data?.length == 0)
              return Container();
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Text(
                      snapshot.data[index].name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25)),
                          child: Image.network(
                            snapshot.data[index].image,
                            fit: BoxFit.fill,
                            scale: 3,
                          )),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
