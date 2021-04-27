import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: Colors.amber[300],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: IconButton(
            padding: EdgeInsets.fromLTRB(12, 16, 12, 16),
            icon: Icon(
              Icons.group_rounded,
              size: 24,
            ),
            // TODO: implement
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/social'); 
            },
          ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
            padding: EdgeInsets.fromLTRB(12, 16, 12, 16),
            icon: Icon(
              Icons.leaderboard_rounded,
              size: 24,
            ),
            // TODO: implement
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/statistics');
            },
          ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
            padding: EdgeInsets.fromLTRB(12, 16, 12, 16),
            icon: Icon(
              Icons.timer_rounded,
              size: 24,
            ),
            // TODO: implement
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
            padding: EdgeInsets.fromLTRB(12, 16, 12, 16),
            icon: Icon(
              Icons.fitness_center_rounded,
              size: 24,
            ),
            // TODO: implement
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/exercises');
            },
          ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
            padding: EdgeInsets.fromLTRB(12, 16, 12, 16),
            icon: Icon(
              Icons.person_rounded,
              size: 24,
            ),
            // TODO: implement
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
          ),
          ),

        ],
      ),
    );
  }
}