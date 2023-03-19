import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pomodoro_jera/controllers/notification_controller.dart';
import 'package:pomodoro_jera/model/timer_model.dart';
import 'package:mobx/mobx.dart';
part 'timer_controller.g.dart';

class TimerController = TimerControllerBase with _$TimerController;

abstract class TimerControllerBase with Store {
  Timer? countDownTimer;
  int auxiliar = 0;
  int cycles = 0;
  AudioPlayer? player = AudioPlayer();
  FlutterLocalNotificationsPlugin notification = FlutterLocalNotificationsPlugin();
  NotificationController notificationController = NotificationController();

  @observable
  var totalDuration = 0;
  @observable
  bool isLongInterval = false;
  @observable
  bool isInterval = false;
  @observable
  Duration duration = const Duration();
  @observable
  int totalCycles = 0;

  @action
  Duration initializeDuration(int? userDuration, bool isIntervalParam) {
    if (isIntervalParam && auxiliar % 2 != 0) {
      isInterval = true;
      duration = const Duration(seconds: 5);
      totalDuration = duration.inSeconds;
      return duration;
    } else {
      if (cycles != 0 && cycles % 4 == 0 && isInterval) {
        isInterval = false;
        isLongInterval = true;
        duration = const Duration(seconds: 10);
        totalDuration = duration.inSeconds;
        return duration;
      }
    }
    if (userDuration != null) {
      isInterval = false;
      duration = Duration(minutes: userDuration);
      totalDuration = duration.inSeconds;
      return duration;
    }
    isInterval = false;
    duration = const Duration(seconds: 25);
    totalDuration = duration.inSeconds;
    return duration;
  }

  playAudio() async {
    await player!.play(AssetSource("alarme.wav"));
  }

  stopAudio() async {
    await player!.stop();
  }

  startTimer(TimerModel timerModel) {
    timerModel.timerStarted = !timerModel.timerStarted;
    notificationController.initializeNotification(notification);
    stopAudio();

    if (timerModel.itsPaused) {
      timerModel.itsPaused = false;
      countDownTimer = Timer.periodic(const Duration(seconds: 1), (_) => decrementSeconds(timerModel));
    } else {
      initializeDuration(timerModel.timerGoal, isInterval ? true : false);
      countDownTimer = Timer.periodic(const Duration(seconds: 1), (_) => decrementSeconds(timerModel));
    }
  }

  stopTimer(TimerModel timerModel) {
    if (timerModel.timerStarted) {
      timerModel.timerStarted = false;
      timerModel.itsPaused = true;
      countDownTimer!.cancel();
    }
  }

  restartTimer(TimerModel timerModel) {
    if (timerModel.itsPaused || isLongInterval) {
      isLongInterval = false;
      countDownTimer!.cancel();
      initializeDuration(timerModel.timerGoal, false);
    } else {
      countDownTimer!.cancel();
      initializeDuration(timerModel.timerGoal, false);
    }
  }

  @action
  Duration decrementSeconds(TimerModel timerModel) {
    var seconds = duration.inSeconds;
    seconds--;

    if (seconds == 0) {
      dynamicNotification();
      playAudio();
      incrementCyle();
      initializeDuration(timerModel.timerGoal, auxiliar % 2 == 0 && auxiliar != 0 ? false : true);
      stopTimer(timerModel);
      return duration;
    } else {
      duration = Duration(seconds: seconds);
      return duration;
    }
  }

  dynamicNotification() {
    if (isInterval || isLongInterval) {
      notificationController.showNotification(
        title: "Timer",
        body: "Your interval time has ended, it's time to focus",
        plugin: notification,
      );
    } else {
      notificationController.showNotification(
        title: "Timer",
        body: "Your focus time has ended, it's time to relax",
        plugin: notification,
      );
    }
  }

  @action
  incrementCyle() {
    if (!isLongInterval) {
      if (auxiliar == 0) {
        auxiliar++;
        return;
      }
      auxiliar++;
      if (auxiliar % 2 == 0) {
        cycles++;
        totalCycles++;
      }
    } else {
      isLongInterval = false;
      auxiliar = 0;
      cycles = 0;
    }
  }
}
