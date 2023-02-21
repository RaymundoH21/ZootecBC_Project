import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zootecbc/components/custom_dialog.dart';
import 'package:zootecbc/constants/colors.dart';
import 'package:zootecbc/models/asset.dart';
import 'package:zootecbc/models/role.dart';
import 'package:zootecbc/models/user.dart';
import 'package:zootecbc/pages/login.dart';
import 'package:zootecbc/providers/app.dart';

import '../constants/globals.dart';

initProcess(BuildContext context, String token, Function callback) async {
  final provider = Provider.of<AppProvider>(context, listen: false);
  Future.wait([]).then((List responses) async {
    // provider.setUser(responses[0]);
    callback();
  }).catchError((err) {
    print("error al cargar la información inicial");
    print(err);

    simpleLoading(context, (BuildContext loadingContext) async {
      try {
        UserModel user = provider.user;

        UserModel userTmp = UserModel(roles: []);
        userTmp.id = null;
        await provider.setUser(userTmp);

        Navigator.pop(loadingContext);

        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                  child: Login(),
                  type: PageTransitionType.slideInUp,
                  duration: Duration(milliseconds: 250)),
              (Route<dynamic> route) => false);
        });
      } catch (e) {
        print(e);

        Navigator.pop(loadingContext);

        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                  child: Login(),
                  type: PageTransitionType.slideInUp,
                  duration: Duration(milliseconds: 250)),
              (Route<dynamic> route) => false);
        });
      }
    });
  });
}

simpleLoading(BuildContext context, Function callback, {String text = ""}) {
  try {
    FocusScope.of(context).requestFocus(FocusNode());
  } catch (e) {}
  BuildContext contextLoadingDialog = context;
  late StateSetter _setState;
  showDialog<void>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext contextd) {
      contextLoadingDialog = contextd;
      return StatefulBuilder(builder: (context, setState) {
        _setState = setState;
        return WillPopScope(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                      visible: text != "",
                      child: Flexible(
                          child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(text,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            )),
                      ))),
                  Container(
                    color: Colors.transparent,
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            CustomColors.primary)),
                  )
                ],
              ),
            ),
            onWillPop: () async {
              return false;
            });
      });
    },
  );
  callback(contextLoadingDialog);
}

showErrorsDialog(BuildContext context, dynamic errors,
    {dynamic callback = null}) async {
  print(errors);
  if (errors is List<dynamic> && errors.length <= 0) return;
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (contextDialog) {
        return CustomDialog(
          "",
          errors.join(".\n"),
          "Aceptar",
          () {
            if (callback != null && callback is Function) callback();
          },
          useBtnCancel: false,
          image: '',
        );
      });
}

bool checkEmpty(data) {
  if (data == null || data == "") {
    return false;
  } else {
    return true;
  }
}

EdgeInsets getDialogInsetPaddin(BuildContext context,
    {dynamic customEdge = null}) {
  return kIsWeb
      ? EdgeInsets.symmetric(
          horizontal: (MediaQuery.of(context).size.width > 1000)
              ? MediaQuery.of(context).size.width * .35
              : 30)
      : (customEdge != null && customEdge is EdgeInsets)
          ? customEdge
          : EdgeInsets.symmetric(horizontal: 35, vertical: 24);
}

dynamic validatePassword1(String value, BuildContext context) {
  if (value.isEmpty) // The form is empty
    return "Ingrese la contraseña";
  return null;
}

dynamic validateEmail(String value, BuildContext context) {
  if (value.isEmpty) {
    // The form is empty
    return "Este campo es requerido";
  }
  // This is just a regular expression for email addresses
  String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
      "\\@" +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
      "(" +
      "\\." +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
      ")+";
  RegExp regExp = new RegExp(p);

  if (regExp.hasMatch(value)) {
    // So, the email is valid
    return null;
  } else {
    return "El correo electrónico no es valido";
  }
}

List<dynamic> checkErrors(dynamic responseData) {
  try {
    dynamic json = jsonDecode(responseData.toString());
    if (json.containsKey("errors")) {
      return json["errors"];
    } else {
      return ['Ocurrió un error desconocido, intenté de nuevo.'];
    }
  } catch (e) {
    print(e);
    return ['Ocurrió un error desconocido, intenté de nuevo.'];
  }
}

String getImageUrl(AssetModel asset) {
  if (asset.type == "image_url") {
    return asset.name ?? "";
  } else if (asset.type == "image") {
    if ((asset.name ?? "") == "") return "";
    return imagesUrl + (asset.name ?? "");
  } else {
    return "";
  }
}

String formatFirstUpper(String value, {bool cutName = false}) {
  try {
    String name = "";

    if (value == null) return "";
    value = value.toLowerCase();
    if (value != null) {
      name = value.toLowerCase().split(' ').map((word) {
        if (word.trim() != "") {
          return word[0].toUpperCase() + word.substring(1);
        } else {
          return "";
        }
      }).join(' ');
    } else {
      return "";
    }

    final pattern = RegExp('\\s+');
    name = name.replaceAll(pattern, " ");

    if (!cutName) return name;

    var nameParts = name.split(' ');
    print("nameParts:" + nameParts.toString());
    if (nameParts.length >= 4) {
      name = nameParts[0] + " " + nameParts[2][0] + ".";
    } else if (nameParts.length == 3) {
      name = nameParts[0] + " " + nameParts[2][0] + ".";
    } else if (nameParts.length == 2) {
      name = nameParts[0] + " " + nameParts[1][0] + ".";
    } else if (nameParts.length == 1) {
      name = nameParts[0];
    }
    return name;
  } catch (e) {
    return value;
  }
}

dynamic requiredField(dynamic value, BuildContext context) {
  if (value.isEmpty) {
    // The form is empty
    return "Este campo es requerido";
  } else {
    return null;
  }
}

dynamic validateRepeatPassword(
    String pass, String passRepeat, BuildContext context) {
  if (pass.isEmpty) // The form is empty
    return "El campo contraseña es necesario";
  if (passRepeat.isEmpty) return "Es campo repetir contraseña es necesario";
  if (pass != passRepeat) return "Las contraseñas no coinciden";
  return null;
}

String getDateTimeFromStringFormat(String dateS) {
  if (dateS.trim() == "") return "";
  DateTime date = DateTime.parse(dateS).toUtc();
  DateTime dateLocal = date.toLocal();

  return DateFormat('dd-MMMM-yyyy hh:mm a', "es_ES").format(dateLocal);
}

String getRoleName(RoleModel rol) {
  switch (rol.name) {
    case "super_admin":
      return "Administrador";
      break;
    case "admin":
      return "administrador";
      break;
    case "keeper":
      return "Cuidador";
      break;
    default:
      return "";
  }
}

logout(BuildContext context, {bool direct = false, String messageAfter = ""}) {
  BuildContext mainContext = context;
  final provider = Provider.of<AppProvider>(context, listen: false);
  final UserModel user = provider.user;

  /*GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    //clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
    scopes: <String>['email'],
  );*/

  if (direct) {
    simpleLoading(context, (BuildContext loadingContext) async {
      try {
        UserModel user = provider.user;

        UserModel userTmp = UserModel(roles: []);
        userTmp.id = null;
        userTmp.name = null;

        userTmp.picture = null;
        userTmp.roles = [];

        userTmp.status = null;
        userTmp.token = null;
        userTmp.created_at = null;
        userTmp.updated_at = null;

        await provider.setUser(userTmp);

        Navigator.pop(loadingContext);

        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                  child: Login(messageAfter: messageAfter),
                  type: PageTransitionType.slideInUp,
                  duration: Duration(milliseconds: 250)),
              (Route<dynamic> route) => false);
        });
      } catch (e) {
        print(e);

        Navigator.pop(loadingContext);
        showErrorsDialog(
            context, ["Ocurrió un error desconocido, intente de nuevo."]);
      }
    });
  } else {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (contextDialog) {
          return CustomDialog(
            "",
            "¿Deseas cerrar la sesión?",
            "Aceptar",
            () {
              simpleLoading(context, (BuildContext loadingContext) async {
                try {
                  UserModel user = provider.user;

                  Navigator.pop(loadingContext);

                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        PageTransition(
                            child: Login(messageAfter: messageAfter),
                            type: PageTransitionType.slideInUp,
                            duration: Duration(milliseconds: 250)),
                        (Route<dynamic> route) => false);

                    UserModel userTmp = UserModel(roles: []);
                    userTmp.id = null;
                    userTmp.name = null;

                    userTmp.picture = null;
                    userTmp.roles = [];
                    userTmp.status = null;
                    userTmp.token = null;
                    userTmp.created_at = null;
                    userTmp.updated_at = null;

                    provider.setUser(userTmp);
                  });
                } catch (e) {
                  print(e);

                  Navigator.pop(loadingContext);
                  showErrorsDialog(context,
                      ["Ocurrió un error desconocido, intente de nuevo."]);
                }
              });
            },
            useBtnCancel: true,
            image: '',
          );
        });
  }
}

String getStatusAnimal(String status) {
  if (status == "in_adoption") {
    return "En instalaciones";
  } else if (status == "adopted") {
    return "Adoptado";
  } else if (status == "reclaimed") {
    return "Reclamado por el dueño";
  } else if (status == "sacrificed") {
    return "Sacrificado";
  } else {
    return "";
  }
}
