import 'dart:async';
import 'package:zootecbc/components/fade_animation.dart';
import 'package:zootecbc/constants/colors.dart';
import 'package:zootecbc/constants/globals.dart';
import 'package:zootecbc/helpers/helpers.dart';
import 'package:zootecbc/models/app_preferences.dart';
import 'package:zootecbc/models/user.dart';
import 'package:zootecbc/pages/home_admin.dart';
import 'package:zootecbc/pages/login.dart';
import 'package:zootecbc/providers/app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  int lagSeconds = 2;

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SystemChrome.setEnabledSystemUIOverlays([]);
      _initProcess();
    });
  }

  _initProcess() async {
    final provider = Provider.of<AppProvider>(context, listen: false);

    Timer(Duration(seconds: lagSeconds), () async {
      try {
        UserModel user = await AppPreferences().getUser();
        if (user.id == null) {
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                  child: Login(),
                  type: PageTransitionType.slideInUp,
                  duration: Duration(milliseconds: 250)),
              (Route<dynamic> route) => false);
        } else {
          await provider.setUser(user);
          initProcess(context, user.token ?? "", () {
            Navigator.pushAndRemoveUntil(
                context,
                PageTransition(
                    child: HomeAdmin(),
                    type: PageTransitionType.slideInUp,
                    duration: Duration(milliseconds: 250)),
                (Route<dynamic> route) => false);
          });
        }
      } catch (e) {
        print("error al cargar");
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.primary,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: FadeAnimation(
                      1,
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: MediaQuery.of(context).size.width,
                          filterQuality: FilterQuality.high,
                        ),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                JumpingDotsProgressIndicator(
                  fontSize: 50.0,
                  color: CustomColors.secondary,
                  numberOfDots: 4,
                  milliseconds: 150,
                ),
              ],
            ),
          ),
        ));
  }
}
