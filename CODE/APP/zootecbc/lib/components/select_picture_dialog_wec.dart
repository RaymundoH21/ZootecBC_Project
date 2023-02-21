import 'package:zootecbc/constants/colors.dart';
import 'package:zootecbc/helpers/helpers.dart';
import 'package:zootecbc/models/user.dart';
import 'package:zootecbc/providers/app.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SelectPictureDialogWec extends StatefulWidget {
  final String title;
  final bool useBtnCancel;
  Function callBackBtn;

  SelectPictureDialogWec(this.title, this.callBackBtn,
      {this.useBtnCancel = false});
  @override
  _SelectPictureDialogWecState createState() => _SelectPictureDialogWecState();
}

class _SelectPictureDialogWecState extends State<SelectPictureDialogWec> {
  TextStyle style = TextStyle(fontSize: 18.0);
  String comments = "";
  final ctrlComments = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: getDialogInsetPaddin(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: true);
    UserModel user = provider.user;

    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 20, bottom: 16, left: 16, right: 16),
          margin: EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(17.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                )
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 16.0,
              ),
              ButtonTheme(
                minWidth: 230.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 10.0),
                      elevation: 2,
                      primary: CustomColors.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide.none,
                      )),
                  child: Row(
                    // Replace with a Row for horizontal icon + text

                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(Icons.photo_library,
                              size: 20, color: Colors.white)),
                      Text(
                        "Galería",
                        textAlign: TextAlign.center,
                        style: style.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  onPressed: () {
                    widget.callBackBtn(context, "gallery");
                  },
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              ButtonTheme(
                minWidth: 230.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 10.0),
                      elevation: 2,
                      primary: CustomColors.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide.none,
                      )),
                  child: Row(
                    // Replace with a Row for horizontal icon + text

                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(FontAwesomeIcons.camera,
                              size: 18, color: Colors.white)),
                      Text(
                        "Cámara",
                        textAlign: TextAlign.center,
                        style: style.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  onPressed: () {
                    widget.callBackBtn(context, "camera");
                  },
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Container(
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancelar",
                            style: TextStyle(color: CustomColors.secondary)),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
