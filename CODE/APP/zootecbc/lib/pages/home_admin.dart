import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:provider/provider.dart';
import 'package:zootecbc/components/fade_animation.dart';
import 'package:zootecbc/constants/colors.dart';
import 'package:zootecbc/models/user.dart';
import 'package:zootecbc/pages/add_animal.dart';
import 'package:zootecbc/pages/animals.dart';
import 'package:zootecbc/pages/profile.dart';
import 'package:zootecbc/pages/users.dart';
import 'package:zootecbc/providers/app.dart';

import '../helpers/helpers.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: true);
    UserModel user = provider.user;
    return Scaffold(
        backgroundColor: CustomColors.primary,
        body: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FadeAnimation(
                            1,
                            Image.asset('assets/images/logo.png',
                                width: MediaQuery.of(context).size.width),
                          ),
                          SizedBox(height: 25),
                        ],
                      ),
                      Text("Hola",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 19,
                              color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2),
                      Text(formatFirstUpper(user.name ?? ""),
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 19,
                              color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 2,
                            primary: CustomColors.secondary,
                            shape: StadiumBorder()),
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: AddAnimal(() {}),
                                  type: PageTransitionType.slideInUp,
                                  duration: Duration(milliseconds: 250)));
                        },
                        child: Container(
                          width: double.infinity,
                          height: 35.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Nueva Captura",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 2,
                            primary: CustomColors.secondary,
                            shape: StadiumBorder()),
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: Animals(),
                                  type: PageTransitionType.slideInUp,
                                  duration: Duration(milliseconds: 250)));
                        },
                        child: Container(
                          width: double.infinity,
                          height: 35.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Animales",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      (user.roles != null &&
                                  user.roles.length > 0 &&
                                  user.roles[0].name == "super_admin" ||
                              user.roles[0].name == "admin")
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 2,
                                  primary: CustomColors.secondary,
                                  shape: StadiumBorder()),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: Users(),
                                        type: PageTransitionType.slideInUp,
                                        duration: Duration(milliseconds: 250)));
                              },
                              child: Container(
                                width: double.infinity,
                                height: 35.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Empleados",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14.0),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 2,
                            primary: CustomColors.secondary,
                            shape: StadiumBorder()),
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: Profile(),
                                  type: PageTransitionType.slideInUp,
                                  duration: Duration(milliseconds: 250)));
                        },
                        child: Container(
                          width: double.infinity,
                          height: 35.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Mis datos",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 2,
                            primary: CustomColors.secondary,
                            shape: StadiumBorder()),
                        onPressed: () {
                          logout(context);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 35.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Cerrar Sesión",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.0),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
