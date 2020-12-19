import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'blocs/blocs.dart';
import 'pages/home.dart';
import 'routes.dart';

class GunsStoreApp extends StatefulWidget {
  @override
  _GunsStoreAppState createState() => _GunsStoreAppState();
}

class _GunsStoreAppState extends State<GunsStoreApp> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final navigatorKey = GlobalKey<NavigatorState>();

    return MultiProvider(
      providers: [
        Provider(
          create: (_) => AuthBloc(),
          dispose: (_, authBloc) => authBloc.dispose(),
        ),
        Provider(
          create: (_) => CategoriesBloc(),
          dispose: (_, categoryBloc) => categoryBloc.dispose(),
        ),
        Provider(
          create: (_) => ProductBloc(),
          dispose: (_, productBloc) => productBloc.dispose(),
        ),
        Provider(
          create: (_) => CartBloc(),
          dispose: (_, cartBloc) => cartBloc.dispose(),
        ),
        Provider(
          create: (_) => ShowsBloc(),
          dispose: (_, showsBloc) => showsBloc.dispose(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Routes.routes,
        theme: ThemeData(
          primaryColor: Color(0xFF1B1B1B),
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        ),
        home: HomePage(),
      ),
    );
  }
}
