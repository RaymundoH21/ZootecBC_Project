import 'dart:io';
import 'dart:typed_data';

import 'package:zootecbc/components/custom_dialog.dart';
import 'package:zootecbc/components/select_picture_dialog_wec.dart';
import 'package:zootecbc/constants/colors.dart';
import 'package:zootecbc/constants/globals.dart';
import 'package:zootecbc/helpers/helpers.dart';
import 'package:zootecbc/models/asset.dart';
import 'package:zootecbc/models/user.dart';

import 'package:zootecbc/pages/set_change_password.dart';
import 'package:zootecbc/providers/app.dart';
import 'package:zootecbc/services/web_service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:snack/snack.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final cEmail = TextEditingController();
  final cName = TextEditingController();
  final cTel = TextEditingController();
  final cBirdate = TextEditingController();

  final formKey = new GlobalKey<FormState>();

  dynamic imageSelected = null;
  dynamic birdate = null;
  String codeTel = "";
  @override
  void initState() {
    super.initState();

    final provider = Provider.of<AppProvider>(context, listen: false);

    cEmail.text = provider.user.email ?? "";

    cName.text = formatFirstUpper(provider.user.name ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: true);
    UserModel user = provider.user;

    final nameField = TextFormField(
      autofocus: false,
      autocorrect: false,
      controller: cName,
      keyboardType: TextInputType.text,
      validator: (val) {
        return requiredField(val ?? "", context);
      },
      obscureText: false,
      style: TextStyle(fontSize: 18.0),
      //initialValue: Environment.localUsername(),
      decoration: InputDecoration(
        labelText: 'Nombre',
        labelStyle: TextStyle(color: CustomColors.secondary),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CustomColors.secondary),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CustomColors.secondary),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: CustomColors.secondary),
        ),
      ),
    );

    final emailField = TextFormField(
      autofocus: false,
      autocorrect: false,
      controller: cEmail,
      keyboardType: TextInputType.emailAddress,
      validator: (val) {
        return validateEmail(val ?? "", context);
      },
      obscureText: false,
      style: TextStyle(fontSize: 18.0),
      //initialValue: Environment.localUsername(),
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: CustomColors.secondary),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CustomColors.secondary),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CustomColors.secondary),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: CustomColors.secondary),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              )),
          elevation: 0,
          centerTitle: true,
          leading: new IconButton(
            icon: new Icon(
              FontAwesomeIcons.arrowLeft,
              size: 20,
              color: CustomColors.secondary,
            ),
            onPressed: () => Navigator.of(context).pop(),
          )),
      backgroundColor: CustomColors.primary,
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            Center(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 25, bottom: 10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: 160,
                        height: 160,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Visibility(
                                visible: imageSelected == null,
                                child: Container(
                                  height: 160,
                                  width: 160,
                                  decoration: new BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: new BorderRadius.all(
                                        Radius.circular(10.0)),
                                  ),
                                  child: (user.picture != null &&
                                          user.picture != "")
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: FadeInImage.assetNetwork(
                                            placeholder:
                                                "assets/images/loading-image1.gif",
                                            image: getImageUrl(user.picture!),
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Container(
                                          decoration: new BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      Radius.circular(45.0))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Image.asset(
                                              "assets/images/avatar.png",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                                child: (imageSelected != null)
                                    ? Container(
                                        width: 160,
                                        height: 160,
                                        decoration: BoxDecoration(
                                          borderRadius: new BorderRadius.all(
                                              Radius.circular(10.0)),
                                          image: (imageSelected is Uint8List)
                                              ? DecorationImage(
                                                  image: MemoryImage(
                                                      imageSelected),
                                                  fit: BoxFit.cover,
                                                )
                                              : DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image:
                                                      FileImage(imageSelected)),
                                        ),
                                      )
                                    : Container()),
                            Positioned.fill(
                                child: InkWell(
                              onTap: () {
                                showTakePicture();
                              },
                              child: Container(
                                width: 160,
                                height: 160,
                                decoration: new BoxDecoration(
                                    color: (imageSelected != null)
                                        ? Colors.transparent
                                        : Colors.black.withAlpha(80),
                                    borderRadius: new BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      FontAwesomeIcons.camera,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: nameField,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: emailField,
                      ),

                      //----------------------------new

                      //new
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 2,
                              primary: CustomColors.secondary,
                              shape: StadiumBorder()),
                          onPressed: () {
                            processUpdate();
                          },
                          child: Container(
                            width: double.infinity,
                            height: 35.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Guardar",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 2,
                                primary: CustomColors.secondary,
                                shape: StadiumBorder()),
                            onPressed: () {
                              simpleLoading(context,
                                  (BuildContext contextLoading) {
                                WebService(context)
                                    .getHasPassword(provider.user.token ?? "")
                                    .then((value) {
                                  Navigator.pop(contextLoading);
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: setChangePassword(value),
                                          type: PageTransitionType.slideInUp,
                                          duration:
                                              Duration(milliseconds: 250)));
                                }).catchError((e) {
                                  Navigator.pop(contextLoading);
                                  showErrorsDialog(context, e);
                                });
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.lock,
                                      color: Colors.white, size: 15),
                                  Flexible(
                                    child: Text(
                                        "Establecer o cambiar contraseña",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0),
                                        textAlign: TextAlign.center),
                                  ),
                                ],
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return CustomColors.primary;
  }

  showTakePicture() async {
    await showDialog(
        context: context,
        builder: (contextDialog) {
          return SelectPictureDialogWec(
            "Seleccionar imagen",
            (contextDialogd, image) {
              Navigator.pop(contextDialog);
              callbackShowTakePicture(contextDialogd, image);
            },
            useBtnCancel: true,
          );
        });
  }

  Future callbackShowTakePicture(contextDialog, image) async {
    if (image == null) return;
    try {
      final XFile? imageFile = await ImagePicker().pickImage(
          source:
              (image == "camera") ? ImageSource.camera : ImageSource.gallery);
      if (imageFile != null) {
        File file = await File(imageFile.path);
        setState(() {
          this.imageSelected = file;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  processUpdate() async {
    final form = formKey.currentState;

    if (form!.validate()) {
      form.save();
      simpleLoading(context, (BuildContext loadingContext) async {
        final provider = Provider.of<AppProvider>(context, listen: false);
        try {
          dynamic assets = null;
          if (imageSelected != null)
            assets = await WebService(context)
                .uploadAsset("image", imageSelected, provider.user.token ?? "");

          UserModel userUpdated = await WebService(context).updateUser(
              provider.user.id ?? "",
              cEmail.text,
              cName.text,
              (assets != null && assets is AssetModel) ? assets.id ?? "" : "",
              "",
              provider.user.token ?? "");

          await provider.setUser(userUpdated);
          setState(() {
            imageSelected = null;
          });
          Navigator.pop(loadingContext);
          SnackBar(
                  content: Text("Se ha guardado con éxito",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  elevation: 100,
                  duration: Duration(seconds: 2),
                  backgroundColor: CustomColors.primary)
              .show(context);
        } catch (e) {
          Navigator.pop(loadingContext);
          showErrorsDialog(context, e as dynamic);
        }
      });
    }
  }
}
