// ignore_for_file: file_names

import 'package:digixcare/Screens/ReUploadScreen.dart';
import 'package:digixcare/Screens/ResultsScreen.dart';
import 'package:flutter/material.dart';

import '../widgets/AppBar.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          const Appbar(),
          const SizedBox(
            height: 150,
          ),
          GestureDetector(
              onTap: () {},
              child: Stack(children: [
                Material(
                  elevation: 10,
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: const ShapeDecoration(
                      shape: CircleBorder(),
                      color: Colors.blue,
                    ),
                  ),
                ),
                const Positioned(
                  top: 75,
                  left: 67,
                  child: Column(
                    children: [
                      Text(
                        '100%',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Uploaded',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                )
              ])),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const ResultScreen())));
            },
            label: const Text('Analyze'),
            icon: Image.asset('Assets/Images/DNA.png'),
            style: ElevatedButton.styleFrom(
                fixedSize: const Size.fromWidth(180),
                maximumSize: const Size.fromHeight(45),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)))),
          ),
          const SizedBox(
            height: 10,
          ),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const ReUploadScreen())));
            },
            label: const Text('Preview'),
            icon: Image.asset('Assets/Images/Eye Scan.png'),
            style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black, width: 1.5),
                fixedSize: const Size.fromWidth(180),
                maximumSize: const Size.fromHeight(45),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)))),
          )
        ],
      ),
    ));
  }
}
