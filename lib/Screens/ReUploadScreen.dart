// ignore_for_file: file_names

import 'package:digixcare/widgets/AppBar.dart';
import 'package:flutter/material.dart';

import 'ResultsScreen.dart';

class ReUploadScreen extends StatelessWidget {
  const ReUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        const Appbar(),
        const SizedBox(
          height: 50,
        ),
        Container(
          width: 330,
          height: 380,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(30)),
        ),
        const SizedBox(
          height: 30,
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
          onPressed: () {},
          label: const Text('Re-upload'),
          icon: Image.asset('Assets/Images/Upload.png', color: Colors.black),
          style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black, width: 1.5),
              fixedSize: const Size.fromWidth(180),
              maximumSize: const Size.fromHeight(45),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)))),
        )
      ],
    )));
  }
}
