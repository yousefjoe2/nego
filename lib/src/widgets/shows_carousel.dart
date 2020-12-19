import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blocs/shows_bloc.dart';
import '../models/show.dart';

class ShowsCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final showsBloc = Provider.of<ShowsBloc>(context);
    return FutureBuilder<List<Show>>(
        future: showsBloc.getShows(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          return Column(
            children: <Widget>[
              CarouselSlider(
                options: CarouselOptions(height: 150.0),
                items: snapshot.data.map((show) {
                  return Builder(builder: (BuildContext context) {
                    return Container(
                      margin: const EdgeInsets.all(20.0),
                      height: MediaQuery.of(context).size.height * 0.30,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                      child: Container(
                        child: Center(
                          child: SizedBox(
                            child: Text(show.name,
                                style: TextStyle(
                                    color: Color(0xFFE09900),
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          image: DecorationImage(
                            image: NetworkImage(show.image),
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                    );
                  });
                }).toList(),
              ),
            ],
          );
        });
  }
}
