import 'package:flutter/material.dart';

import '../constants/constants.dart';
import 'standart_text_widgets.dart';

class StandardPageWidget extends StatelessWidget {
  final Widget child;
  final bool showAppbar;
  final bool willPop;
  final String? appBarTitle;
  final List<Widget>? appbarActions;
  final Function? onPop;
  final Drawer? drawer;

  const StandardPageWidget({
    Key? key,
    required this.child,
    this.showAppbar = true,
    this.willPop = true,
    this.appBarTitle,
    this.appbarActions,
    this.onPop,
    this.drawer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (willPop && Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        return Future.value(false);
      },
      child: Scaffold(
        endDrawer: drawer,
        appBar: showAppbar
            ? AppBar(
                leading: (willPop && Navigator.canPop(context))
                    ? GestureDetector(
                        child: const SizedBox(
                            height: UiConstantsSize.xlarge,
                            width: UiConstantsSize.xlarge,
                            child: Icon(Icons.arrow_back)),
                        onTap: () {
                          Navigator.pop(context);
                          onPop != null ? onPop!() : () {};
                        })
                    : null,
                title: appBarTitle != null
                    ? AppbarTextWidget(text: appBarTitle!)
                    : null,
                actions: appbarActions,
              )
            : null,
        body: child,
      ),
    );
  }
}
