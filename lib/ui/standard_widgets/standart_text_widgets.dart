import 'package:flutter/material.dart';

import '../constants/constants.dart';

class AppbarTextWidget extends StatelessWidget {
  final String text;

  const AppbarTextWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}

class BigListElementText extends StatelessWidget {
  const BigListElementText({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          fontFamily: 'Handlee',
          fontWeight: FontWeight.w600,
          fontSize: UiConstantsFontSize.huge,
          letterSpacing: 1.5,
          overflow: TextOverflow.ellipsis),
    );
  }
}

class RegularDialogListElementText extends StatelessWidget {
  const RegularDialogListElementText({
    Key? key,
    required this.text,
    this.color,
  }) : super(key: key);
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          //fontFamily: 'Handlee',
          fontWeight: FontWeight.w600,
          letterSpacing: 1.5,
          color: color ?? Theme.of(context).colorScheme.onPrimaryContainer,
          fontSize: UiConstantsFontSize.regular),
    );
  }
}

class WarningTextWidget extends StatelessWidget {
  const WarningTextWidget(
      {Key? key, required this.text, this.fontsize = UiConstantsFontSize.huge})
      : super(key: key);
  final String text;
  final double fontsize;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: Theme.of(context).colorScheme.error, fontSize: fontsize),
    );
  }
}

class BigHeaderTextWidget extends StatelessWidget {
  const BigHeaderTextWidget({Key? key, required this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: UiConstantsFontSize.xlarge),
    );
  }
}
