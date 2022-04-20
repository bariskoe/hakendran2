import '../ui/standard_widgets/standard_ui_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/todolist_model.dart';
import '../ui/constants/constants.dart';

import '../ui/standard_widgets/standart_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/allTodoLists/all_todolists_bloc.dart';

int _selectedCategoryIndex = 0;

Future<void> addListDialog(BuildContext context) async {
  TextEditingController _textEditingController = TextEditingController();
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)?.addListDialogTitle ?? 'null'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AddItemTextfieldWidget(
                textEditingController: _textEditingController),
            const SizedBox(
              height: UiConstantsPadding.xxlarge,
            ),
            Flexible(
              child: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    CategoryListWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)?.cancel ?? 'null')),
          TextButton(
            child: Text(AppLocalizations.of(context)?.ok ?? 'null'),
            onPressed: () {
              bool canPress = _textEditingController.text.isNotEmpty;
              if (canPress) {
                BlocProvider.of<AllTodolistsBloc>(context).add(
                    AllTodolistsEventCreateNewTodoList(
                        listName: _textEditingController.text,
                        todoListCategory: TodoListCategoryExtension.deserialize(
                            _selectedCategoryIndex)));
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}

class AddItemTextfieldWidget extends StatefulWidget {
  const AddItemTextfieldWidget({
    Key? key,
    required TextEditingController textEditingController,
  })  : _textEditingController = textEditingController,
        super(key: key);

  final TextEditingController _textEditingController;

  @override
  State<AddItemTextfieldWidget> createState() => _AddItemTextfieldWidgetState();
}

class _AddItemTextfieldWidgetState extends State<AddItemTextfieldWidget> {
  static bool textFieldIsEmpty = true;
  @override
  void initState() {
    textFieldIsEmpty = widget._textEditingController.text.isEmpty;
    super.initState();
  }

  @override
  void dispose() {
    textFieldIsEmpty = true;
    widget._textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget._textEditingController,
      decoration: StandardTextfieldDecoration.textFieldInputDecoration(
          errorText: textFieldIsEmpty ? 'Ein Name ist nötig' : null,
          context: context,
          labelText:
              AppLocalizations.of(context)?.addListDialogTextfieldLabel ??
                  'null'),
      onChanged: (value) {
        setState(() {
          textFieldIsEmpty = widget._textEditingController.text.isEmpty;
        });
      },
    );
  }
}

class CategorySymbol extends StatelessWidget {
  const CategorySymbol({
    Key? key,
    required this.name,
    required this.icon,
    required this.selected,
  }) : super(key: key);
  final String name;
  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(UiConstantsPadding.regular),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UiConstantsRadius.regular),
        border: Border.all(
            width: selected ? 4 : 1,
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          RegularDialogListElementText(
              text: name, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: UiConstantsPadding.small),
          Icon(icon)
        ],
      ),
    );
  }
}

class CategoryListWidget extends StatefulWidget {
  const CategoryListWidget({Key? key}) : super(key: key);

  @override
  State<CategoryListWidget> createState() => _CategoryListWidgetState();
}

class _CategoryListWidgetState extends State<CategoryListWidget> {
  static int selected = 0;
  List<Widget> categorySymbolList = [];

//filList needs a buildcontext to call getName(context). There is no buildcontext
//available in initState(), but in didChangeDependencies, there is
  @override
  void didChangeDependencies() {
    fillList();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _selectedCategoryIndex = 0;
    selected = 0;
    super.dispose();
  }

  void fillList() {
    for (TodoListCategory element in TodoListCategory.values) {
      categorySymbolList.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selected = element.index;
              _selectedCategoryIndex = element.index;

              categorySymbolList.clear();
              fillList();
            });
          },
          child: CategorySymbol(
              name: element.getName(context),
              icon: element.getIcon(),
              selected: element.serialize() == selected),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: UiConstantsPadding.large,
      runSpacing: UiConstantsPadding.large,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.spaceEvenly,
      children: categorySymbolList,
    );
  }
}
