import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/selectedTodolist_bloc/bloc/selected_todolist_bloc.dart';
import '../models/todo_model.dart';
import '../ui/constants/constants.dart';
import '../ui/standard_widgets/standart_text_widgets.dart';
import 'add_list_dialog.dart';

int _selectedRepeatPeriodIndex = 0;

Future<void> addTodoDialog({
  required BuildContext context,
}) async {
  TextEditingController _textEditingController = TextEditingController();
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)?.addTodoDialogTitle ?? 'null'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AddItemTextfieldWidget(
                textEditingController: _textEditingController),
            // TextField(
            //   controller: _textEditingController,
            //   decoration: StandardTextfieldDecoration.textFieldInputDecoration(
            //       context: context,
            //       labelText: AppLocalizations.of(context)
            //               ?.addTodoDialogTextfieldLabel ??
            //           'null'),
            // ),
            const SizedBox(
              height: UiConstantsPadding.xxlarge,
            ),
            Flexible(
              child: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    RepeatPeriodListWidget(),
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
                BlocProvider.of<SelectedTodolistBloc>(context).add(
                  SelectedTodolistEventAddNewTodo(
                    todoModel: TodoModel(
                      id: null,
                      accomplished: false,
                      task: _textEditingController.text,
                      parentTodoListId: 123456,
                      repeatPeriod: RepeatPeriodExtension.deserialize(
                          value: _selectedRepeatPeriodIndex),
                    ),
                  ),
                );

                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}

class RepeatPeriodListWidget extends StatefulWidget {
  const RepeatPeriodListWidget({Key? key}) : super(key: key);

  @override
  State<RepeatPeriodListWidget> createState() => _RepeatPeriodListWidgetState();
}

class _RepeatPeriodListWidgetState extends State<RepeatPeriodListWidget> {
  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    for (RepeatPeriod repeatPeriod in RepeatPeriod.values) {
      list.add(GestureDetector(
        onTap: () {
          setState(() {
            _selectedRepeatPeriodIndex = repeatPeriod.index;
          });
        },
        child: RepeatPeriodListElement(
            periodName: repeatPeriod.getName(context),
            selected: repeatPeriod.index == _selectedRepeatPeriodIndex),
      ));
    }

    return Wrap(
      spacing: UiConstantsPadding.large,
      runSpacing: UiConstantsPadding.large,
      alignment: WrapAlignment.start,
      children: list,
    );
  }
}

class RepeatPeriodListElement extends StatelessWidget {
  const RepeatPeriodListElement({
    Key? key,
    required this.periodName,
    required this.selected,
  }) : super(key: key);
  final String periodName;

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
              text: periodName, color: Theme.of(context).colorScheme.primary),
        ],
      ),
    );
  }
}
