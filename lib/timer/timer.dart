import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import 'timer_counter.dart';

class timer extends GetView<TimerController> {
  const timer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          controller.timer?.cancel();
        },
        child: Center(
          child: Container(
            height: 100,
            width: 200,
            decoration: ShapeDecoration(
                color: Theme.of(context).primaryColor,
                shape: StadiumBorder(
                    side: BorderSide(width: 2, color: Colors.red))),
            child: Obx((() => Center(
                  child: Text(
                    '${controller.time.value}',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ))),
          ),
        ),
      ),
    );
  }
}
