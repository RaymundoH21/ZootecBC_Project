import 'package:zootecbc/constants/colors.dart';
import 'package:zootecbc/helpers/helpers.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatefulWidget {
  final String title, description, buttonText;
  final String image;
  final String textBtnCancel;
  final bool useBtnCancel;
  Function callBackBtn;

  dynamic callBackBtnCancel;

  CustomDialog(this.title, this.description, this.buttonText, this.callBackBtn,
      {this.useBtnCancel = false,
      this.textBtnCancel = "Cancelar",
      this.image = "",
      this.callBackBtnCancel = null});
  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
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
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              top: (checkEmpty(widget.image)) ? 100 : 16,
              bottom: 16,
              left: 16,
              right: 16),
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
              Align(
                  alignment: Alignment.center,
                  child: Text(widget.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.0))),
              SizedBox(
                height: 24.0,
              ),
              (widget.useBtnCancel)
                  ? Container(
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  if (widget.callBackBtnCancel != null &&
                                      widget.callBackBtnCancel is Function) {
                                    widget.callBackBtnCancel();
                                  }
                                },
                                child: Text(
                                  widget.textBtnCancel,
                                  style:
                                      TextStyle(color: CustomColors.secondary),
                                )),
                          ),
                          Expanded(
                            child: TextButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  widget.callBackBtn();
                                },
                                child: Text(
                                  widget.buttonText,
                                  style:
                                      TextStyle(color: CustomColors.secondary),
                                )),
                          )
                        ],
                      ),
                    )
                  : Align(
                      alignment: Alignment.center,
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                            widget.callBackBtn();
                          },
                          child: Text(
                            widget.buttonText,
                            style: TextStyle(color: CustomColors.secondary),
                          )),
                    )
            ],
          ),
        ),
        Positioned(
            top: 0,
            left: 16,
            right: 16,
            child: Visibility(
              visible: checkEmpty(widget.image),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 50,
                child: Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Image(
                    width: 40,
                    image: AssetImage((checkEmpty(widget.image)
                        ? widget.image
                        : "assets/images/warning1.gif")),
                  ),
                ),
              ),
            ))
      ],
    );
  }
}
