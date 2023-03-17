class TimerModel {
  bool timerStarted;
  int? timerGoal;
  bool itsPaused;

  TimerModel({
    this.timerStarted = false,
    this.timerGoal,
    this.itsPaused = false,
  });
}
