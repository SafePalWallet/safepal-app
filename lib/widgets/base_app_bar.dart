import 'package:flutter/material.dart';
import '../utils/style.dart';

class BaseAppBar extends AppBar {
  static BaseAppBar appBar({
    Key? key,
    Widget? title,
    List<Widget>? leadings,
    List<Widget>? actions,
    Widget? flexibleSpace,
    Color? backgroundColor,
    PreferredSizeWidget? bottom,
    bool centerTitle = true,
  }) {
    backgroundColor = backgroundColor ?? AppColor.mainBackground1;
    if (title is Text && title.data!=null) {
      Text text = title;
      if (text.style == null) {
        title = Text(
          text.data!,
          style: AppTextStyle.titleStyle,
        );
      }
    }

    Widget? titleWidget = title;
    Widget? leading;
    if (leadings != null && leadings.length > 1) {
      List<Widget> children = [];
      if (leadings != null) {
        children.addAll(leadings);
      }

      children.add(Expanded(child: Container()));
      if(actions!=null && actions.isNotEmpty){
        children.addAll(actions);
      }
      actions = null;
      titleWidget = Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: children,
          ),
          title??Container()
        ],
      );
    } else if (leadings != null && leadings.isNotEmpty){
      leading = leadings.first;
    }

    return BaseAppBar(
      key: key,
      leading: leading,
      title: titleWidget,
      actions: actions,
      flexibleSpace: flexibleSpace,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      bottom: bottom
    );
  }

  BaseAppBar({
    Key? key,
    Widget? title,
    Widget? leading,
    List<Widget>? actions,
    Widget? flexibleSpace,
    Color? backgroundColor,
    PreferredSizeWidget? bottom,
    bool centerTitle = true,
  }) :
        super(
          key: key,
          title: title,
          leading:leading,
          actions : actions,
          flexibleSpace : flexibleSpace,
          elevation: 0,
          bottomOpacity: (bottom != null) ? 1.0 : 0.0,
          backgroundColor: backgroundColor,
          centerTitle: centerTitle,
          automaticallyImplyLeading:false,
          titleSpacing: 0.0,
          bottom:bottom
      );

  @override
  Size get preferredSize {
    return Size.fromHeight(50.0 + (bottom?.preferredSize.height ?? 0.0));
  }
}