import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:snack/snack.dart';
import 'package:zootecbc/components/custom_dialog.dart';
import 'package:zootecbc/constants/colors.dart';
import 'package:zootecbc/constants/globals.dart';
import 'package:zootecbc/helpers/helpers.dart';
import 'package:zootecbc/models/animal.dart';
import 'package:zootecbc/models/user.dart';
import 'package:zootecbc/pages/add_animal.dart';
import 'package:zootecbc/pages/add_user.dart';
import 'package:zootecbc/pages/edit_ANIMAL.dart';
import 'package:zootecbc/pages/edit_user.dart';
import 'package:zootecbc/services/web_service.dart';

import '../providers/app.dart';

class Animals extends StatefulWidget {
  const Animals({super.key});

  @override
  State<Animals> createState() => _AnimalsState();
}

class _AnimalsState extends State<Animals> {
  final cSearch = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  var _controllerScroll = ScrollController();

  num limit = 30;
  bool noMore = false;
  bool loading = false;
  List<AnimalModel> animals = [];

  String filterArea = "";
  List<String> areas = [
    "Todos",
    "Tijuana",
    "Tecate",
    "Mexicali",
    "Ensenada",
    "Rosarito"
  ];
  @override
  void initState() {
    super.initState();

    filterArea = areas[0];

    final provider = Provider.of<AppProvider>(context, listen: false);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState!.show();
    });

    _controllerScroll.addListener(() {
      if (_controllerScroll.position.atEdge) {
        if (_controllerScroll.position.pixels == 0) {
        } else {
          setState(() {
            loading = true;
          });
          loadMore();
        }
      }
    });
  }

  void dispose() {
    super.dispose();
    _controllerScroll.dispose();
  }

  Future<Null> loadMore() {
    setState(() {
      loading = true;
    });
    final provider = Provider.of<AppProvider>(context, listen: false);
    return WebService(context)
        .getAnimals(limit, animals.length, context, provider.user.token ?? "",
            search: cSearch.text, filter_area: filterArea)
        .then((value) {
      if (value.length > 0) {
        if (mounted)
          setState(() {
            animals.addAll(value);
            noMore = false;
          });
      } else {
        noMore = true;
        print("entre a no hay más");
      }

      Timer(Duration(seconds: 1), () {
        WidgetsBinding.instance?.addPostFrameCallback((_) async {
          if (mounted)
            setState(() {
              loading = false;
            });
        });
      });
    }).catchError((e) {
      Timer(Duration(seconds: 1), () {
        if (mounted)
          setState(() {
            loading = false;
          });
      });
      showErrorsDialog(context, e);
    });
  }

  Future<Null> load() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    return WebService(context)
        .getAnimals(limit, 0, context, provider.user.token ?? "",
            search: cSearch.text, filter_area: filterArea)
        .then((value) {
      if (mounted)
        setState(() {
          animals = value;
        });
    }).catchError((e) {
      showErrorsDialog(context, e);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: true);
    UserModel user = provider.user;
    double widthLeftMenu =
        (MediaQuery.of(context).size.width >= breakPointDesktop)
            ? desktopMenuLeftWidth
            : 0;

    Widget searchField = TextField(
      onTap: () {},
      autofocus: false,
      controller: cSearch,
      style: TextStyle(color: Colors.black),
      textInputAction: TextInputAction.search,
      //maxLength: 1,
      textAlign: TextAlign.left,

      //focusNode: myFocusNode1,
      decoration: InputDecoration(
          counterText: '',
          hintText: "Buscar",
          hintStyle: TextStyle(color: Colors.white, fontSize: 14),
          prefixIcon: InkWell(
            onTap: () {
              cSearch.text = "";
              _refreshIndicatorKey.currentState!.show();
            },
            child: Icon(
              Icons.cancel,
              size: 20,
              color: CustomColors.primary,
            ),
          ),
          suffixIcon: InkWell(
            splashColor: Colors.white,
            onTap: () {
              _refreshIndicatorKey.currentState!.show();
            },
            child: Icon(
              Icons.search,
              size: 20,
              color: Colors.white,
            ),
          ),
          //contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          contentPadding: const EdgeInsets.fromLTRB(45, 0, 0, 0),
          //contentPadding: EdgeInsets.zero,
          filled: true,
          isDense: true,
          fillColor: CustomColors.secondary,
          focusColor: CustomColors.secondary[200],
          hoverColor: CustomColors.secondary[200],
          enabledBorder: OutlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
            borderSide: BorderSide(color: Colors.transparent, width: 0.0),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedBorder: OutlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
            borderSide: BorderSide(color: Colors.transparent, width: 0.0),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          border: InputBorder.none),
      onChanged: (valueSearch) {},
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(FocusNode());
        _refreshIndicatorKey.currentState!.show();
      },
    );

    List<ResponsiveGridCol> progressWidgets =
        animals.asMap().entries.map((animal) {
      AnimalModel aTmp = animal.value;
      String created = getDateTimeFromStringFormat(
          DateTime.parse(aTmp.created_at!).toLocal().toString());
      return ResponsiveGridCol(
          lg: 4,
          xs: 12,
          md: 12,
          child: Visibility(
              visible: true,
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 2.0, vertical: 2.0),
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4, left: 8.0, right: 8.0),
                                  child: Text(aTmp.id ?? "",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4, left: 8.0, right: 8.0),
                                  child: Text(created,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 11),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child:
                                                EditAnimal(callbackEdit, aTmp),
                                            type: PageTransitionType.slideInUp,
                                            duration:
                                                Duration(milliseconds: 250)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(FontAwesomeIcons.edit,
                                        color: CustomColors.secondary,
                                        size: 17),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    delete(aTmp);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(FontAwesomeIcons.times,
                                        color: CustomColors.secondary,
                                        size: 17),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    width: 85,
                                    height: 85,
                                    decoration: new BoxDecoration(
                                      border: new Border.all(
                                        width: 1,
                                        color: Colors.grey.shade200,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade200,
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: Offset(0,
                                              0), // changes position of shadow
                                        ),
                                      ], // border color
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 5.0),
                                      child: (aTmp.picture != null &&
                                              getImageUrl(aTmp.picture!)
                                                      .trim() !=
                                                  "")
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(75.0),
                                              child: FadeInImage.assetNetwork(
                                                placeholder:
                                                    "assets/images/loading-image1.gif",
                                                image:
                                                    getImageUrl(aTmp.picture!),
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Container(
                                              decoration: new BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius: new BorderRadius
                                                          .all(
                                                      Radius.circular(85.0))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                  "assets/images/avatar.png",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Text("Area: " + (aTmp.area ?? ""),
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Text(
                                          "Donde fue encontrado: " +
                                              (aTmp.from ?? ""),
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Text(
                                          "Estado: " +
                                              (getStatusAnimal(
                                                  aTmp.status ?? "")),
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Text("Raza: " + (aTmp.race ?? ""),
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Text(
                                          "Sexo: " + (aTmp.gender ?? ""),
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Text(
                                          "Especie: " + (aTmp.species ?? ""),
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Text("edad: " + (aTmp.age ?? ""),
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Text(
                                          "Color 1: " + (aTmp.color1 ?? ""),
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Text(
                                          "Color 2: " + (aTmp.color2 ?? ""),
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )));
    }).toList();

    progressWidgets.add(ResponsiveGridCol(
        lg: 12,
        xs: 12,
        md: 12,
        child: Visibility(
          visible: loading,
          child: Container(
            width: 30,
            height: 30,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(CustomColors.primary)),
              ),
            ),
          ),
        )));

    if (noMore) {
      progressWidgets.add(ResponsiveGridCol(
          lg: 12,
          xs: 12,
          md: 12,
          child: Visibility(
            visible: !loading,
            child: Center(
              child: Container(
                  height: 30,
                  child: Text("No hay mas elementos para mostrar.")),
            ),
          )));
    }

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
        ),
        actions: [
          new IconButton(
            icon: new Icon(
              FontAwesomeIcons.plus,
              size: 20,
              color: CustomColors.secondary,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                      child: AddAnimal(callbackAdd),
                      type: PageTransitionType.slideInUp,
                      duration: Duration(milliseconds: 250)));
            },
          )
        ],
      ),
      backgroundColor: CustomColors.primary,
      body: Stack(
        children: [
          Positioned(
              top: (MediaQuery.of(context).padding.top) - 30,
              left: 0,
              width: MediaQuery.of(context).size.width - widthLeftMenu,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ResponsiveGridRow(children: [
                        ResponsiveGridCol(
                          lg: 10,
                          xs: 12,
                          md: 12,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: searchField,
                          ),
                        ),
                        ResponsiveGridCol(
                            lg: 4,
                            xs: 12,
                            md: 12,
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                child: DropdownButtonFormField(
                                  isExpanded: true,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: Colors.grey,
                                  ),
                                  iconSize: 42,
                                  items: areas.map((dynamic are) {
                                    return new DropdownMenuItem(
                                        value: are,
                                        child: Text(are,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1));
                                  }).toList(),
                                  onChanged: (rol) {
                                    setState(() {
                                      filterArea = rol as String;
                                    });
                                    _refreshIndicatorKey.currentState!.show();

                                    // do other stuff with _category
                                  },
                                  value: filterArea,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(
                                        16.0, 0.0, 0.0, 0.0),
                                    hintText: "Selecciona la categoría",
                                    hintStyle: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 14),
                                    fillColor: Colors.white,
                                    focusColor: Colors.grey,
                                    hoverColor: Colors.grey,
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                            width: 1.0),
                                        borderRadius:
                                            BorderRadius.circular(6.0)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                            width: 1.0),
                                        borderRadius:
                                            BorderRadius.circular(6.0)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                            width: 1.0),
                                        borderRadius:
                                            BorderRadius.circular(6.0)),
                                    errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red.shade300,
                                            width: 1.0),
                                        borderRadius:
                                            BorderRadius.circular(6.0)),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red.shade300,
                                            width: 1.0),
                                        borderRadius:
                                            BorderRadius.circular(6.0)),
                                  ),
                                )))
                      ]),
                    ]),
              )),
          Positioned.fill(
              top: (MediaQuery.of(context).padding.top) + 110,
              child: RefreshIndicator(
                  color: CustomColors.primary,
                  key: _refreshIndicatorKey,
                  displacement: MediaQuery.of(context).size.height * .40,
                  onRefresh: load,
                  child: SingleChildScrollView(
                    controller: _controllerScroll,
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height,
                              maxHeight: double.infinity),
                          child: (animals.length <= 0)
                              ? Center(
                                  child: Column(
                                  children: [
                                    Text(
                                      "No hay ningún elemento para mostrar",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                  ],
                                ))
                              : Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          ResponsiveGridRow(
                                              children: progressWidgets)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  )))
        ],
      ),
    );
  }

  delete(AnimalModel anim) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (contextDialog) {
          return CustomDialog(
            "",
            "¿Realmente desea eliminar el elemento?",
            "Aceptar",
            () {
              simpleLoading(context, (BuildContext loadingContext) {
                final provider =
                    Provider.of<AppProvider>(context, listen: false);

                WebService(context)
                    .deleteAnimal(provider.user.token ?? "", anim.id ?? "")
                    .then((res) {
                  SnackBar(
                          content: Text("Se ha eliminado correctamente",
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          elevation: 100,
                          duration: Duration(seconds: 2),
                          backgroundColor: CustomColors.primary)
                      .show(context);
                  Navigator.pop(loadingContext);
                  _refreshIndicatorKey.currentState!.show();
                }).catchError((e) {
                  Navigator.pop(loadingContext);
                  showErrorsDialog(context, e);
                });
              });
            },
            useBtnCancel: true,
            image: '',
          );
        });
  }

  callbackAdd() {
    _refreshIndicatorKey.currentState!.show();
  }

  callbackEdit() {
    _refreshIndicatorKey.currentState!.show();
  }
}
