import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:remember_app/component/button.dart';
import 'package:remember_app/controller/category_details.dart';
import 'package:remember_app/model/category.dart';
import 'package:remember_app/notification/notification_services.dart';
import 'package:remember_app/constant/theme_services.dart';
import 'package:remember_app/constant/themes.dart';

import 'add_category.dart';
import 'category_controller.dart';
import 'tasks_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NotifyHelper notifyHelper;
  final _categoryController = Get.put(CategoryController());

  @override
  void initState() {
    // TODO: implement initState
    _categoryController.getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          SizedBox(height: 25),
          _showCategory(),
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
              label: "+ Add Category",
              onTap: () async {
                await Get.to(() => AddCategoryPage());
                _categoryController.getCategory();
              }),
        ],
      ),
    );
  }

  _showCategory() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _categoryController.categoryList.length,
            itemBuilder: (_, index) {
              print(_categoryController.categoryList.length);
              Category category = _categoryController.categoryList[index];
              print(category.toJson());
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            print("categId ${category.id}");
                            await Get.to(() => TaskLists(
                                  categoryId: category.id,
                                ));
                          },
                          child: CategoryDetails(category),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      }),
    );
  }
}
