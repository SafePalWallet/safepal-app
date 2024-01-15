import 'package:flutter/material.dart';
import '../utils/style.dart';

// ignore: must_be_immutable
class FlatWidget extends StatefulWidget {
  Color? _color; // card normal color
  Color? _highlightColor; // card highlight color
  final Widget? child;
  final VoidCallback? onPress;
  final VoidCallback? onLongPress;
  final double? height;
  final double width;

  FlatWidget(
      {Key? key,
      this.width = double.infinity,
      this.height = double.infinity,
      Color? color,
      Color? highlightColor,
      this.child,
      this.onPress,
      this.onLongPress})
      : super(key: key) {
    _highlightColor = highlightColor ?? AppColor.mainBackground4;
    _color = color ?? AppColor.mainBackground1;
  }

  @override
  State<StatefulWidget> createState() {
    return _FlatWidgetState();
  }
}

class _FlatWidgetState extends State<FlatWidget> {
  bool _pressed = false;

  void _updateState(bool pressed) {
    if (this.mounted) {
      setState(() {
        _pressed = pressed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? container;
    if (widget.onPress == null) {
      container = widget.child;
    } else {
      TextButton flatButton = TextButton(
        // textTheme: ButtonTextTheme.normal,
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.all(0),
          ),
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return _pressed ? widget._highlightColor : widget._color;
            } else if (states.contains(MaterialState.pressed)) {
              return Colors.transparent;
            }

            return widget._highlightColor;
          }),
        ),
        onPressed: () {
          _updateState(true);
          if (widget.onPress != null) {
            widget.onPress!();
          }
          Future.delayed(Duration(milliseconds: 50)).then((val) {
            _updateState(false);
          });
          // setState(() {
          //   _updateState(true);
          //   Future.delayed(Duration(milliseconds: 50)).then((val){
          //     if (widget.onPress != null) {
          //       widget.onPress!();
          //     }
          //     Future.delayed(Duration(milliseconds: 10)).then((val){
          //       _updateState(false);
          //     });
          //   });
          // });
        },
        onLongPress: widget.onLongPress,
        child: widget.child!,
        onFocusChange: (val) {},
      );
      container = SizedBox(
          width: double.infinity, height: double.infinity, child: flatButton);
    }

    Color? color;
    if (widget.onPress == null && widget.onLongPress == null) {
      color = widget._color;
    } else {
      color = _pressed ? widget._highlightColor : widget._color;
    }

    return Container(
        color: color,
        width: widget.width,
        height: widget.height,
        padding: EdgeInsets.all(0),
        child: container);
  }
}
