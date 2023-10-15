import '../domain/entities/todo_entity.dart';
import '../domain/parameters/todo_parameters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/selectedTodolist_bloc/bloc/selected_todolist_bloc.dart';
import '../dependency_injection.dart';
import '../models/todo_model.dart';
import '../ui/constants/constants.dart';
import '../ui/standard_widgets/standart_text_widgets.dart';
import 'add_list_dialog.dart';

int? _selectedRepetitionPeriodIndexInEditTodoDialog;

Future<void> editTodoDialog(
  BuildContext context,
  TodoEntity todoEntity,
) async {
  TextEditingController textEditingController =
      TextEditingController(text: todoEntity.task);
  _selectedRepetitionPeriodIndexInEditTodoDialog =
      todoEntity.repeatPeriod?.serialize();
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
            AddItemTextfieldWidget(
                textEditingController: textEditingController),
            const SizedBox(
              height: UiConstantsPadding.xxlarge,
            ),
            const Flexible(
              child: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    RepetitionPeriodListWidget(),
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
              bool canPress = textEditingController.text.isNotEmpty;
              if (canPress) {
                getIt<SelectedTodolistBloc>().add(
                    SelectedTodolistEventUpdateTodo(
                        todoParameters:
                            TodoParameters.fromDomain(todoEntity).copyWith(
                                task: textEditingController.text,
                                repeatPeriod: RepeatPeriodExtension.deserialize(
                                  value:
                                      _selectedRepetitionPeriodIndexInEditTodoDialog ??
                                          0,
                                ))));
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}

class RepeatPeriodSymbol extends StatelessWidget {
  const RepeatPeriodSymbol({
    Key? key,
    required this.name,
    required this.selected,
  }) : super(key: key);
  final String name;

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
        ],
      ),
    );
  }
}

class RepetitionPeriodListWidget extends StatefulWidget {
  const RepetitionPeriodListWidget({Key? key}) : super(key: key);

  @override
  State<RepetitionPeriodListWidget> createState() =>
      _RepetitionPeriodListWidgetState();
}

class _RepetitionPeriodListWidgetState
    extends State<RepetitionPeriodListWidget> {
  static int selected = 0;
  List<Widget> repeatPeriodSymbolList = [];

  @override
  void didChangeDependencies() {
    selected = _selectedRepetitionPeriodIndexInEditTodoDialog!;
    fillList();
    super.didChangeDependencies();
  }

//It is getting complicated here. The RepetitionPeriod that had been selected when creating
//this Todolist (let's say 'daily') should be the first element in the list in order to make sure it is
//always visible, even if the keyboard is open. When a new RepetitionPeriod is selected, the
//originally selected RepetitionPeriod ('daily'), should stay the first element to avoid
//confusion. Therefor we have to put the selected 'daily' RepetitionPeriod at position 0
//when we fill the list for the first time. Then we make a copy of that list and take
//it as the base for all following list fillings. This way, the order stays the same
//while the selected item can change due to a tap.
  List<RepeatPeriod> copiedList = [];
  bool firstFill = true;
  void fillList() {
    for (RepeatPeriod element in firstFill ? RepeatPeriod.values : copiedList) {
      bool isSelectedSymbol = element.serialize() == selected;
      repeatPeriodSymbolList.insert(
        isSelectedSymbol && firstFill ? 0 : repeatPeriodSymbolList.length,
        GestureDetector(
          onTap: () {
            setState(() {
              selected = element.index;
              _selectedRepetitionPeriodIndexInEditTodoDialog = element.index;

              repeatPeriodSymbolList.clear();
              fillList();
            });
          },
          child: RepeatPeriodSymbol(
              name: element.getName(context),
              selected: element.serialize() == selected),
        ),
      );
      //Create the new list only when the repeatPeriodSymbolList is filled for the first
      //time. It makes sure the order of the element stays the same when new repeatPeriods
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
      children: repeatPeriodSymbolList,
    );
  }
}
