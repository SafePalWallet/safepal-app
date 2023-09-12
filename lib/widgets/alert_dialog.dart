import 'package:flutter/material.dart';
import 'package:safepal_example/widgets/rflutter_alert/rflutter_alert.dart';
import 'dart:async';

import '../utils/style.dart';

class AlertButtonConfig {
  final Color? titleColor;

  AlertButtonConfig({
    this.titleColor
  });
}

class Alert {
  static bool isShow = false;

  static AlertButtonConfig _defaultConfig() {
    return AlertButtonConfig(
      titleColor: AppColor.blue
    );
  }

  static Widget createDeafultDialogBottomWidget({
    required List<String> buttons,
    required ValueChanged<int> onPress
  }) {
    if (buttons.isEmpty) {
      return Container();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider()
      ],
    );
  }

  static List<DialogButton> createDialogButtons({
    BuildContext? context,
    required List<String?> buttons,
    TextAlign? textAlign,
    ValueChanged<int>? onPress
  }) {
    List<DialogButton> dialogButtons = [];
    final Radius radius = Radius.circular(RAlert.defaultRadius);
    for (String? buttonTitle in buttons) {
      int index = buttons.indexOf(buttonTitle);
      AlertButtonConfig config = _defaultConfig();
      BorderRadius borderRadius;
      if (buttons.length == 1) {
        borderRadius = BorderRadius.only(bottomLeft: radius, bottomRight: radius);
      } else {
        if (index == 0) {
          borderRadius = BorderRadius.only(bottomLeft: radius);
        } else {
          borderRadius = BorderRadius.only(bottomRight: radius);
        }
      }
      DialogButton btn = DialogButton(
        color: AppColor.dialogBg,
        radius: borderRadius,
        onPressed: () {
          Alert.isShow = false;
          if (onPress != null) {
            onPress(buttons.indexOf(buttonTitle));
          }
        },
        child: Text(
          buttonTitle!,
          style: TextStyle(color: config.titleColor, fontSize: 16),
          textAlign: textAlign,
        ),
      );
      dialogButtons.add(btn);
    }
    return dialogButtons;
  }

  static Future<int> syncShow({
    required BuildContext? context,
    required String content,
    String? title,
    TextAlign textAlign = TextAlign.center,
    WillPopCallback? willPop,
    String? attachOption,
    Widget? attachChild,
    VoidCallback? attachOnPress,
    required List<String> options,
  }) async {
    Completer<int> completer = Completer();
    show(
      title: title,
      context: context,
      textAlign: textAlign,
      content: content,
      options: options,
      attachChild: attachChild,
      attachOption: attachOption,
      willPop: willPop,
      attachOnPress: attachOnPress,
      onPress: (idx){
      completer.complete(idx);
    });
    return completer.future;
  }

  static void show({
    required BuildContext? context,
    required String content,
    TextAlign? textAlign,
    String? attachOption,
    Widget? attachChild,
    String? title,
    TextStyle? titleStyle,
    WillPopCallback? willPop,
    required List<String> options,
    ValueChanged<int>? onPress,
    VoidCallback? attachOnPress,
    bool isOverlay = false
  }) {
    _build(
        context: context,
        content: content,
        textAlign: textAlign,
        attachOption: attachOption,
        attachChild: attachChild,
        title: title,
        titleStyle: titleStyle,
        willPop: willPop,
        options: options,
        onPress: onPress,
        attachOnPress: attachOnPress,
        isOverlay: isOverlay,
        onlyBuildWidget: false
    );
    return;
  }

  static Widget buildDialogWidget({
    required BuildContext? context,
    required String content,
    TextAlign? textAlign,
    String? attachOption,
    Widget? attachChild,
    String? title,
    TextStyle? titleStyle,
    WillPopCallback? willPop,
    required List<String> options,
    ValueChanged<int>? onPress,
    VoidCallback? attachOnPress,
  }) {
    Widget? child = _build(
        context: context,
        content: content,
        textAlign: textAlign,
        attachOption: attachOption,
        attachChild: attachChild,
        title: title,
        titleStyle: titleStyle,
        willPop: willPop,
        options: options,
        onPress: onPress,
        attachOnPress: attachOnPress,
        isOverlay: false,
        onlyBuildWidget: true
    );
    if (child == null) {
      return Container();
    }
    return child;
  }

  static Widget buildCustomDialogWidget({
    required BuildContext context,
    required Widget contentWidget,
    required List<String> options,
    required ValueChanged<int>? onPress,
    Color? bgColor,
    double radius = 6.0,
  }) {
    late RAlert alert;
    List<DialogButton> buttons = createDialogButtons(
      context: context,
      onPress: (idx){
        if (onPress != null) {
          onPress(idx);
        }
      },
      textAlign: TextAlign.center,
      buttons: options,);
    isShow = true;
    AlertStyle style = AlertStyle(isOverlayTapDismiss: false);
    alert = RAlert(
        title: null,
        contentPadding: EdgeInsets.all(0),
        insetPadding: EdgeInsets.all(0),
        context: context,
        content: contentWidget,
        buttons: buttons,
        bgColor: bgColor ?? AppColor.dialogBg,
        style: style,
        radius: radius
    );
    return alert.buildDialog();
  }

  static Widget? _build({
    required BuildContext? context,
    required String content,
    TextAlign? textAlign,
    String? attachOption,
    Widget? attachChild,
    String? title,
    TextStyle? titleStyle,
    WillPopCallback? willPop,
    required List<String> options,
    ValueChanged<int>? onPress,
    VoidCallback? attachOnPress,
    bool isOverlay = false,
    bool onlyBuildWidget = false
  }) {
    late RAlert alert;
    List<DialogButton> buttons = createDialogButtons(
        context: context,
        onPress: (idx){
          if (!onlyBuildWidget) {
            if(!isOverlay){
              Navigator.pop(context!);
            }
          }
          if(onPress != null) {
            onPress(idx);
          }
        },
        textAlign: TextAlign.center,
        buttons: options
    );
    if(textAlign==null){
      if(content!=null && content.length>30){
        textAlign = TextAlign.left;
      }else{
        textAlign = TextAlign.center;
      }
    }
    Text text = Text(
      content,
      textAlign: textAlign,
      style: TextStyle(color: AppColor.dialogTextColor1, fontSize: 15, fontWeight: FontWeight.normal),
      maxLines: null,
    );
    Widget titleWidget = Container();
    EdgeInsets contentPadding;
    double contentPaddingTop = 24;
    if (title != null) {
      titleStyle = titleStyle ?? AppTextStyle.headMedium.apply(color: AppColor.dialogTextColor1);
      titleWidget = Text(
        title,
        maxLines: 1,
        style: titleStyle,
        overflow: TextOverflow.ellipsis,
      );
      titleWidget = Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: 18),
        child: titleWidget,
      );
      contentPaddingTop = 18.0;
    }
    Widget widget;
    if (((attachOption != null) && attachOption.isNotEmpty) || attachChild != null) {
      Widget attachWidget;
      if (attachChild != null) {
        attachWidget = attachChild;
      } else {
        Widget child = Container(
          alignment: Alignment.centerRight,
          color: Colors.white.withAlpha(0),
          padding: EdgeInsets.only(left: 20, right: 4, top: 12, bottom: 24),
          child: Text(attachOption!, style: TextStyle(color: AppColor.blue, fontSize: 14),),
        );
        Widget gesture = GestureDetector(
          onTap: (){
            if (!onlyBuildWidget) {
              Alert.isShow = false;
            }
            if (attachOnPress != null) {
              attachOnPress();
            }
          },
          child: child,
        );
        attachWidget = Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child:Container()
            ),
            gesture
          ],
        );
      }
      widget = Container(
        child: Column(
          children: <Widget>[
            titleWidget,
            text,
            attachWidget
          ],
        ),
      );
      contentPadding = EdgeInsets.only(left: 24, top: contentPaddingTop, right: 24, bottom: 0);
    } else {
      widget = Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          titleWidget,
          text
        ],
      );
      contentPadding = EdgeInsets.only(left: 24, bottom: 24, right: 24, top: contentPaddingTop);
    }

    alert = RAlert(
        title: null,
        contentPadding: contentPadding,
        context: context,
        content: Container(
          child: widget,
        ),
        buttons:buttons,
        willPop:willPop,
        bgColor: AppColor.dialogBg,
        isOverlay:isOverlay
    );
    if (onlyBuildWidget) {
      return alert.buildDialog();
    }
    isShow = true;
    alert.show();
    return null;
  }

  static void showCustomWidget({
    required BuildContext? context,
    required Widget contentWidget,
    required List<String?> options,
    required ValueChanged<int>? onPress,
    EdgeInsets? insetPadding,
    WillPopCallback? willPop,
    Color? bgColor,
    double radius = 6.0,
    bool isOverlay = false,
    bool isTapBgDismiss = false
  }) {
    EdgeInsets contentPadding = EdgeInsets.all(0);
    late RAlert alert;
    List<DialogButton> buttons = createDialogButtons(
        context: context,
        onPress: (idx){
          if (onPress != null) {
            onPress(idx);
          }
        },
        textAlign: TextAlign.center,
        buttons: options,);
    isShow = true;
    AlertStyle style = AlertStyle(isOverlayTapDismiss: isTapBgDismiss);
    alert = RAlert(
        title: null,
        contentPadding: contentPadding,
        insetPadding: insetPadding,
        context: context,
        content: contentWidget,
        buttons: buttons,
        bgColor: bgColor??AppColor.dialogBg,
        isOverlay: false,
        style: style,
        radius: radius
        // willPop: willPop
    );
    alert.show();
  }

  static Future<int> syncShowCustomWidget({
    required BuildContext? context,
    required Widget contentWidget,
    required List<String> options,
    WillPopCallback? willPop,
    bool isOverlay = false,
  }) async {
    Completer<int> completer = Completer<int>();
    showCustomWidget(context: context, contentWidget: contentWidget, willPop: willPop, options: options, isOverlay:isOverlay,onPress: (idx){
      // Navigator.of(context).pop();
      // completer.complete(idx);
      if(!completer.isCompleted) {
        completer.complete(idx);
      }
    });
    return completer.future;
  }

  static void showHintDialog({
    required BuildContext context,
    required List<String> options,
    required ValueChanged<int> onPress,
    String? title,
    required String content,
    ValueChanged<bool>? checkedDidChange,
    TextAlign textAlign = TextAlign.center,
    Alignment alignment = Alignment.center,
    Color titleBgColor = Colors.transparent,
    WillPopCallback? willPop,
    bool isOverlay = false
  }){
    late RAlert alert;
    List<DialogButton> buttons = createDialogButtons(
        context: context,
        onPress: (idx){
          if(!isOverlay){
            Navigator.pop(context);
          }
          if (onPress != null) {
            onPress(idx);
          }
        },
        textAlign: TextAlign.center,
        buttons: options);
    Widget titleWidget = title!=null?Container(
      height: 44,
      // alignment: Alignment.center,
      alignment: alignment,
      width: double.infinity,
      decoration: BoxDecoration(
        color: titleBgColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5))
      ),
      child: Text(
        title,
        textAlign: textAlign,
        // style: TextStyle(color: Color(0xFF000000), fontSize: AppFont.font15, fontWeight: FontWeight.bold),
        style: TextStyle(color: AppColor.textDarkColor1, fontSize: 15, fontWeight: FontWeight.bold),
        maxLines: null,
      ),
    ):Container();

    Widget contentWidget = Container(
      margin: EdgeInsets.only(top:18,left: 24,right: 24),
      child: Text(
        content,
        textAlign: textAlign,
        style: TextStyle(color: AppColor.dialogTextColor1, fontSize: 15, fontWeight: FontWeight.normal),
        maxLines: null,
      ),
    );

    Widget attachChild = Container();
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center;
    switch (textAlign) {
      case TextAlign.start:
        crossAxisAlignment = CrossAxisAlignment.start;
        break;
      case TextAlign.center:
        crossAxisAlignment = CrossAxisAlignment.center;
        break;
      case TextAlign.end:
        crossAxisAlignment = CrossAxisAlignment.end;
        break;
      default:
        break;
    }
    double bottomOffset = checkedDidChange != null ? 0 : 24;

    alert = RAlert(
        title: null,
        context: context,
        contentPadding: EdgeInsets.only(bottom: bottomOffset),
        content: Column(
          crossAxisAlignment: crossAxisAlignment,
          children: <Widget>[
            titleWidget,
            contentWidget,
            attachChild
          ],
        ),
        buttons:buttons,
        willPop: willPop,
        bgColor: AppColor.dialogBg,
        isOverlay: isOverlay
    );
    alert.show();
  }


}