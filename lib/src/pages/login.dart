import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

import '../blocs/auth_bloc.dart';
import '../routes.dart';
import '../widgets/alert.dart';

class Login extends StatefulWidget {
  @override
  _SignState createState() => _SignState();
}

class _SignState extends State<Login> {
  StreamSubscription _userSubscription;
  StreamSubscription _errorSubscription;
  bool isLoading = false;
  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    _userSubscription = authBloc.user.listen((user) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, Routes.HOME);
      }
    });
    _errorSubscription = authBloc.errorMessage.listen((errorMessage) {
      if (errorMessage != '') {
        AppAlerts.showAlertDialog(context, errorMessage)
            .then((_) => authBloc.clearErrorMessage());
      }
    });
    authBloc.isLoading.listen((event) {
      if (mounted) setState(() => isLoading = event);
    });
    super.initState();
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    _errorSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(context) {
    final authBloc = Provider.of<AuthBloc>(context);
    final logo = CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 48.0,
      child: Image.asset('assets/images/loqo.png'),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: StreamBuilder<bool>(
          stream: authBloc.isValid,
          builder: (context, snapshot) {
            return RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onPressed: ()async{
                await authBloc.loginEmailAndPassword(context);},
              padding: EdgeInsets.all(12),
              color: Color(0xFFE09900),
              child:
                  Text('تسجيل الدخول', style: TextStyle(color: Colors.white)),
            );
          }),
    );
    final sginUp = FlatButton(
      child: Text(
        'تسجيل جديد',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () => Navigator.pushReplacementNamed(context, Routes.SIGNUP),
    );

    return LoadingOverlay(
      isLoading: isLoading,
      progressIndicator:
          CircularProgressIndicator(backgroundColor: Color(0xFFE09900)),
      child: Scaffold(
        backgroundColor: Color(0xFF332E02),
        body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              logo,
              SizedBox(height: 48.0),
              Center(
                child: Text(
                  'تسجيل الدخول',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 25.0),
              StreamBuilder<String>(
                  stream: authBloc.email,
                  builder: (context, snapshot) {
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'البريد الإلكتروني',
                          hintStyle: TextStyle(color: Colors.white),
                          errorText: snapshot.error,
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.white),
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                          ),
                        ),
                        onChanged: authBloc.changeEmail,
                      ),
                    );
                  }),
              SizedBox(height: 8.0),
              Directionality(
                textDirection: TextDirection.rtl,
                child: StreamBuilder<String>(
                    stream: authBloc.password,
                    builder: (context, snapshot) {
                      return TextFormField(
                        style: TextStyle(color: Colors.white),
                        autofocus: false,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'كلمة المرور',
                          hintStyle: TextStyle(color: Colors.white),
                          errorText: snapshot.error,
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(32.0)),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                          ),
                        ),
                        onChanged: authBloc.changePassword,
                      );
                    }),
              ),
              SizedBox(height: 24.0),
              loginButton,
              sginUp
            ],
          ),
        ),
      ),
    );
  }
}

// class loginButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 16.0),
//       child: StreamBuilder<bool>(
//           stream: authBloc.isValid,
//           builder: (context, snapshot) {
//             return RaisedButton(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(24),
//               ),
//               onPressed: () async {
//                 print("start login button");
//                 await authBloc.loginEmailAndPassword(context);
//               },
//               padding: EdgeInsets.all(12),
//               color: Color(0xFFE09900),
//               child:
//                   Text('تسجيل الدخول', style: TextStyle(color: Colors.white)),
//             );
//           }),
//     );
//   }
// }
