import 'package:flutter/material.dart';
import 'package:negpchi/src/blocs/auth_bloc.dart';
import 'package:video_player/video_player.dart';

import '../widgets/appbar.dart';
import '../widgets/drawer.dart';
import '../widgets/shows_carousel.dart';
import '../widgets/video_player.dart';
import 'categories.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  islogged() async {
    bool islogged = await authBloc.isLoggedIn();

    print("##################################");
    print(islogged);
    print("##################################");
  }

  @override
  void initState() {
    super.initState();
    islogged();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFF3B3B3B),
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: Center(
        child: Column(
          children: <Widget>[
            //video player
            MyVideoPlayer(
              videoPlayerController: VideoPlayerController.asset(
                'assets/videos/guns.mp4',
              ),
              looping: true,
            ),
            // SizedBox(height: 10),
            // ShowsCarousel(),
            SizedBox(height: 10),
            //categories
            Expanded(
              child: SizedBox(
                height: height * 5 / 3,
                width: height / 2.3,
                child: CategoriesSlider(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: Color(0xFF1B1B1B),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFE09900),
                blurRadius: .85,
                spreadRadius: 1.0,
                offset: Offset(1.0, 1.0),
              )
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            )),
        padding: EdgeInsets.all(height / 80),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'info@negochi-kw.com',
              style: TextStyle(
                color: Color(0xFFE1E1E1),
              ),
            ),
            Icon(
              Icons.email,
              color: Colors.white,
            ),
            Text(
              '50879797',
              style: TextStyle(
                color: Color(0xFFE1E1E1),
              ),
            ),
            Icon(
              Icons.phone,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
