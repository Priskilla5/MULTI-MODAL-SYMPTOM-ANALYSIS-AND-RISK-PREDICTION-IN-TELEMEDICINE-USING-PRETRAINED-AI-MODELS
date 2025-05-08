// ignore_for_file: file_names, non_constant_identifier_names, avoid_print

import 'package:digixcare/Screens/HomeScreen.dart';
import 'package:digixcare/Screens/ProfileScreen.dart';
import 'package:digixcare/Screens/ReportScreen.dart';
import 'package:digixcare/Screens/UploadScreen.dart';
import 'package:digixcare/Screens/DocChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int CurrentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding = size.width * 0.05;
    final verticalPadding = size.height * 0.015;
    final navPadding = size.width * 0.05;
    final iconSize = size.width * 0.06;
    final textSize = size.width * 0.035;

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: GNav(
          gap: 8,
          backgroundColor: Colors.white,
          color: Colors.black,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.blue,
          onTabChange: (int index) {
            setState(() {
              CurrentPageIndex = index;
              print(CurrentPageIndex);
            });
          },
          selectedIndex: CurrentPageIndex,
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: navPadding,
          ),
          iconSize: iconSize,
          tabs: [
            GButton(
              icon: Icons.home_outlined,
              text: 'Home',
              textStyle: TextStyle(fontSize: textSize),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            GButton(
              icon: Icons.article_outlined,
              text: 'AI Chat',
              textStyle: TextStyle(fontSize: textSize),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UploadScreen()),
                );
              },
            ),
            GButton(
              icon: Icons.chat_outlined,
              text: 'Doc Chat',
              textStyle: TextStyle(fontSize: textSize),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DocChatScreen()),
                );
              },
            ),
            GButton(
              icon: Icons.account_circle_outlined,
              text: 'Profile',
              textStyle: TextStyle(fontSize: textSize),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
