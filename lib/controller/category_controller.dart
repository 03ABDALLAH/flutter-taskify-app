import 'package:get/get.dart';
import 'package:remember_app/model/category.dart';
import 'package:remember_app/model/db_helper.dart';
import 'package:remember_app/model/task_data.dart';


class CategoryController extends GetxController {
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  var categoryList = <Category>[].obs;
  var categoryTasks = <Task>[].obs;
  int count = 0;

  Future<int> addCategory({Category? category}) async {
    return await DBHelper.insertCategory(category!);
  }

  void getCategory() async {
    List<Map<String, dynamic>> categories = await DBHelper.queryCategory();
    categoryList
        .assignAll(categories.map((data) => Category.fromJson(data)).toList());
  }

  void getCategoryTasks(int categoryId) async {
    List<Map<String, dynamic>> categories =
        await DBHelper.getTasksFromCategoryId(categoryId);
    categoryTasks
        .assignAll(categories.map((data) => Task.fromJson(data)).toList());
    print("inside controller: $categoryTasks");
  }

  void delete(Category category){
    print("deleteee");
    DBHelper.deleteCategory(category);
    getCategory();
  }

  void taskCountInCategory(int? categoryId)async{
    var d = await DBHelper.getTaskCountByCategory(categoryId!);
    count  = count + d;
  }
}
