import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../../theme.dart';
import '../doctor_screens/news/home_news_screen.dart';
import '../doctor_screens/profile_doctor.dart';
import '../doctor_screens/todo_screens/calender_screen.dart';
import '../doctor_screens/todo_screens/todo_home.dart';


class BNBar extends StatefulWidget {
  const BNBar({Key? key}) : super(key: key);

  @override
  _BNBarState createState() => _BNBarState();
}

class _BNBarState extends State<BNBar> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int _index = 2;

  final item = const [
    Icon(Icons.library_books_outlined, size: 26, color: whitClr),
    // Icon(Icons.location_on, size: 26, color: whitClr),
    Icon(Icons.person, size: 26, color: whitClr),
     Icon(Icons.favorite, size: 26, color: whitClr),
    Icon(Icons.event_note_outlined, size: 26, color: whitClr)
  ];
  @override
  void initState() {
    super.initState();
  }

  bool visibility = false;
  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeNewsScreen(),
      // Search(),
      const ProfileScreen(),
      const CalenderDoctor(),
      const TodoHome(),
    ];
    return Container(
      color: greenClr,
      child: SafeArea(
        top: true,
        child: ClipRect(
          child: Scaffold(
            backgroundColor: Colors.white,
            extendBody: true,
            body: screens[_index],
            bottomNavigationBar: CurvedNavigationBar(
              key: navigationKey,
              backgroundColor: Colors.transparent,
              color: Colors.green.shade500,
              height: 55,
              items: item,
              index: _index,
              onTap: (index) {
                setState(() {
                  _index = index;
                });
              },
              //  letIndexChange: ,
            ),
          ),
        ),
      ),
    );
  }
}
