import 'package:badges/badges.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_share/flutter_share.dart';

import '../blocs/auth_bloc.dart';
import '../blocs/cart_bloc.dart';
import '../routes.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  Future<void> share(dynamic link, String title) async {
    await FlutterShare.share(
        title: 'Negochi',
        text: 'title',
        linkUrl: '$link',
        chooserTitle: 'Where you want to share');
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartBloc>(context);
    final authBloc = Provider.of<AuthBloc>(context);
    FirebaseAuth auth = FirebaseAuth.instance;

    return AppBar(
      elevation: 0.0,
      title: Image.asset(
        'assets/images/loqo.png',
        fit: BoxFit.scaleDown,
        scale: 8,
      ),
      actions: <Widget>[

        auth.currentUser != null
            ? Badge(
                animationType: BadgeAnimationType.slide,
                badgeContent: StreamBuilder<double>(
                    stream: cart.quentity,
                    builder: (context, snapshot) {
                      return Text('${snapshot?.data?.floor() ?? 0}',
                          style: TextStyle(color: Colors.white, fontSize: 10));
                    }),
                position: BadgePosition.topLeft(top: 2, left: 4),
                child: IconButton(
                  icon: Icon(
                    EvaIcons.shoppingCart,
                    color: Color(0xFFE09900),
                  ),
                  onPressed: () => auth.currentUser != null
                      ? Navigator.pushNamed(context, Routes.CART)
                      : null,
                ),
              )
            : Container(),
        auth.currentUser != null
            ? PopupMenuButton(
                onSelected: (value) {
                  print(value);
                  switch (value) {
                    case 'about':
                      return Navigator.pushNamed(context, Routes.ABOUT);
                      break;
                    case 'account':
                      if (auth.currentUser == null ?? false)
                        return Navigator.pushReplacementNamed(
                            context, Routes.ACCOUNT);
                      return Navigator.pushReplacementNamed(
                          context, Routes.LOGIN);
                      break;
                    default:
                      return Navigator.pushNamed(context, Routes.HOME);
                  }
                },
                itemBuilder: (context) {
                  return <PopupMenuEntry>[
                    PopupMenuItem(
                      value: 'rating',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            EvaIcons.star,
                            color: Color(0xFF000000),
                          ),
                          Text(
                            'التقييم',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: Color(0xFF000000),
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      child: GestureDetector(
                        onTap: () {
                          share('https://www.facebook.com/', 'Negochi');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              EvaIcons.share,
                              color: Color(0xFF000000),
                            ),
                            Text(
                              'المشاركة',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                color: Color(0xFF000000),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'about',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            EvaIcons.infoOutline,
                            color: Color(0xFF000000),
                          ),
                          Text(
                            'حول',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: Color(0xFF000000),
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'logout',
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed(Routes.LOGIN);
                          authBloc.logout();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              EvaIcons.logOut,
                              color: Color(0xFF000000),
                            ),
                            Text(
                              'تسجيل خروج',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                color: Color(0xFF000000),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
              )
            : Container(),
      ],
    );
  }
}
