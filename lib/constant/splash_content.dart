import 'package:flutter/cupertino.dart';
import 'package:remember_app/constant/constants.dart';
import 'package:remember_app/constant/size_config.dart';


class SplashContent extends StatelessWidget {
  const SplashContent({
    Key? key,
    required this.text,
    required this.image,
  }) : super(key: key);

  final String text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          "TASKIFY",
          style: TextStyle(
              fontSize: getProportionateScreenWidth(36),
              color: KPrimaryColor,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 40,
        ),
        Text(
          text,
          textAlign: TextAlign.center,
        ),
        Spacer(
          flex: 2,
        ),
        Image.asset(
          image,
          height: getProportionateScreenHeight(285),
          width: getProportionateScreenWidth(255),
        ),
      ],
    );
  }
}
