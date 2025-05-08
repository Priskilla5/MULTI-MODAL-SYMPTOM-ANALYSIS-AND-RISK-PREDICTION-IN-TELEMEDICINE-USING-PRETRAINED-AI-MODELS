// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../Screens/EditProfileScreen.dart';

class Appbar extends StatelessWidget {
  const Appbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(top: 25, left: 25),
        child: Row(
          children: [
            const Text(
              'Digi-X-Care',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            const SizedBox(
              width: 200,
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProfileScreen()),
                );
              },
              icon: Image.asset('Assets/Images/EditProfile.png'),
              iconSize: 40,
            )
          ],
        ),
      ),
      const Divider(
        color: Colors.grey,
        indent: 25,
        endIndent: 30,
        thickness: 0.3,
      ),
    ]);
  }
}
