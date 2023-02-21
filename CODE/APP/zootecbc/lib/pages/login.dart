import 'dart:async';

import 'package:zootecbc/components/fade_animation.dart';
import 'package:zootecbc/constants/colors.dart';
import 'package:zootecbc/constants/globals.dart';
import 'package:zootecbc/helpers/helpers.dart';
import 'package:zootecbc/pages/forgot_password.dart';
import 'package:zootecbc/pages/home_admin.dart';

import 'package:zootecbc/providers/app.dart';
import 'package:zootecbc/services/web_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  String messageAfter;
  Login({Key? key, this.messageAfter = ""}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

/*GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  //clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>['email'],
);*/

class _LoginState extends State<Login> {
  bool passwordVisible = true;
  final cEmail = TextEditingController();
  final cPass = TextEditingController();
  final formKey = new GlobalKey<FormState>();
  //late StreamSubscription currentStream;
  bool gmailPress = false;
  bool facebookPress = false;

  bool pharmacyRegister = false;
  bool idRequiredDoctor = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // currentStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final passwordField = TextFormField(
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp('[ ]')),
        ],
        validator: (val) {
          return validatePassword1(val ?? "", context);
        },
        controller: cPass,
        obscureText: passwordVisible,
        style: TextStyle(fontSize: 18.0),
        //initialValue: Environment.localPassword(),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Su contraseña",
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          fillColor: Colors.white,
          filled: true,
          prefixIcon: Icon(
            FontAwesomeIcons.lock,
            size: 20,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              passwordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                passwordVisible = !passwordVisible;
              });
            },
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300, width: 2.0),
              borderRadius: BorderRadius.circular(10.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300, width: 2.0),
              borderRadius: BorderRadius.circular(10.0)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300, width: 2.0),
              borderRadius: BorderRadius.circular(10.0)),
        ));

    final emailField = TextFormField(
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        validator: (val) {
          return validateEmail(val ?? "", context);
        },
        controller: cEmail,
        style: TextStyle(fontSize: 18.0),
        //initialValue: Environment.localPassword(),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          fillColor: Colors.white,
          filled: true,
          prefixIcon: Icon(
            FontAwesomeIcons.envelope,
            size: 20,
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300, width: 2.0),
              borderRadius: BorderRadius.circular(10.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300, width: 2.0),
              borderRadius: BorderRadius.circular(10.0)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300, width: 2.0),
              borderRadius: BorderRadius.circular(10.0)),
        ));

    Widget btnLogin = ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 2,
          primary: CustomColors.secondary,
          shape: StadiumBorder()),
      onPressed: () {
        processSignInEmailPassword();
      },
      child: Container(
        width: double.infinity,
        height: 35.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Ingresar",
              style: TextStyle(color: Colors.white, fontSize: 14.0),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
        backgroundColor: CustomColors.primary,
        body: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 40.0, right: 40.0, top: 20, bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FadeAnimation(
                            1,
                            Image.asset('assets/images/logo.png',
                                width: MediaQuery.of(context).size.width),
                          ),
                          SizedBox(height: 50),
                          FadeAnimation(
                            1,
                            Container(
                              constraints: BoxConstraints(),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: emailField,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: passwordField,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: btnLogin,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            axis: AxisAnimation.y,
                            negative: true,
                          ),
                          SizedBox(height: 30),
                          FadeAnimation(
                            1,
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: ForgotPassword(),
                                        type: PageTransitionType.slideInRight,
                                        duration: Duration(milliseconds: 250)));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("¿Olvidaste tu contraseña?",
                                    style: TextStyle(
                                        color: CustomColors.secondary,
                                        fontSize: 15)),
                              ),
                            ),
                            axis: AxisAnimation.y,
                            negative: true,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  processSignInEmailPassword() async {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();

      simpleLoading(context, (BuildContext loadingContext) {
        final provider = Provider.of<AppProvider>(context, listen: false);
        WebService(context).signIn(cEmail.text, cPass.text).then((user) async {
          await provider.setUser(user);

          initProcess(context, user.token ?? "", () {
            Navigator.pop(loadingContext);

            Navigator.pushAndRemoveUntil(
                context,
                PageTransition(
                    child: HomeAdmin(),
                    type: PageTransitionType.slideInUp,
                    duration: Duration(milliseconds: 250)),
                (Route<dynamic> route) => false);
          });
        }).catchError((e) {
          print(e);
          Navigator.pop(loadingContext);
          showErrorsDialog(context, e);
        });
      });
    }
  }
}
