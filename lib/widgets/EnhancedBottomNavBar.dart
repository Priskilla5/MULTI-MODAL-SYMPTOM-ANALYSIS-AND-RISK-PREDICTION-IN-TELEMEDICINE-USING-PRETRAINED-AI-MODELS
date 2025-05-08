// ignore_for_file: file_names, non_constant_identifier_names, avoid_print

import 'package:digixcare/Screens/HomeScreen.dart';
import 'package:digixcare/Screens/ProfileScreen.dart';
import 'package:digixcare/Screens/ReportScreen.dart';
import 'package:digixcare/Screens/UploadScreen.dart';
import 'package:digixcare/Screens/DocChatScreen.dart';
import 'package:digixcare/utils/user_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EnhancedBottomNavBar extends StatefulWidget {
  const EnhancedBottomNavBar({super.key});

  @override
  State<EnhancedBottomNavBar> createState() => _EnhancedBottomNavBarState();
}

class _EnhancedBottomNavBarState extends State<EnhancedBottomNavBar> {
  int CurrentPageIndex = 0;
  String? userName;
  String? userRole;
  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final supabaseUser = _supabase.auth.currentUser;
      if (supabaseUser != null) {
        final response = await _supabase
            .from('profiles')
            .select('username, role')
            .eq('id', supabaseUser.id)
            .single();
        
        if (mounted) {
          setState(() {
            userName = response['username'];
            userRole = response['role'];
          });
        }
      }
    } catch (e) {
      print('Error loading user info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding = size.width * 0.05;
    final verticalPadding = size.height * 0.015;
    final navPadding = size.width * 0.05;
    final iconSize = size.width * 0.06;
    final textSize = size.width * 0.035;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.grey[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                userName ?? 'Guest',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  userRole?.toUpperCase() ?? 'USER',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        ClipRRect(
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
        ),
      ],
    );
  }
} 