import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Destination {
  const Destination(this.label, this.icon);
  final String label;
  final Icon icon;
}

const List<Destination> allDestinations = <Destination>[
  Destination('Group', Icon(
      Icons.group_rounded,
      color: Colors.black,
  )),
  Destination('Statistics', Icon(
    Icons.leaderboard_rounded,
    color: Colors.black,
  ),),
  Destination('Home', Icon(
    Icons.timer_rounded,
    color: Colors.black,
  ),),
  Destination('Exercises', Icon(
    Icons.fitness_center_rounded,
    color: Colors.black,
  ),),
  Destination('Profile', Icon(
    Icons.person_rounded,
    color: Colors.black,
  ),),
];