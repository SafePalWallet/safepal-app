
import 'package:flutter/material.dart';
import 'package:safepal_example/utils/hud_progress_plugin.dart';
import 'package:safepal_example/utils/style.dart';

import 'alert_style.dart';
import 'animation_transition.dart';
import 'dialog_button.dart';
import 'constants.dart';

/// Main class to create alerts.
///
/// You must call the "show()" method to view the alert class you have defined.
class RAlert {
  static const double defaultRadius = 6.0;

  final BuildContext? context;
  final AlertType? type;
  final AlertStyle style;
  final Image? image;
  final String? title;
  final String? desc;
  final Widget? content;
  final EdgeInsets? contentPadding;
  final EdgeInsets? insetPadding;
  final List<DialogButton>? buttons;
  final WillPopCallback? willPop;
  final Color? bgColor;
  final double radius;
  final bool isOverlay; //默认使用overlay显示dialog

  bool? _showLoading = false;

  /// Alert constructor
  ///
  /// [context], [title] are required.
  RAlert({
    required this.context,
    this.type,
    this.style = const AlertStyle(),
    this.image,
    required this.title,
    this.desc,
    this.content,
    this.contentPadding = const EdgeInsets.only(left: 24, top: 24, right: 24, bottom: 24),
    this.insetPadding,
    this.buttons,
    this.willPop,
    this.bgColor,
    this.radius = defaultRadius,
    this.isOverlay = true
  }) {
    _initData();
  }

  Future<void> _initData() async {
    bool isTempDiss = await HUDProgressPlugin.isTempDismiss();
    if (isTempDiss) {
      return;
    }
    _showLoading = await HUDProgressPlugin.isShow();
    if (_showLoading!) {
      await HUDProgressPlugin.tempDismiss();
    }
  }

  void show() {
    showGeneralDialog(
      context: context!,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return buildDialog();
      },
      barrierDismissible: style.isOverlayTapDismiss,
      barrierLabel: MaterialLocalizations.of(context!).modalBarrierDismissLabel,
      barrierColor: style.overlayColor,
      transitionDuration: style.animationDuration,
      transitionBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
          ) => _showAnimation(animation, secondaryAnimation, child),
    );
  }

  // Alert dialog content widget
  Widget buildDialog() {
    Widget child = ClipRRect(
      borderRadius: BorderRadius.only(topRight: Radius.circular(this.radius),topLeft: Radius.circular(this.radius)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        color: this.bgColor??AppColor.dialogBg,
        padding: this.contentPadding,
        child: Center(
          child: this.content,
        ),
      ),
    );

    Widget alertDialog = AlertDialog(
      // backgroundColor: AppColor.dialogBg,
      backgroundColor: bgColor??AppColor.dialogBg,
      shape: style.alertBorder ?? _defaultShape(),
      titlePadding: EdgeInsets.all(0),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      title: child,
      contentPadding: EdgeInsets.all(0),
      insetPadding: this.insetPadding??EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
      content: Container(
        decoration: BoxDecoration(
            color: AppColor.dialogLineWhite,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(this.radius), bottomRight: Radius.circular(this.radius))
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: _getButtons(),
        ),
      ),
    );
    WillPopScope willPopScope = WillPopScope(child: alertDialog, onWillPop: () async {
      bool ret = false;
      if (this.willPop == null) {
        ret = true;
      } else {
        ret = await this.willPop!();
      }
      return ret;
    });
    return willPopScope;
  }

  // Returns alert default border style
  ShapeBorder _defaultShape() {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(this.radius),
    );
  }

  // Returns defined buttons. Default: Cancel Button
  List<Widget> _getButtons() {
    List<Widget> expandedButtons = [];
    if (buttons != null) {
      double offset = 0.0;
      for (int i = 0; i < buttons!.length; i++) {
        if (i == 1) {
          offset = 0.5;
        }
        Widget expandedButton = Expanded(
          flex: 1,
          child: Padding(
              padding: EdgeInsets.only(left: offset, right: 0, bottom: 0, top: 0.5),
            child: Container(
              child: buttons![i],
            ),
          )
        );
        expandedButtons.add(expandedButton);
      }
    } else {
      expandedButtons.add(
        Expanded(
          child: DialogButton(
            child: Text(
              "CANCEL",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context!);
            },
          ),
        ),
      );
    }
    return expandedButtons;
  }

// Shows alert with selected animation
  _showAnimation(animation, secondaryAnimation, child) {
    if (style.animationType == AnimationType.fromRight) {
      return AnimationTransition.fromRight(
          animation, secondaryAnimation, child);
    } else if (style.animationType == AnimationType.fromLeft) {
      return AnimationTransition.fromLeft(animation, secondaryAnimation, child);
    } else if (style.animationType == AnimationType.fromBottom) {
      return AnimationTransition.fromBottom(
          animation, secondaryAnimation, child);
    } else if (style.animationType == AnimationType.grow) {
      return AnimationTransition.grow(animation, secondaryAnimation, child);
    } else if (style.animationType == AnimationType.shrink) {
      return AnimationTransition.shrink(animation, secondaryAnimation, child);
    } else {
      return AnimationTransition.fromTop(animation, secondaryAnimation, child);
    }
  }
}
