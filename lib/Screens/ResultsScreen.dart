// ignore_for_file: file_names

import 'package:digixcare/Screens/Feedback1.dart';
import 'package:flutter/material.dart';

import '../widgets/AppBar.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

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
                      color: Colors.red,
                    ),
                  ),
                ),
                const Positioned(
                  top: 75,
                  left: 20,
                  child: Column(
                    children: [
                      Icon(Icons.report),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Issue find in your X-ray',
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
            onPressed: () {},
            label: const Text('Download Report'),
            icon: Image.asset('Assets/Images/Download.png'),
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
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => const Feedback1())));
            },
            label: const Text('Feedback'),
            icon: Image.asset('Assets/Images/Document Add.png'),
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
