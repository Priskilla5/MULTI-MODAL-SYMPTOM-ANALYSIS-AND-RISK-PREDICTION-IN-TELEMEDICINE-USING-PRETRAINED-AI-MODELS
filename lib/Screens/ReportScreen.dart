// ignore_for_file: file_names

import 'package:digixcare/widgets/AppBar.dart';
import 'package:digixcare/widgets/EnhancedBottomNavBar.dart';
import 'package:flutter/material.dart';
import 'UploadScreen.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Appbar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildScanSection(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const EnhancedBottomNavBar(),
    );
  }

  Widget _buildScanSection(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 350,
          height: 165,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage('Assets/Images/CardBackgroundZoom.png'),
              fit: BoxFit.contain,
              alignment: Alignment.bottomLeft,
            ),
          ),
        ),
        Positioned(
          top: 110,
          left: 140,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UploadScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(200, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            label: const Text("Scan"),
            icon: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Image.asset('Assets/Images/Scan.png'),
            ),
          ),
        ),
        const Positioned(
          top: 10,
          left: 100,
          right: 30,
          child: Column(
            children: [
              Text(
                'Transforming Image And Text Diagnosis with ',
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'AI-Powered Precision.',
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
              Divider(
                color: Colors.grey,
                thickness: 2,
                indent: 5,
                endIndent: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
