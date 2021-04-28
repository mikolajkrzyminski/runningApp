import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with TickerProviderStateMixin<BottomNavBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return
      // BottomNavigationBar(
    //   currentIndex: _currentIndex,
    //   onTap: (int index) {
    //     setState(() {
    //       _currentIndex = index;
    //     });
    //   },
    //   selectedLabelStyle: TextStyle(
    //     color: Colors.black,
    //   ),
    //   items: const <BottomNavigationBarItem>[
    //     BottomNavigationBarItem(
    //         icon: Icon(
    //           Icons.group_rounded,
    //           color: Colors.black,
    //         ),
    //       label: "group",
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(
    //         Icons.leaderboard_rounded,
    //         color: Colors.black,
    //       ),
    //       label: "statistics",
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(
    //         Icons.timer_rounded,
    //         color: Colors.black,
    //       ),
    //       label: "home",
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(
    //         Icons.fitness_center_rounded,
    //         color: Colors.black,
    //       ),
    //       label: "exercises",
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(
    //         Icons.person_rounded,
    //         color: Colors.black,
    //       ),
    //       label: "profile",
    //     ),
    //   ],
    // );




      Container(
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