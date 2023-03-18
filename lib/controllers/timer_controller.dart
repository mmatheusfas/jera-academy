import 'dart:async';
import 'package:pomodoro_jera/model/timer_model.dart';
import 'package:mobx/mobx.dart';
part 'timer_controller.g.dart';

class TimerController = TimerControllerBase with _$TimerController;

abstract class TimerControllerBase with Store {
  Timer? countDownTimer;
  int auxiliar = 0;
  int cycles = 0;

  @observable
  bool isLongInterval = false;
  @observable
  bool isInterval = false;
  @observable
  Duration duration = const Duration(seconds: 4);
  @observable
  int totalCycles = 0;

  @action
  Duration initializeDuration(int? userDuration, bool isIntervalParam, TimerModel model) {
    if (isIntervalParam && auxiliar % 2 != 0) {
      isInterval = true;
      return duration = const Duration(seconds: 5);
    } else {
      if (cycles != 0 && cycles % 4 == 0 && isInterval) {
        isInterval = false;
        isLongInterval = true;

        return duration = const Duration(seconds: 10);
      }
    }
    if (userDuration != null) {
      isInterval = false;
      return duration = Duration(minutes: userDuration);
    }
    isInterval = false;
    return duration = const Duration(seconds: 4);
  }

  startTimer(TimerModel timerModel) {
    timerModel.timerStarted = !timerModel.timerStarted;

    if (timerModel.itsPaused) {
      timerModel.itsPaused = false;
      countDownTimer = Timer.periodic(const Duration(seconds: 1), (_) => decrementSeconds(timerModel));
    } else {
      initializeDuration(timerModel.timerGoal, isInterval ? true : false, timerModel);
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
      initializeDuration(timerModel.timerGoal, false, timerModel);
    } else {
      countDownTimer!.cancel();
    }
  }

  @action
  Duration decrementSeconds(TimerModel timerModel) {
    var seconds = duration.inSeconds;
    seconds--;

    if (seconds == 0) {
      incrementCyle();
      initializeDuration(timerModel.timerGoal, auxiliar % 2 == 0 && auxiliar != 0 ? false : true, timerModel);
      stopTimer(timerModel);
      return duration;
    } else {
      duration = Duration(seconds: seconds);
      return duration;
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
