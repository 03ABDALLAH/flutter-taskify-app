import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:remember_app/component/input_field.dart';
import 'package:remember_app/controller/category_controller.dart';
import 'package:remember_app/controller/task_controller.dart';
import 'package:remember_app/model/category.dart';
import 'package:remember_app/model/task_data.dart';
import 'package:remember_app/constant/themes.dart';
import '../component/button.dart';

class AddCategoryPage extends StatefulWidget {
  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final CategoryController _categoryController = Get.put(CategoryController());
  final TextEditingController _nameController = TextEditingController();
  int _selectedColor = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 100),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Add Category',
                style: headingstyle,
              ),
              MyInputField(
                title: "Name",
                hint: 'Enter name of your category',
                controller: _nameController,
              ),
              SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _colorPallete(),
                  MyButton(
                      label: 'Create Category', onTap: () => _valiDateDate()),
                ],
              ),
              Container(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
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

  _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color", style: titleStyle),
        SizedBox(
          height: 8,
        ),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: index == 0
                        ? primaryClr
                        : index == 1
                            ? pinkClr
                            : yellowClr,
                    child: _selectedColor == index
                        ? Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 16,
                          )
                        : Container(),
                  ),
                ));
          }),
        )
      ],
    );
  }

  _valiDateDate() {
    if (_nameController.text.isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else {
      Get.snackbar("Required", "All fields are required !!",
          snackPosition: SnackPosition.BOTTOM,
          colorText: pinkClr,
          backgroundColor: Colors.white,
          icon: Icon(Icons.warning_amber_rounded, color: Colors.red));
    }
  }

  _addTaskToDb() async {
    int id = await _categoryController.addCategory(
        category: Category(
      name: _nameController.text,
      color: _selectedColor,
    ));
    print("My id is $id");
  }
}
