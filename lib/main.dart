import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remember_app/component/splash_screen.dart';
import 'package:remember_app/model/db_helper.dart';
import 'package:remember_app/constant/theme_services.dart';
import 'controller/home_page.dart';
import 'controller/task_controller.dart';
import 'constant/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
  final _taskController = Get.put(TaskController());
  _taskController.getTasks();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: Themes.light,
        darkTheme: Themes.dark,
        themeMode: ThemeServices().theme,
        home: SplashScreen());
  }
}
