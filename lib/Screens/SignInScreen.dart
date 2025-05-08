// ignore_for_file: file_names

import 'package:digixcare/Screens/HomeScreen.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('Assets/Images/Background.jpg'),
                  colorFilter: ColorFilter.mode(Colors.black, BlendMode.color),
                  fit: BoxFit.cover)),
        ),
        const Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50, left: 30),
              child: Text(
                'Digi-X-Care',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50, left: 375),
          child: Column(
            children: [
              Image.asset('Assets/Images/DNA.png'),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 250, right: 10, left: 160),
            child: RichText(
                textAlign: TextAlign.end,
                text: const TextSpan(
                    text: 'Experience the Future of ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'X-ray Analysis',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ))
                    ]))),
        const Padding(
          padding: EdgeInsets.only(left: 400),
          child: VerticalDivider(
            color: Colors.grey,
            width: 100,
            thickness: 5,
            indent: 400,
            endIndent: 375,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 410, right: 15, left: 200),
          child: Text(
            'Revolutionizing Image And Text Analysis. Empowering accurate diagnoses and transforming patient care.',
            textAlign: TextAlign.end,
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 640, left: 120),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  )),
              label: const Text("Sign in with Google"),
              icon: Image.asset('Assets/Images/GoogleLogo.png'),
            )),
      ]),
    );
  }
}
