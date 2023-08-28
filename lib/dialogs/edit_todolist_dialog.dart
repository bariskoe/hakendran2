import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../bloc/allTodoLists/all_todolists_bloc.dart';
import '../dependency_injection.dart';
import '../models/todolist_model.dart';
import '../ui/constants/constants.dart';
import '../ui/standard_widgets/standard_ui_widgets.dart';
import '../ui/standard_widgets/standart_text_widgets.dart';

int? _selectedCategoryIndexInEditListDialog;

Future<void> editListDialog(
  BuildContext context,
  TodoListModel todoListModel,
) async {
  TextEditingController textEditingController =
      TextEditingController(text: todoListModel.listName);
  _selectedCategoryIndexInEditListDialog =
      todoListModel.todoListCategory.serialize();
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
            AppLocalizations.of(context)?.editTodoListDialogTitle ?? 'null'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textEditingController,
              decoration: StandardTextfieldDecoration.textFieldInputDecoration(
                  context: context,
                  labelText: AppLocalizations.of(context)
                          ?.editTodoListDialogTextfieldLabel ??
                      'null'),
            ),
            const SizedBox(
              height: UiConstantsPadding.xxlarge,
            ),
            const Flexible(
              child: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    CategoryListWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () => Get.back(),
              child: Text(AppLocalizations.of(context)?.cancel ?? 'null')),
          TextButton(
            child: Text(AppLocalizations.of(context)?.ok ?? 'null'),
            onPressed: () {
              bool canPress = textEditingController.text.isNotEmpty;
              if (canPress) {
                getIt<AllTodolistsBloc>()
                    .add(AllTodoListEventUpdateListParameters(
                  uuid: todoListModel.uuid!,
                  listName: textEditingController.text,
                  todoListCategory: TodoListCategoryExtension.deserialize(
                      _selectedCategoryIndexInEditListDialog!),
                ));

                Get.back();
              }
            },
          ),
        ],
      );
    },
  );
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

  @override
  void didChangeDependencies() {
    selected = _selectedCategoryIndexInEditListDialog!;
    fillList();
    super.didChangeDependencies();
  }

//It is getting complicated here. The category that had been selected when creating
//this Todolist (let's say 'friends') should be the first element in the list in order to make sure it is
//always visible, even if the keyboard is open. When a new category is selected, the
//originally selected category ('friends'), should stay the first element to avoid
//confusion. Therefor we have to put the selected 'friends' category at position 0
//when we fill the list for the first time. Then we make a copy of that list and take
//it as the base for all following list fillings. This way, the order stays the same
//while the selected item can change due to a tap.
  List<TodoListCategory> copiedList = [];
  bool firstFill = true;
  void fillList() {
    for (TodoListCategory element
        in firstFill ? TodoListCategory.values : copiedList) {
      bool isSelectedSymbol = element.serialize() == selected;
      categorySymbolList.insert(
        isSelectedSymbol && firstFill ? 0 : categorySymbolList.length,
        GestureDetector(
          onTap: () {
            setState(() {
              selected = element.index;
              _selectedCategoryIndexInEditListDialog = element.index;

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
      //Create the new list only when the categorySymbolList is filled for the first
      //time. It makes sure the order of the element stays the same when new categories
      //are selected.
      if (firstFill) {
        copiedList.insert(
            isSelectedSymbol && firstFill ? 0 : copiedList.length, element);
      }
    }
    firstFill = false;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: UiConstantsPadding.large,
      runSpacing: UiConstantsPadding.large,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.start,
      children: categorySymbolList,
    );
  }
}
