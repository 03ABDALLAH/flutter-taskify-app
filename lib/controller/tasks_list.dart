import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:remember_app/controller/add_task_bar.dart';
import 'package:remember_app/component/button.dart';
import 'package:remember_app/notification/notification_services.dart';
import 'package:remember_app/controller/task_controller.dart';
import 'package:remember_app/constant/theme_services.dart';
import 'package:remember_app/constant/themes.dart';

import '../model/task_data.dart';
import 'category_controller.dart';
import 'task_tile.dart';

class TaskLists extends StatefulWidget {
  TaskLists({this.categoryId});

  var categoryId;

  @override
  _TaskListsState createState() => _TaskListsState();
}

class _TaskListsState extends State<TaskLists> {
  late final NotifyHelper notifyHelper;
  DateTime _selectedDate = DateTime.now();
  final _categoryController = Get.put(CategoryController());
  final _taskController = Get.put(TaskController());

  @override
  void initState() {
    // TODO: implement initState
    _categoryController.getCategoryTasks(widget.categoryId);
    print("widget id: ${widget.categoryId}");
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          SizedBox(height: 15),
          _addDateBar(),
          SizedBox(height: 15),
          // _generateTasks(),
          _showTasks(),
          // _showAllTasks()
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          ThemeServices().switchTheme();
          // Get.back(result: true);
          // Get.snackbar('title', 'message');
          // notifyHelper.displayNotification(title: "hehehe", body: "hehehe");
          // notifyHelper.scheduledNotification();
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        const CircleAvatar(
          backgroundImage: AssetImage(
            "img/icon.png",
          ),
        ),
        const SizedBox(
          width: 15,
        )
      ],
    );
  }

  _addTaskBar() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingstyle,
                ),
              ],
            ),
          ),
          MyButton(
              label: "+ Add Task",
              onTap: () async {
                // print(_taskController.taskList[3].toJson());
                await Get.to(
                    () => AddTaskPage(id: null, categoryId: widget.categoryId));
                print("from homepage id is ${widget.categoryId}");
                _categoryController.getCategoryTasks(widget.categoryId);
              }),
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _categoryController.categoryTasks.length,
            itemBuilder: (_, index) {
              Task task = _categoryController.categoryTasks[index];
              print("inside listView ${task.toJson()}");
              if (task.repeat == 'Daily') {
                DateTime date =
                    DateFormat.jm().parse(task.startTime.toString());
                var myTime = DateFormat("HH:mm").format(date);
                notifyHelper.scheduledNotification(
                    int.parse(myTime.toString().split(":")[0]),
                    int.parse(myTime.toString().split(":")[1]),
                    task);
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskTile(task),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              if (task.date == DateFormat.yMd().format(_selectedDate)) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskTile(task),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            });
      }),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
      padding: EdgeInsets.only(top: 4),
      height: task.isCompleted == 1
          ? MediaQuery.of(context).size.height * 0.24
          : MediaQuery.of(context).size.height * 0.32,
      color: Get.isDarkMode ? darkGreyClr : Colors.white,
      child: Column(
        children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
            ),
          ),
          Spacer(),
          task.isCompleted == 1
              ? Container()
              : _bottomSheetButton(
                  label: "Task Completed",
                  onTap: () {
                    _taskController.markTAskCompleted(task.id!);
                    _categoryController.getCategoryTasks(widget.categoryId);
                    Get.back();
                  },
                  clr: primaryClr,
                  context: context),
          _bottomSheetButton(
              label: "Delete Task",
              onTap: () {
                _taskController.delete(task);
                _categoryController.getCategoryTasks(widget.categoryId);
                Get.back();
              },
              clr: Colors.red[300]!,
              context: context),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          _bottomSheetButton(
              label: "Edit",
              isClose: false,
              onTap: () async {
                await Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return AddTaskPage(
                    id: task.id,
                    categoryId: widget.categoryId,
                  );
                }));
                _taskController.getTasks();
              },
              clr: primaryClr,
              context: context),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.005,
          ),
        ],
      ),
    ));
  }

  _bottomSheetButton(
      {required String label,
      required Function() onTap,
      required Color clr,
      required BuildContext context,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose == true
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  _showAllTasks() {
    return Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: _taskController.taskList.length,
            itemBuilder: (context, index) {
              Task task = _taskController.taskList[index];
              print("her iammmm3");
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(task),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  _generateTasks() {
    return Container(
        height: 50,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _showAllTasks();
                  });
                },
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey),
                  child: const Center(
                      child: Text(
                    "All",
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: InkWell(
                onTap: () {
                  Center(child: Text("Empty"));
                },
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey),
                  child: const Center(
                      child: Text(
                    "Completed",
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: InkWell(
                onTap: () {
                  Text("Empty");
                },
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey),
                  child: const Center(
                      child: Text(
                    "ToDo",
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
            ),
          ],
        ));
  }
}
