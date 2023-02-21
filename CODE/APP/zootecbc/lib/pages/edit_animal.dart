import 'dart:io';
import 'dart:typed_data';

import 'package:zootecbc/components/custom_dialog.dart';

import 'package:zootecbc/components/select_picture_dialog_wec.dart';
import 'package:zootecbc/constants/colors.dart';
import 'package:zootecbc/constants/globals.dart';
import 'package:zootecbc/helpers/helpers.dart';
import 'package:zootecbc/models/animal.dart';
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

class EditAnimal extends StatefulWidget {
  Function callBackBack;
  AnimalModel animal;
  EditAnimal(this.callBackBack, this.animal, {Key? key}) : super(key: key);

  @override
  _EditAnimalState createState() => _EditAnimalState();
}

class _EditAnimalState extends State<EditAnimal> {
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
  List<String> statuses = ["in_adoption", "adopted", "reclaimed", "sacrificed"];

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
  late String statusSelected;

  @override
  void initState() {
    super.initState();
    AnimalModel animal = widget.animal;
    cRace.text = animal.race ?? "";
    cFromFind.text = animal.from ?? "";
    areaSelected = animal.area ?? areas[0];
    genderSelected = animal.gender ?? genders[0];
    speciesSelected = animal.species ?? species[0];
    stageSelected = animal.age ?? stages[0];
    color1Selected = animal.color1 ?? colors[0];
    color2Selected = animal.color2 ?? colors[0];
    statusSelected = animal.status ?? statuses[0];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: true);
    AnimalModel user = widget.animal;

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
                                  child: (widget.animal.picture != null)
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: FadeInImage.assetNetwork(
                                            placeholder:
                                                "assets/images/loading-image1.gif",
                                            image: getImageUrl(
                                                widget.animal.picture!),
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

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: CustomColors.secondary,
                          ),
                          iconSize: 42,
                          items: statuses.map((dynamic statu) {
                            return new DropdownMenuItem(
                                value: statu,
                                child: Text(
                                  getStatusAnimal(statu),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.black),
                                ));
                          }).toList(),
                          onChanged: (color) {
                            setState(() {
                              statusSelected = color as String;
                            });

                            // do other stuff with _category
                          },
                          value: statusSelected,
                          decoration: InputDecoration(
                            labelText: 'Estado',
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

  processEdit() async {
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

          await WebService(context).editAnimal(
              widget.animal.id ?? "",
              formatFirstUpper(cRace.text),
              areaSelected,
              cFromFind.text,
              genderSelected,
              speciesSelected,
              stageSelected,
              color1Selected,
              color2Selected,
              (assets != null && assets is AssetModel) ? assets.id ?? "" : "",
              statusSelected,
              "enabled",
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
          Navigator.pop(context);
        } catch (e) {
          Navigator.pop(loadingContext);
          showErrorsDialog(context, e as dynamic);
        }
      });
    }
  }
}
