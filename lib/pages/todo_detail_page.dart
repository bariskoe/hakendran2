import '../ui/standard_widgets/error_box_widget.dart';
import 'package:great_list_view/great_list_view.dart';
import 'package:logger/logger.dart';

import '../assets.dart';
import '../dialogs/edit_todo_dialog.dart';
import '../models/todolist_model.dart';
import '../ui/widgets/page_background_image_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animations/loading_animations.dart';

import '../bloc/selectedTodolist_bloc/bloc/selected_todolist_bloc.dart';

import '../models/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../dialogs/add_todo_dialog.dart';

import '../ui/constants/constants.dart';
import '../ui/standard_widgets/standard_page_widget.dart';
import '../ui/standard_widgets/standard_ui_widgets.dart';
import '../ui/standard_widgets/standart_text_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TodoListDetailPage extends StatefulWidget {
  const TodoListDetailPage({
    Key? key,
  }) : super(key: key);

//The SelectedTodoLIstBloc sets justAddedTodo to true when an AddTodo event
  //comes in
  static bool justAddedTodo = false;
  @override
  State<TodoListDetailPage> createState() => _TodoListDetailPageState();
}

class _TodoListDetailPageState extends State<TodoListDetailPage> {
  String nameOfList = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedTodolistBloc, SelectedTodolistState>(
      //Don't build if a List Element has just been dismissed. That part is taken
      //care of by the dismissibe Widget
      buildWhen: (previous, current) =>
          !(((current is SelectedTodolistStateLoaded) &&
                  (previous is SelectedTodolistStateLoaded)) &&
              (current.todoListModel.numberOfTodos <
                  previous.todoListModel.numberOfTodos)),
      builder: (context, state) {
        if (state is SelectedTodoListStateLoading) {
          _buildLoading(context);
        }

        if (state is SelectedTodolistStateLoaded) {
          return _buildListLoaded(state, context);
        }
        return const ErrorBoxWidget();
      },
    );
  }
}

_buildLoading(BuildContext context) {
  return Center(
      child: LoadingBouncingGrid.square(
    backgroundColor: Theme.of(context).colorScheme.primary,
  ));
}

_buildListLoaded(SelectedTodolistStateLoaded state, BuildContext context) {
  Logger().d('buildListLoaded wird durchgeführt');
  return StandardPageWidget(
    onPop: () {
      BlocProvider.of<SelectedTodolistBloc>(context)
          .add(SelectedTodolistEventUnselect());
    },
    appBarTitle: state.todoListModel.listName,
    child: Stack(
      children: [
        PageBackGroundImageWidget(
            imagePath:
                state.todoListModel.todoListCategory.getBackgroundImage()),
        DetailPageListWidget(state: state),
        FABrowOfDetailPage(state: state),
      ],
    ),
  );
}

class DetailPageListWidget extends StatefulWidget {
  const DetailPageListWidget({Key? key, required this.state}) : super(key: key);

  final SelectedTodolistStateLoaded state;

  static bool justDismissedTodo = false;

  @override
  State<DetailPageListWidget> createState() => _DetailPageListWidgetState();
}

class _DetailPageListWidgetState extends State<DetailPageListWidget>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  final animatedListcontroller = AnimatedListController();

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation =
        CurvedAnimation(parent: _controller!, curve: Curves.linearToEaseOut);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (TodoListDetailPage.justAddedTodo) {
      _controller?.reset();
      _controller?.forward().then((value) {
        TodoListDetailPage.justAddedTodo = false;
      });
    }
    List<TodoModel> list = widget.state.todoListModel.todoModels;
    //Sorts the list by property 'accomplished'
    list.sort(((a, b) => b.accomplished ? 1 : -1));
    //Reverse the list in order to move the accomplished tasks to the bottom of the list
    //add an empty TodoModel at the end in order to extend the length of the list by 1,
    //so that an invisible container with a height of 100 can be added.
    List<TodoModel> reversedList = List.from(list.reversed)
      ..add(TodoModel(id: null, task: '', accomplished: false));

    return Padding(
      padding: const EdgeInsets.all(UiConstantsPadding.regular),
      child: AutomaticAnimatedListView<TodoModel>(
        comparator: AnimatedListDiffListComparator<TodoModel>(
            sameItem: (a, b) => a.id == b.id,
            sameContent: (a, b) => a.accomplished == b.accomplished),

        listController: animatedListcontroller,
        list: reversedList, //widget.state.todoListModel.todoModels,
        itemBuilder: ((context, model, data) {
          //Put an invisible Container to the end of the list so that the Floating
          //Action Buttons don't disturb when scrolled down to the end
          if (reversedList.indexOf(model) == reversedList.length - 1) {
            return Container(
              height: 100,
            );
          } else {
            return data.measuring
                ? Container(height: 60)
                : GestureDetector(
                    onLongPress: () {
                      editTodoDialog(context, model);
                    },
                    child: Dismissible(
                      onDismissed: (direction) {
                        DetailPageListWidget.justDismissedTodo = true;
                        //This is necessary to avoid the AutomaticAnimatedListView to build the
                        //List with the old reversedList immediately before rebuilding it with
                        //the new reversedList

                        reversedList
                            .removeWhere((element) => element.id == model.id);
                        BlocProvider.of<SelectedTodolistBloc>(context).add(
                            SelectedTodolistEventDeleteSpecificTodo(
                                id: model.id!));
                      },
                      key: UniqueKey(),
                      background: const SwipeToDeleteBackgroundWidget(),
                      child: reversedList.indexOf(model) == 0 &&
                              TodoListDetailPage.justAddedTodo
                          ? SizeTransition(
                              sizeFactor: _animation!,
                              axis: Axis.vertical,
                              child: ListElement(model: model),
                            )
                          : ListElement(model: model),
                    ));
          }
        }),
      ),
    );
  }
}

class ListElement extends StatelessWidget {
  const ListElement({
    Key? key,
    required this.model,
  }) : super(key: key);

  final TodoModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UiConstantsPadding.xlarge),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: UiConstantsPadding.xlarge),
        height: UiConstantsSize.xxlarge,
        decoration: StandardUiWidgets.standardBoxDecoration(
            context,
            model.accomplished
                ? UiConstantsColors.allAccomplishedGradientColors
                : [
                    Theme.of(context).colorScheme.secondaryContainer,
                    Theme.of(context).colorScheme.secondary,
                  ],
            false),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(flex: 4, child: BigListElementText(text: model.task)),
              Flexible(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    BlocProvider.of<SelectedTodolistBloc>(context).add(
                      SelectedTodolistEventUpdateAccomplishedOfTodo(
                        id: model.id!,
                        accomplished: !model.accomplished,
                      ),
                    );
                  },
                  child: CheckBoxWidget(model: model),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CheckBoxWidget extends StatelessWidget {
  const CheckBoxWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  final TodoModel model;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                    Radius.circular(UiConstantsRadius.regular)),
                border: Border.all(color: Colors.white, width: 2)),
            height: UiConstantsSize.small,
            width: UiConstantsSize.small,
          ),
        ),
        if (model.accomplished) ...[
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              ImageAssets.blueCheckmark,
              height: UiConstantsSize.xxlarge,
              color: Colors.green,
              placeholderBuilder: (BuildContext context) => Container(
                  padding: const EdgeInsets.all(UiConstantsPadding.regular),
                  child: const CircularProgressIndicator()),
            ),
          )
        ]
      ],
    );
  }
}

class SwipeToDeleteBackgroundWidget extends StatelessWidget {
  const SwipeToDeleteBackgroundWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: WarningTextWidget(
      text: AppLocalizations.of(context)?.swipeToDelete ?? 'null',
    ));
  }
}

class FABrowOfDetailPage extends StatelessWidget {
  const FABrowOfDetailPage({
    Key? key,
    required this.state,
  }) : super(key: key);

  final SelectedTodolistStateLoaded state;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        if (state.todoListModel.atLeastOneAccomplished) ...[
          Padding(
            padding: const EdgeInsets.all(UiConstantsPadding.xlarge),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                  heroTag: const Text('button3'),
                  child: const Icon(Icons.refresh),
                  onPressed: () {
                    BlocProvider.of<SelectedTodolistBloc>(context).add(
                      const SelectedTodoListEventResetAll(),
                    );
                  }),
            ),
          )
        ],
        Padding(
          padding: const EdgeInsets.all(UiConstantsPadding.xlarge),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              heroTag: const Text('button4'),
              child: const Icon(Icons.add),
              onPressed: () => addTodoDialog(
                context: context,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
