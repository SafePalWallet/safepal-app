import 'package:flutter/material.dart';

import '../utils/style.dart';

class CardWidget extends StatefulWidget {
  Color? color; // card normal color
  Color? highlightColor; // card highlight color
  Color? backgroundColor; // widet background color
  final Widget? child;
  final VoidCallback? onPress;
  final VoidCallback? onLongPress;
  final double height;
  final double width;
  final EdgeInsetsGeometry? padding;
  final bool enableBorderRadius;

  CardWidget({
    Key? key,
    this.width = double.infinity,
    this.height = double.infinity,
    this.padding = const EdgeInsets.only(left: 8, right: 8, bottom: 5),
    this.enableBorderRadius = true,
    this.color,
    this.highlightColor,
    this.backgroundColor,
    this.child,
    this.onPress,
    this.onLongPress
  }) : super(key:key){
    this.color=this.color ?? AppColor.mainBackground2;
    this.highlightColor=this.highlightColor??AppColor.mainBackground4;
    this.backgroundColor=this.backgroundColor??AppColor.mainBackground1;
  }

  @override
  State<StatefulWidget> createState() {
    return _CardWidgetState();
  }
}

class _CardWidgetState extends State<CardWidget> {
  bool _pressed = false;

  BorderRadius borderRadius = BorderRadius.all(Radius.circular(6.0));

  void _updateState(bool pressed) {
    if (this.mounted) {
      setState(() {
        _pressed = pressed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var createContainer = (Widget? child){
      Widget result = Container(
          decoration: BoxDecoration(
              color: _pressed ? widget.highlightColor : widget.color,
              borderRadius: widget.enableBorderRadius ? borderRadius : BorderRadius.all(Radius.zero)
          ),
          child: child
      );
      return result;
    };
    Widget container;
    if (widget.onPress == null) {
      container = createContainer(widget.child);
    } else {
      FlatButton flatButton = FlatButton(
        padding: EdgeInsets.all(0),
        highlightColor: widget.highlightColor,
        hoverColor: _pressed ? widget.highlightColor : widget.color,
        splashColor: Colors.transparent,
        onPressed:(){
          setState(() {
            _updateState(true);
            if (widget.onPress != null) {
              widget.onPress!();
            }
            Future.delayed(Duration(milliseconds: 50)).then((val){
                  _updateState(false);
            });
          });
        },
        onLongPress: widget.onLongPress,
        child: widget.child!,
        onHighlightChanged: (val){
        },
      );

      Widget sizedBox = SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: flatButton
      );
      container = createContainer(sizedBox);
    }

    return Container(
      color: widget.backgroundColor,
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      child: container
    );
  }
}
