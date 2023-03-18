import 'dart:async';

import 'package:get/get.dart';

class TimerController extends GetxController {
  Timer? timer;
  int remainingSeconds = 1;
  int ww = 1;
  final time = '00.00'.obs;

  @override
  void onReady() {
    _startTimer(ww);
    super.onReady();
  }

  @override
  void onClose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.onClose();
  }

  _startTimer(int seconds) {
    const duration = Duration(seconds: 1);
    remainingSeconds = seconds;
    timer = Timer.periodic(duration, (timer) {
      if (remainingSeconds == 0) {
        timer.cancel();
      } else {
        int minutes = (remainingSeconds ~/ 60);
        int seconds = (remainingSeconds % 60);
        time.value = minutes.toString().padLeft(2, "0") +
            ":" +
            seconds.toString().padLeft(2, "0");
        remainingSeconds--;
      }
    });
  }
}
