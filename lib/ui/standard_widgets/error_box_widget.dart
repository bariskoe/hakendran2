import '../../assets.dart';
import '../constants/constants.dart';
import 'standard_ui_widgets.dart';
import 'standart_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';

class ErrorBoxWidget extends StatefulWidget {
  const ErrorBoxWidget({Key? key}) : super(key: key);

  @override
  State<ErrorBoxWidget> createState() => _ErrorBoxWidgetState();
}

class _ErrorBoxWidgetState extends State<ErrorBoxWidget> {
  bool startAnimation = false;
  int animationDuration = 20;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        startAnimation = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        decoration: StandardUiWidgets.standardBoxDecoration(context,
            [Colors.white, Colors.white], true, ImageAssets.zerosAndOnes),
        height: UiConstantsSize.xxxlarge,
        width: UiConstantsSize.xxxlarge,
        child: Stack(
          children: [
            Center(
              child: BigHeaderTextWidget(
                text:
                    AppLocalizations.of(context)?.somethingWentWrong ?? 'null',
              ),
            ),
            AnimatedAlign(
              duration: Duration(seconds: animationDuration),
              alignment:
                  startAnimation ? Alignment.topLeft : Alignment.bottomRight,
              child: const BugImage(),
            ),
            RotatedBox(
                quarterTurns: 2,
                child: AnimatedAlign(
                    duration: Duration(seconds: animationDuration),
                    alignment: startAnimation
                        ? Alignment.topLeft
                        : Alignment.bottomRight,
                    child: const BugImage())),
          ],
        ),
      ),
    );
  }
}

class BugImage extends StatelessWidget {
  const BugImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: UiConstantsSize.xlarge,
        width: UiConstantsSize.xlarge,
        child: Opacity(
          opacity: 0.3,
          child: ColorFiltered(
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.saturation),
              child: SvgPicture.asset(ImageAssets.blueBug)),
        ));
  }
}
