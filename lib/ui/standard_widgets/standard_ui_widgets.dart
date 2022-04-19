import 'package:flutter/material.dart';

import '../constants/constants.dart';

class StandardUiWidgets {
  static standardBoxDecoration(BuildContext context,
      [List<Color>? gradientcolors, bool shadowOn = true, String? imagePath]) {
    return BoxDecoration(
        image: imagePath != null
            ? DecorationImage(
                image: AssetImage(imagePath), fit: BoxFit.cover, opacity: 0.1)
            : null,
        gradient: LinearGradient(
            colors: gradientcolors ??
                [
                  Theme.of(context).colorScheme.secondaryContainer,
                  Theme.of(context).colorScheme.primary,
                ]),
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(UiRadius.regular),
        boxShadow: shadowOn ? standardBoxShadow() : []);
  }

  static standardBoxShadow() {
    return [
      BoxShadow(
          blurRadius: 5,
          color: Colors.black.withOpacity(0.5),
          offset: const Offset(5, 3))
    ];
  }
}

class StandardTextfieldDecoration {
  const StandardTextfieldDecoration._();

  static InputDecoration textFieldInputDecoration({
    final String? hintText,
    final String? labelText,
    final String? errorText,
    required final BuildContext context,
    final TextEditingController? textEditingController,
    final Color? fillColor,
    final bool? showSuffixIcon = false,
  }) {
    return InputDecoration(
      contentPadding: const EdgeInsets.only(
        left: UiPadding.large,
      ),
      //suffixIconConstraints: const BoxConstraints.tightFor(
      //  width: UiSize.mini,
      //  height: UiSize.mini,
      //),
      suffixIcon: showSuffixIcon ?? false
          ? Center(
              child: Material(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(UiSize.mini),
                color: Theme.of(context).colorScheme.primary,
                child: InkWell(
                  onTap: textEditingController?.clear,
                  child: Center(
                    child: Icon(
                      Icons.backspace,
                      size: UiSize.tiny,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ),
            )
          : null,
      labelStyle: TextStyle(
        // fontFamily: ,
        fontSize: 16.0,
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w500,
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(UiRadius.regular),
        ),
      ),
      hintText: hintText,
      labelText: labelText ?? hintText,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      errorText: errorText,
      fillColor: fillColor ?? Theme.of(context).colorScheme.surface,
      filled: true,
    );
  }
}
