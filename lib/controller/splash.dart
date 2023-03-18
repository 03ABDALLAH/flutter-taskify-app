import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:remember_app/constant/constants.dart';
import 'package:remember_app/constant/default_button.dart';
import 'package:remember_app/constant/size_config.dart';
import 'package:remember_app/constant/splash_content.dart';
import 'package:remember_app/controller/home_page.dart';


class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  int currentpage = 0;

  List<Map<String, String>> splashData = [
    {
      "text":
          "Welcome to the Task Management App! \nWe are excited to have you onboard \nand help you get started with our app.",
      "image": "img/splash1.png"
    },
    {
      "text":
          "Our app is the perfect tool to help you \nmanage your tasks and make sure you stay organized.",
      "image": "img/splash2.png"
    },
    {
      "text":
          "With the app, you can create tasks, set due dates, and track your progress.",
      "image": "img/splash3.png"
    }
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
                flex: 4,
                child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      currentpage = value;
                    });
                  },
                  itemCount: splashData.length,
                  itemBuilder: (context, index) => SplashContent(
                    image: splashData[index]["image"]!,
                    text: splashData[index]["text"]!,
                  ),
                )),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: [
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          splashData.length, (index) => buildDot(index: index)),
                    ),
                    Spacer(
                      flex: 3,
                    ),
                    DefaultButton(
                      text: "Continue",
                      press: () {
                        Get.to(() => HomePage());
                      },
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: KAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentpage == index ? 20 : 6,
      decoration: BoxDecoration(
          color: currentpage == index ? KPrimaryColor : Color(0xFFD8D8D8),
          borderRadius: BorderRadius.circular(3)),
    );
  }
}
