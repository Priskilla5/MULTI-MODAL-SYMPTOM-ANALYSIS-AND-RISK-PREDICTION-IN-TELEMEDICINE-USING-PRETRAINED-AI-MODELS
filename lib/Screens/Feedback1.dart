// ignore_for_file: file_names

import 'package:digixcare/Screens/Feedback2.dart';
import 'package:digixcare/widgets/AppBar.dart';
import 'package:flutter/material.dart';

class Feedback1 extends StatefulWidget {
  const Feedback1({super.key});

  @override
  State<Feedback1> createState() => _Feedback1State();
}

class _Feedback1State extends State<Feedback1> {
  bool valuefirst = false;
  bool valuesecond = false;
  bool valuethird = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      const Appbar(),
      const SizedBox(
        height: 10,
      ),
      Padding(
          padding: const EdgeInsets.only(left: 25),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Row(
              children: [
                Text(
                  'Share Your ',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Feedback ',
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                Text(
                  'and Help ',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Row(
              children: [
                Text(
                  'Us ',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Improve',
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                Text(
                  '! ',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Do you think the prediction was correct?',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 10,
                    ),
                    Checkbox(
                      value: valuefirst,
                      onChanged: (value) {
                        setState(() {
                          valuefirst = value!;
                        });
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      'Yes ',
                      style: TextStyle(fontSize: 17.0),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: <Widget>[
                const SizedBox(
                  width: 10,
                ),
                Checkbox(
                  value: valuesecond,
                  onChanged: (value) {
                    setState(() {
                      valuesecond = value!;
                    });
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  'No ',
                  style: TextStyle(fontSize: 17.0),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                const SizedBox(
                  width: 10,
                ),
                Checkbox(
                  value: valuethird,
                  onChanged: (value) {
                    setState(() {
                      valuethird = value!;
                    });
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  'Maybe ',
                  style: TextStyle(fontSize: 17.0),
                ),
              ],
            ),
            const SizedBox(
              height: 90,
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const Feedback2())));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  elevation: 10,
                  fixedSize: const Size.fromWidth(350),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                ),
                child: const Text('Next'),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Divider(
              color: Colors.grey[400],
              indent: 140,
              endIndent: 170,
              thickness: 4,
            ),
          ]))
    ])));
  }
}
