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
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:snack/snack.dart';

class AddAnimal extends StatefulWidget {
  Function callback;
  AddAnimal(this.callback, {Key? key}) : super(key: key);

  @override
  _AddAnimalState createState() => _AddAnimalState();
}

class _AddAnimalState extends State<AddAnimal> {
  final cRace = TextEditingController();
  final cFromFind = TextEditingController();

  final formKey = new GlobalKey<FormState>();

  dynamic imageSelected = null;

  String enabled = "yes";

  List<String> areas = [
    "",
    "Tijuana",
    "Tecate",
    "Mexicali",
    "Ensenada",
    "Rosarito"
  ];

  List<String> genders = ["", "Macho", "Hembra"];
  List<String> species = ["", "Perro", "Gato", "Otro"];
  List<String> stages = ["", "Cachorro", "Joven", "Adulto"];
  List<String> colors = [
    "",
    "Blanco",
    "Negro",
    "Gris",
    "Marrón",
    "Naranja",
    "Amarillo",
    "Beige",
    "Rojo",
    "Otro"
  ];

  late String areaSelected;
  late String genderSelected;
  late String speciesSelected;
  late String stageSelected;
  late String color1Selected;
  late String color2Selected;

  @override
  void initState() {
    super.initState();
    areaSelected = areas[0];
    genderSelected = genders[0];
    speciesSelected = species[0];
    stageSelected = stages[0];
    color1Selected = colors[0];
    color2Selected = colors[0];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: true);

    final raceField = TextFormField(
      autofocus: false,
      autocorrect: false,
      controller: cRace,
      keyboardType: TextInputType.text,
      validator: (val) {
        return requiredField(val ?? "", context);
      },
      obscureText: false,
      style: TextStyle(fontSize: 18.0),
      //initialValue: Environment.localUsername(),
      decoration: InputDecoration(
        labelText: 'Raza',
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

    final fromFindField = TextFormField(
      autofocus: false,
      autocorrect: false,
      controller: cFromFind,
      keyboardType: TextInputType.text,
      validator: (val) {
        return requiredField(val ?? "", context);
      },
      obscureText: false,
      style: TextStyle(fontSize: 18.0),
      //initialValue: Environment.localUsername(),
      decoration: InputDecoration(
        labelText: 'Donde fue encontrado',
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
      body: Padding(
        padding:
            const EdgeInsets.only(left: 25.0, right: 25.0, top: 25, bottom: 10),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Center(
                child: Container(
                  constraints: BoxConstraints(),
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
                                  child: Container(
                                    decoration: new BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: new BorderRadius.all(
                                            Radius.circular(45.0))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image.asset(
                                        "assets/images/avatar_animal.png",
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
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: raceField,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: CustomColors.secondary,
                          ),
                          iconSize: 42,
                          items: areas.map((dynamic rol) {
                            return new DropdownMenuItem(
                                value: rol,
                                child: Text(
                                  rol,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.black),
                                ));
                          }).toList(),
                          onChanged: (rol) {
                            setState(() {
                              areaSelected = rol as String;
                            });

                            // do other stuff with _category
                          },
                          value: areaSelected,
                          decoration: InputDecoration(
                            labelText: 'Area',
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

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: fromFindField,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: CustomColors.secondary,
                          ),
                          iconSize: 42,
                          items: genders.map((dynamic gen) {
                            return new DropdownMenuItem(
                                value: gen,
                                child: Text(
                                  gen,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.black),
                                ));
                          }).toList(),
                          onChanged: (rol) {
                            setState(() {
                              genderSelected = rol as String;
                            });

                            // do other stuff with _category
                          },
                          value: genderSelected,
                          decoration: InputDecoration(
                            labelText: 'Sexo',
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

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: CustomColors.secondary,
                          ),
                          iconSize: 42,
                          items: species.map((dynamic specie) {
                            return new DropdownMenuItem(
                                value: specie,
                                child: Text(
                                  specie,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.black),
                                ));
                          }).toList(),
                          onChanged: (rol) {
                            setState(() {
                              speciesSelected = rol as String;
                            });

                            // do other stuff with _category
                          },
                          value: speciesSelected,
                          decoration: InputDecoration(
                            labelText: 'Especie',
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

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: CustomColors.secondary,
                          ),
                          iconSize: 42,
                          items: stages.map((dynamic stage) {
                            return new DropdownMenuItem(
                                value: stage,
                                child: Text(
                                  stage,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.black),
                                ));
                          }).toList(),
                          onChanged: (stage) {
                            setState(() {
                              stageSelected = stage as String;
                            });

                            // do other stuff with _category
                          },
                          value: stageSelected,
                          decoration: InputDecoration(
                            labelText: 'Edad',
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

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: CustomColors.secondary,
                          ),
                          iconSize: 42,
                          items: colors.map((dynamic color) {
                            return new DropdownMenuItem(
                                value: color,
                                child: Text(
                                  color,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.black),
                                ));
                          }).toList(),
                          onChanged: (color) {
                            setState(() {
                              color1Selected = color as String;
                            });

                            // do other stuff with _category
                          },
                          value: color1Selected,
                          decoration: InputDecoration(
                            labelText: 'Color 1',
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

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: CustomColors.secondary,
                          ),
                          iconSize: 42,
                          items: colors.map((dynamic color) {
                            return new DropdownMenuItem(
                                value: color,
                                child: Text(
                                  color,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.black),
                                ));
                          }).toList(),
                          onChanged: (color) {
                            setState(() {
                              color2Selected = color as String;
                            });

                            // do other stuff with _category
                          },
                          value: color2Selected,
                          decoration: InputDecoration(
                            labelText: 'Color 2',
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
                      //new
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 2,
                              primary: CustomColors.secondary,
                              shape: StadiumBorder()),
                          onPressed: () {
                            processAdd();
                          },
                          child: Container(
                            width: double.infinity,
                            height: 35.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Agregar",
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
              )
            ],
          ),
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

  processAdd() async {
    if (areaSelected == "") {
      showErrorsDialog(context, ["Debe seleccionar el area"]);
      return;
    }
    if (genderSelected == "") {
      showErrorsDialog(context, ["Debe seleccionar el sexo"]);
      return;
    }
    if (speciesSelected == "") {
      showErrorsDialog(context, ["Debe seleccionar la especie"]);
      return;
    }
    if (stageSelected == "") {
      showErrorsDialog(context, ["Debe seleccionar la edad"]);
      return;
    }

    if (color1Selected == "") {
      showErrorsDialog(context, ["Debe seleccionar el color 1"]);
      return;
    }
    if (imageSelected == null) {
      showErrorsDialog(context, ["Debe seleccionar o tomar una fotografía"]);
      return;
    }
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

          await WebService(context).addAnimal(
              formatFirstUpper(cRace.text),
              areaSelected,
              cFromFind.text,
              genderSelected,
              speciesSelected,
              stageSelected,
              color1Selected,
              color2Selected,
              (assets != null && assets is AssetModel) ? assets.id ?? "" : "",
              "in_adoption",
              "enabled",
              provider.user.token ?? "");

          Navigator.pop(loadingContext);
          SnackBar(
                  content: Text("Se ha agregado con éxito",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  elevation: 100,
                  duration: Duration(seconds: 2),
                  backgroundColor: CustomColors.secondary)
              .show(context);
          Navigator.pop(context);
          if (widget.callback != null) widget.callback();
        } catch (e) {
          Navigator.pop(loadingContext);
          showErrorsDialog(context, e as dynamic);
        }
      });
    }
  }
}
