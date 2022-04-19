import 'package:flutter/material.dart';

class PageBackGroundImageWidget extends StatelessWidget {
  const PageBackGroundImageWidget({Key? key, required this.imagePath})
      : super(key: key);
  final String imagePath;
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.4,
      child: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.color),
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            fit: BoxFit.fitHeight,
            image: AssetImage(
              imagePath,
            ),
          )),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}
