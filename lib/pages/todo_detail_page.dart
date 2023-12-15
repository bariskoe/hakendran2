import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:great_list_view/great_list_view.dart';
import 'package:logger/logger.dart';
import 'package:popover/popover.dart';

import '../assets.dart';
import '../bloc/allTodoLists/all_todolists_bloc.dart';
import '../bloc/photo/photo_bloc.dart';
import '../bloc/selectedTodolist_bloc/bloc/selected_todolist_bloc.dart';
import '../dependency_injection.dart';
import '../dialogs/add_todo_dialog.dart';
import '../dialogs/edit_todo_dialog.dart';
import '../domain/entities/todo_entity.dart';
import '../domain/parameters/take_thumbnail_photo_params.dart';
import '../domain/parameters/todo_parameters.dart';
import '../domain/parameters/update_todo_parameters.dart';
import '../models/todolist_model.dart';
import '../ui/constants/constants.dart';
import '../ui/standard_widgets/error_box_widget.dart';
import '../ui/standard_widgets/standard_page_widget.dart';
import '../ui/standard_widgets/standard_ui_widgets.dart';
import '../ui/standard_widgets/standart_text_widgets.dart';
import '../ui/widgets/page_background_image_widget.dart';

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
    return Stack(
      children: [
        BlocBuilder<SelectedTodolistBloc, SelectedTodolistState>(
          // Don't build if a List Element has just been dismissed. That part is taken
          // care of by the dismissibe Widget
          buildWhen: (previous, current) =>
              //     ((((current is SelectedTodolistStateLoaded) &&
              //             (previous is SelectedTodolistStateLoaded)) &&
              //         !(current.todoListModel.numberOfTodos <
              //             previous.todoListModel.numberOfTodos))),
              //         &&
              (current != SelectedTodoListStateLoading()),

          builder: (context, state) {
            if (state is SelectedTodolistStateError) {
              return _buildError(context);
            }

            if (state is SelectedTodolistStateLoaded) {
              return _buildListLoaded(state, context);
            }

            return Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
            );
          },
        ),
      ],
    );
  }
}

_buildError(BuildContext context) {
  return const Center(child: ErrorBoxWidget());
}

Widget _buildListLoaded(
    SelectedTodolistStateLoaded state, BuildContext context) {
  return StandardPageWidget(
    onPop: () {
      getIt<SelectedTodolistBloc>().add(SelectedTodolistEventUnselect());
      getIt<AllTodolistsBloc>().add(AllTodolistsEventGetAllTodoLists());
    },
    appBarTitle: state.todoListEntity.listName,
    child: Stack(
      children: [
        PageBackGroundImageWidget(
            imagePath:
                state.todoListEntity.todoListCategory.getBackgroundImage()),
        DetailPageListWidget(state: state),
        FABrowOfDetailPage(loadedState: state),
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
    List<TodoEntity> list = widget.state.todoListEntity.todoEntities;
    //Sorts the list by property 'accomplished'
    list.sort(((a, b) => b.accomplished ? 1 : -1));
    //Reverse the list in order to move the accomplished tasks to the bottom of the list
    //add an empty TodoEntity at the end in order to extend the length of the list by 1,
    //so that an invisible container with a height of 100 can be added.
    List<TodoEntity> reversedList = List.from(list.reversed)
      ..add(TodoEntity.empty());
    // TodoEntity(
    //     uid: 'h4398rzirf',
    //     task: '',
    //     accomplished: false,
    //     parentTodoListId: 'Test'));

    return Padding(
      padding: const EdgeInsets.all(UiConstantsPadding.regular),
      child: AutomaticAnimatedListView<TodoEntity>(
        comparator: AnimatedListDiffListComparator<TodoEntity>(
          sameItem: (a, b) => a.uid == b.uid,
          sameContent: (a, b) =>
              a.accomplished == b.accomplished &&
              a.task == b.task &&
              a.thumbnailImageName == b.thumbnailImageName,
        ),
        listController: animatedListcontroller,
        list: reversedList,
        itemBuilder: ((context, todoEntity, data) {
          //Put an invisible Container to the end of the list so that the Floating
          //Action Buttons don't disturb when scrolled down to the end
          if (reversedList.indexOf(todoEntity) == reversedList.length - 1) {
            return SizedBox(
              height: 100,
            );
          } else {
            return data.measuring
                ? Container(height: 60)
                : GestureDetector(
                    onLongPress: () {
                      editTodoDialog(context, todoEntity);
                    },
                    child: Dismissible(
                      onDismissed: (direction) {
                        DetailPageListWidget.justDismissedTodo = true;
                        //This is necessary to avoid the AutomaticAnimatedListView to build the
                        //List with the old reversedList immediately before rebuilding it with
                        //the new reversedList

                        reversedList.removeWhere(
                            (element) => element.uid == todoEntity.uid);
                        getIt<SelectedTodolistBloc>().add(
                            SelectedTodolistEventDeleteSpecificTodo(
                                todoParameters:
                                    TodoParameters.fromDomain(todoEntity)));
                      },
                      key: UniqueKey(),
                      background: const SwipeToDeleteBackgroundWidget(),
                      child: reversedList.indexOf(todoEntity) == 0 &&
                              TodoListDetailPage.justAddedTodo
                          ? SizeTransition(
                              sizeFactor: _animation!,
                              axis: Axis.vertical,
                              child: ListElement(todoEntity: todoEntity),
                            )
                          : ListElement(todoEntity: todoEntity),
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
    required this.todoEntity,
  }) : super(key: key);

  final TodoEntity todoEntity;

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
            todoEntity.accomplished
                ? UiConstantsColors.allAccomplishedGradientColors
                : [
                    Theme.of(context).colorScheme.secondaryContainer,
                    Theme.of(context).colorScheme.secondary,
                  ],
            false),
        child: Align(
          //alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 4, child: BigListElementText(text: todoEntity.task)),
              Flexible(
                flex: 1,
                child: ImageThumbnailWidget(todoEntity: todoEntity),
              ),
              Flexible(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    getIt<SelectedTodolistBloc>().add(
                      SelectedTodolistEventUpdateAccomplishedOfTodo(
                        uid: todoEntity.uid!,
                        accomplished: !todoEntity.accomplished,
                      ),
                    );
                  },
                  child: CheckBoxWidget(todoEntity: todoEntity),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ImageThumbnailWidget extends StatelessWidget {
  const ImageThumbnailWidget({
    Key? key,
    required this.todoEntity,
  }) : super(key: key);

  final TodoEntity todoEntity;

  @override
  Widget build(BuildContext context) {
    Logger().d('TodoEntity ist: $todoEntity');
    return FutureBuilder(
      future: todoEntity.getFullImagePath,
      builder: (context, snapshot) => GestureDetector(
        onTap: () async {
          if (snapshot.hasData) {
            showPopover(
              context: context,
              //constraints: BoxConstraints.loose(Size(300, 300)),
              constraints: const BoxConstraints(
                  minWidth: 200, maxWidth: 300, minHeight: 200, maxHeight: 400),
              radius: UiConstantsRadius.regular,
              bodyBuilder: (context) => IntrinsicHeight(
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Image.file(
                          File(snapshot.data!),
                          fit: BoxFit.contain,
                        ),
                      ),
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                              getIt<PhotoBloc>().add(
                                  PhotoEventSetSelectedThumbnailPhoto(
                                      fullImagePath: snapshot.data!));
                              getIt<PhotoBloc>().add(
                                  PhotoEventTakeThumbnailPicture(
                                      takeThumbnailPhotoParams:
                                          TakeThumbnailPhotoParams(
                                              todoId: todoEntity.uid!)));
                            },
                            child: const SizedBox(
                                height: 50, child: Icon(Icons.edit_outlined)),
                          ),
                        ),
                        Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  Get.back();
                                  getIt<SelectedTodolistBloc>().add(
                                      SelectedTodolistEventUpdateTodo(
                                          updateTodoModelParameters:
                                              UpdateTodoModelParameters
                                                      .fromDomain(
                                                          todoEntity:
                                                              todoEntity)
                                                  .copyWith(
                                                      deleteImagePath: true)));

                                  getIt<PhotoBloc>().add(
                                      PhotoEventSetSelectedThumbnailPhoto(
                                          fullImagePath: snapshot.data!));
                                  getIt<PhotoBloc>().add(
                                      PhotoEventDeleteThumbnailPhotoFromGallery());
                                },
                                child: const SizedBox(
                                    height: 50,
                                    child: Icon(Icons.delete_outline))))
                      ])
                    ],
                  ),
                ),
              ),
              onPop: () => print('Popover was popped!'),
              direction: PopoverDirection.bottom,
              // width: 300,
              // height: 300,
              arrowHeight: 15,
              arrowWidth: 30,
            );
          } else {
            getIt<PhotoBloc>().add(PhotoEventTakeThumbnailPicture(
                takeThumbnailPhotoParams:
                    TakeThumbnailPhotoParams(todoId: todoEntity.uid!)));
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
                Radius.circular(UiConstantsRadius.regular)),
            border: Border.all(color: Colors.white, width: 2),
          ),
          height: UiConstantsSize.small,
          width: UiConstantsSize.small,
          child: snapshot.hasData
              ? ClipRRect(
                  borderRadius: BorderRadius.all(
                      Radius.circular(UiConstantsRadius.regular)),
                  clipBehavior: Clip.hardEdge,
                  child: Image.file(
                    File(snapshot.data!),
                    fit: BoxFit.fill,
                  ),
                )
              : snapshot.hasError
                  ? const Icon(Icons.camera_alt_outlined)
                  : const Icon(Icons.camera_alt_outlined),
        ),
      ),
    );
  }
}

class CheckBoxWidget extends StatelessWidget {
  const CheckBoxWidget({
    Key? key,
    required this.todoEntity,
  }) : super(key: key);

  final TodoEntity todoEntity;

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
        if (todoEntity.accomplished) ...[
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              ImageAssets.blueCheckmark,
              height: UiConstantsSize.xxlarge,
              colorFilter:
                  ColorFilter.mode(Colors.green.shade500, BlendMode.srcIn),
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
    required this.loadedState,
  }) : super(key: key);

  final SelectedTodolistStateLoaded loadedState;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedTodolistBloc, SelectedTodolistState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (state is SelectedTodolistStateLoaded &&
                state.todoListEntity.atLeastOneAccomplished) ...[
              Padding(
                padding: const EdgeInsets.all(UiConstantsPadding.xlarge),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                      heroTag: const Text('button3'),
                      child: const Icon(
                        Icons.refresh,
                        color: UiConstantsColors.iconOnDark,
                      ),
                      onPressed: () {
                        getIt<SelectedTodolistBloc>().add(
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
                  child: const Icon(
                    Icons.add,
                    color: UiConstantsColors.iconOnDark,
                  ),
                  onPressed: () => addTodoDialog(
                    context: context,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
