import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:szewa/managers/stats_calculator.dart';

class StatsPresenter extends StatefulWidget {
  final StatsCalculator statsCalculator;
  final StopWatchTimer stopwatchTimer;
  const StatsPresenter ({this.statsCalculator, this.stopwatchTimer});

  @override
  _StatsPresenterState createState() => _StatsPresenterState();
}

class _StatsPresenterState extends State<StatsPresenter> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          StreamBuilder<int>(
              stream: widget.stopwatchTimer.rawTime,
              initialData: widget.stopwatchTimer.rawTime.value,
              builder: (context, snapshot) {
                final displayTime = StopWatchTimer.getDisplayTime(
                    snapshot.data,
                    milliSecond: false);
                widget.statsCalculator.timePassed = snapshot.data ~/ 1000;
                return RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: displayTime,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 75),
                      ),
                      TextSpan(
                        text: "\nTime",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 12),
                      ),
                    ],
                  ),
                );
              }),
          SizedBox(
            height: 22,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: widget.statsCalculator.distance.toStringAsFixed(2),
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 25),
                  ),
                  TextSpan(
                    text: "\nDistance (m)",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 12),
                  ),
                ],
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: widget.statsCalculator.calories.toStringAsFixed(0),
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 25),
                  ),
                  TextSpan(
                    text: "\nCalorie (kcal)",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 12),
                  ),
                ],
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 0 != widget.statsCalculator.avgVelocity
                        ? (1 / (widget.statsCalculator.avgVelocity) * (50 / 3))
                        .toStringAsFixed(1)
                        : '0',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 25),
                  ),
                  TextSpan(
                    text: "\nPace (min/km)",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 12),
                  ),
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }
}