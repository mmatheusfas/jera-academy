import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pomodoro_jera/controllers/timer_controller.dart';
import 'package:pomodoro_jera/model/timer_model.dart';
import 'package:pomodoro_jera/widgets/custom_elevated_button.dart';
import 'package:duration_picker/duration_picker.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  TimerController controller = TimerController();
  Duration duration = const Duration(minutes: 25);
  TimerModel userModel = TimerModel();

  void _openDialog(BuildContext context, TimerModel timerModel, TimerController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("It's time to take a long pause"),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CustomElevatedButton(
                  child: const Text('Accept'),
                  onPressed: () {
                    Navigator.pop(context);
                    controller.startTimer(timerModel);
                  },
                ),
                CustomElevatedButton(
                  child: const Text('Deny'),
                  onPressed: () {
                    Navigator.pop(context);
                    controller.restartTimer(timerModel);
                  },
                )
              ],
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    controller.initializeDuration(userModel.timerGoal, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              var result = await showDurationPicker(
                context: context,
                initialTime: duration,
              );
              if (result != null) {
                userModel.timerGoal = result.inMinutes;
                controller.initializeDuration(userModel.timerGoal, false);
              }
            },
            icon: const Icon(
              Icons.timer,
              color: Colors.white,
              size: 35,
            ),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade900],
            begin: const FractionalOffset(.5, 1),
          ),
        ),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            Container(
                padding: const EdgeInsets.all(5),
                child: Observer(builder: (context) {
                  return Text(
                    controller.isInterval || controller.isLongInterval ? "Interval Mode" : "Focus Mode",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                })),
            const SizedBox(
              height: 50,
            ),
            Stack(
              children: [
                Container(
                  width: 300,
                  height: 300,
                  padding: const EdgeInsets.all(5),
                  child: Observer(builder: (context) {
                    var value = controller.duration.inSeconds.toDouble() / controller.totalDuration.toDouble();
                    return CircularProgressIndicator(
                      color: Colors.white,
                      value: controller.totalDuration == 0 ? 1 : value,
                      backgroundColor: Colors.grey,
                      strokeWidth: 15,
                    );
                  }),
                ),
                Positioned(
                  right: 72,
                  bottom: 110,
                  child: Observer(builder: (_) {
                    return Text(
                      "${controller.duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${controller.duration.inSeconds.remainder(60).toString().padLeft(2, '0')}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 65,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                )
              ],
            ),
            const SizedBox(
              height: 100,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.indigo.shade900,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Observer(builder: (context) {
                          return CustomElevatedButton(
                              child: const Text(
                                "Start",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                if (controller.isLongInterval) {
                                  _openDialog(context, userModel, controller);
                                  return;
                                }
                                controller.startTimer(userModel);
                              });
                        }),
                        CustomElevatedButton(
                          child: const Text(
                            "Pause",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () => controller.stopTimer(userModel),
                        ),
                        CustomElevatedButton(
                          child: const Text(
                            "Reset",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () => controller.restartTimer(userModel),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Observer(builder: (context) {
                      return Text(
                        "Pomodoros made today: ${controller.totalCycles}",
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
