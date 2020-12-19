import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';
import 'package:negpchi/src/pages/myorders.dart';
import 'package:provider/provider.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import '../blocs/auth_bloc.dart';
import '../models/user.dart';
import '../pages/prouducts_details.dart';
import '../routes.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer({Key key}) : super(key: key);
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  var username;
  var user_id;
  final _rxPrefs = RxSharedPreferences.getInstance();

  _loadCounter() async {
    RxSharedPreferences prefs = await RxSharedPreferences.getInstance();
    username = await prefs.getString('user_name') ?? '';
    user_id = await prefs.getString('user_id');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCounter();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBloc>(context);

    Auth.FirebaseAuth _auth = Auth.FirebaseAuth.instance;

    return Drawer(
      child: ListView(
        children: <Widget>[
          _auth.currentUser != null
              ? StreamBuilder<User>(
                  stream: auth.user,
                  builder: (context, snapshot) {
                    return UserAccountsDrawerHeader(
                      // accountName: Text('you'),
                      // accountEmail: Text('you@email.com'),
                      accountName: Text(username ?? ''),
                      accountEmail: Text(_auth.currentUser.email ?? ''),
                      currentAccountPicture: GestureDetector(
                        child: const CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(
                            EvaIcons.person,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      decoration: const BoxDecoration(color: Colors.black54),
                    );
                  })
              : DrawerHeader(
                  decoration: BoxDecoration(
                      color: Color(0xFFE09900),
                      image: DecorationImage(
                        image: AssetImage('assets/images/loqo.png'),
                        fit: BoxFit.fill,
                        scale: 2,
                      )),
                  child: GestureDetector(
                    onTap: () {
                      if (_auth.currentUser != null) {
                        Navigator.pushReplacementNamed(context, Routes.ACCOUNT);
                      } else {
                        Navigator.pushReplacementNamed(context, Routes.LOGIN);
                      }
                    },
                    child: (_auth.currentUser != null)
                        ? Icon(EvaIcons.person)
                        : SizedBox(),
                  ),
                ),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const ListTile(
              title: Text('Home Page'),
              leading: Icon(EvaIcons.home, color: Colors.grey),
            ),
          ),
          InkWell(
            onTap: () {
              if ((_auth.currentUser != null)) {
                Navigator.of(context).pushNamed(Routes.ACCOUNT);
              } else {
                Navigator.of(context).pushNamed(Routes.LOGIN);
              }
            },
            child: ListTile(
              title: (_auth.currentUser != null)
                  ? Text('My Account')
                  : Text('Login'),
              leading: Icon(EvaIcons.person, color: Colors.grey),
            ),
          ),
          _auth.currentUser != null
              ? InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Myorders(user_id)),
                    );
                  },
                  child: const ListTile(
                    title: Text('My Order'),
                    leading: Icon(
                      EvaIcons.shoppingBag,
                      color: Colors.red,
                    ),
                  ),
                )
              : SizedBox(),
          _auth.currentUser != null
              ? InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductDetails()),
                    );
                  },
                  child: Container(),
                )
              : SizedBox(),
          InkWell(
            onTap: () => Navigator.of(context).pushNamed(Routes.ABOUT),
            child: const ListTile(
              title: Text('About'),
              leading: Icon(EvaIcons.infoOutline, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
