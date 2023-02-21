import 'dart:io';
import 'dart:typed_data';

import 'package:zootecbc/components/custom_dialog.dart';

import 'package:zootecbc/components/select_picture_dialog_wec.dart';
import 'package:zootecbc/constants/colors.dart';
import 'package:zootecbc/constants/globals.dart';
import 'package:zootecbc/helpers/helpers.dart';
import 'package:zootecbc/models/asset.dart';
import 'package:zootecbc/models/user.dart';

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
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:snack/snack.dart';

class EditUser extends StatefulWidget {
  Function callBackBack;
  UserModel user;
  EditUser(this.callBackBack, this.user, {Key? key}) : super(key: key);

  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final cEmail = TextEditingController();
  final cName = TextEditingController();

  final cTel = TextEditingController();
  final cBirdate = TextEditingController();
  final cPass = TextEditingController();
  final cPassRepeat = TextEditingController();
  bool passwordVisible = true;
  bool passwordVisibleRepeat = true;

  final formKey = new GlobalKey<FormState>();

  dynamic imageSelected = null;
  dynamic birdate = null;
  String verifiedDoctor = "no";
  String enabled = "yes";
  String codeTel = "";

  List<Map<String, dynamic>> roles = [
    {"name": "Administrador", "val": "admin"},
    {"name": "Cuidador", "val": "keeper"}
  ];

  dynamic imageFront = null;
  dynamic imageBack = null;

  late String rolSelected;

  @override
  void initState() {
    super.initState();
    UserModel user = widget.user;
    rolSelected = user.roles[0].name ?? roles[0]["val"];
    enabled = user.enabled ?? "no";

    cEmail.text = user.email ?? "";
    cName.text = user.name ?? "";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: true);
    UserModel user = widget.user;

    final passwordField = TextFormField(
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp('[ ]')),
      ],
      textInputAction: TextInputAction.next,
      validator: (val) {
        return null;
      },
      controller: cPass,
      obscureText: passwordVisible,
      style: TextStyle(fontSize: 18.0),
      //initialValue: Environment.localPassword(),
      decoration: InputDecoration(
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
          labelText: "Nueva contraseña",
          prefixIcon: Icon(
            FontAwesomeIcons.lock,
            size: 20,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              passwordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                passwordVisible = !passwordVisible;
              });
            },
          )),
    );

    final repeatPasswordField = TextFormField(
      style: TextStyle(fontSize: 18.0),
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp('[ ]')),
      ],
      validator: (val) {
        return null;
      },
      controller: cPassRepeat,
      obscureText: passwordVisibleRepeat,
      //initialValue: Environment.localPassword(),
      decoration: InputDecoration(
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
          labelText: "Confirmar nueva contraseña",
          prefixIcon: Icon(
            FontAwesomeIcons.lock,
            size: 20,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              passwordVisibleRepeat ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                passwordVisibleRepeat = !passwordVisibleRepeat;
              });
            },
          )),
    );

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
      backgroundColor: CustomColors.primary,
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                      onTap: () {
                        widget.callBackBack();
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Icon(FontAwesomeIcons.arrowLeft,
                            size: 20, color: CustomColors.secondary),
                      ))
                ],
              ),
            ),
            Center(
              child: Container(
                constraints:
                    kIsWeb ? BoxConstraints(maxWidth: 1000) : BoxConstraints(),
                child: Padding(
                  padding: (kIsWeb)
                      ? const EdgeInsets.only(
                          left: 35.0,
                          right: 35.0,
                        )
                      : const EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 0, bottom: 10),
                  child: Column(
                    children: [
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
                                  child: (widget.user.picture != null)
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: FadeInImage.assetNetwork(
                                            placeholder:
                                                "assets/images/loading-image1.gif",
                                            image: getImageUrl(
                                                widget.user.picture!),
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

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: Colors.grey,
                          ),
                          iconSize: 42,
                          items: roles.map((dynamic rol) {
                            return new DropdownMenuItem(
                                value: rol["val"],
                                child: Text(rol["name"],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1));
                          }).toList(),
                          onChanged: (rol) {
                            setState(() {
                              rolSelected = rol as String;
                            });

                            // do other stuff with _category
                          },
                          value: rolSelected,
                          decoration: InputDecoration(
                            labelText: 'Tipo de usuario',
                            labelStyle:
                                TextStyle(color: CustomColors.secondary),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.secondary),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.secondary),
                            ),
                            border: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.secondary),
                            ),
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text("Estatus del usuario",
                              style: TextStyle(
                                  color: CustomColors.secondary, fontSize: 15)),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              setState(() {
                                enabled = "yes";
                              });
                            },
                            child: ListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: const Text('Activo'),
                              leading: Radio<String>(
                                value: "yes",
                                groupValue: enabled,
                                focusColor: CustomColors.secondary,
                                hoverColor: CustomColors.secondary,
                                fillColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  return CustomColors.secondary;
                                }),
                                onChanged: (String? value) {
                                  setState(() {
                                    enabled = value ?? "yes";
                                  });
                                },
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                enabled = "no";
                              });
                            },
                            child: ListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: const Text('Inactivo'),
                              leading: Radio<String>(
                                value: "no",
                                focusColor: CustomColors.secondary,
                                hoverColor: CustomColors.secondary,
                                fillColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  return CustomColors.secondary;
                                }),
                                groupValue: enabled,
                                onChanged: (String? value) {
                                  setState(() {
                                    enabled = value ?? "no";
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      //----------------------------new

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text("Cambiar contraseña",
                              style: TextStyle(
                                  color: CustomColors.secondary, fontSize: 15)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: passwordField,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: repeatPasswordField,
                      ),

                      //new
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 2,
                              primary: CustomColors.secondary,
                              shape: StadiumBorder()),
                          onPressed: () {
                            processEdit();
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

  showTakePictureId(String type) async {
    await showDialog(
        context: context,
        builder: (contextDialog) {
          return SelectPictureDialogWec(
            "Seleccionar imagen",
            (contextDialogd, image) {
              Navigator.pop(contextDialog);
              callbackShowTakePictureId(contextDialogd, image, type);
            },
            useBtnCancel: true,
          );
        });
  }

  Future callbackShowTakePictureId(contextDialog, image, String type) async {
    if (image == null) return;
    try {
      final XFile? imageFile = await ImagePicker().pickImage(
          source:
              (image == "camera") ? ImageSource.camera : ImageSource.gallery);
      if (imageFile != null) {
        File file = await File(imageFile.path);
        setState(() {
          if (type == "front") {
            this.imageFront = file;
          } else if (type == "back") {
            this.imageBack = file;
          } else {
            this.imageSelected = file;
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  processEdit() async {
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

          await WebService(context).updateUserAdmin(
              widget.user.id ?? "",
              cEmail.text,
              cName.text,
              (assets != null && assets is AssetModel) ? assets.id ?? "" : "",
              rolSelected,
              cPass.text,
              cPassRepeat.text,
              enabled,
              provider.user.token ?? "");
          Navigator.pop(loadingContext);
          SnackBar(
                  content: Text("Se ha guardado con éxito",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  elevation: 100,
                  duration: Duration(seconds: 2),
                  backgroundColor: CustomColors.secondary)
              .show(context);
          widget.callBackBack();
        } catch (e) {
          Navigator.pop(loadingContext);
          showErrorsDialog(context, e as dynamic);
        }
      });
    }
  }
}
