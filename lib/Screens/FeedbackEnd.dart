// ignore_for_file: file_names

import 'package:digixcare/Screens/HomeScreen.dart';
import 'package:digixcare/widgets/AppBar.dart';
import 'package:flutter/material.dart';

class FeedbackEnd extends StatelessWidget {
  const FeedbackEnd({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const Appbar(),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      'Thanks ',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'User.',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'hope you find the App helpful.',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  indent: 8,
                  endIndent: 290,
                  thickness: 2,
                ),
                const SizedBox(
                  height: 350,
                ),
                const SizedBox(
                  height: 70,
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      elevation: 10,
                      fixedSize: const Size.fromWidth(350),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                    ),
                    child: const Text('Go back to home'),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Divider(
                  color: Colors.grey[300],
                  indent: 150,
                  endIndent: 160,
                  thickness: 4,
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
