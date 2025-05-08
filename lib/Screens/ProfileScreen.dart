// ignore_for_file: file_names
import 'package:digixcare/widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/EnhancedBottomNavBar.dart';
import 'AuthScreen.dart';
import 'EditProfileScreen.dart';
import 'package:digixcare/utils/user_storage.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    try {
      await Supabase.instance.client.auth.signOut();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Appbar(),
              FutureBuilder<String?>(
                future: UserStorage.getUserName(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 5, left: 25),
                child: Row(
                  children: [
                        const Text('Hi! ', style: TextStyle(fontSize: 27)),
                        Text(
                          snapshot.data ?? 'Guest',
                          style: const TextStyle(color: Colors.blue, fontSize: 27),
                        ),
                  ],
                ),
                  );
                },
              ),
              const Divider(
                  color: Colors.grey,
                  indent: 25,
                  endIndent: 280,
                thickness: 0.3,
              ),
              FutureBuilder<String?>(
                future: UserStorage.getUserRole(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Row(
                      children: [
                        const Text('Role: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 10),
                        Text(
                          (snapshot.data ?? 'user').toUpperCase(),
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Row(
                  children: [
                    Text('Email:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(width: 10),
                    Text('harikrish@gmail.com'),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              _buildProfileOption(
                context,
                iconPath: 'Assets/Images/User Circle.png',
                title: 'My Account',
                subtitle: 'Manage your profile and preferences',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfileScreen()));
                },
              ),
              _buildProfileOption(
                context,
                iconPath: 'Assets/Images/Stars.png',
                title: 'Rate Digi-X Care',
                subtitle: 'Share your experience with our AI health app',
                onTap: () {},
              ),
              _buildProfileOption(
                context,
                iconPath: 'Assets/Images/Logout.png',
                title: 'Log out',
                subtitle: 'End your current session securely',
                onTap: () => _handleLogout(context),
              ),
              Divider(
                  color: Colors.grey[200],
                  indent: 150,
                  endIndent: 160,
                  thickness: 4),
              const SizedBox(height: 10),
              _buildScanSection(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const EnhancedBottomNavBar(),
    );
  }

  Widget _buildProfileOption(BuildContext context,
      {required String iconPath,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[100],
          ),
          child: Row(
            children: [
              Image.asset(iconPath, width: 40, height: 40),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 5),
                    Text(subtitle,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScanSection(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 310,
            height: 340,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('Assets/Images/CardBackground.png'),
                fit: BoxFit.cover,
                alignment: Alignment.bottomLeft,
              ),
            ),
          ),
          const Positioned(
            top: 20,
            child: Column(
              children: [
                Text('Transforming Symptom Analysis with',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18)),
                Text('AI-Powered Precision.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.blue)),
                SizedBox(height: 5),
                Divider(
                    color: Colors.grey,
                    thickness: 2,
                    indent: 100,
                    endIndent: 100),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 30,
            right: 30,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "We do not store or share your data.\nSelf-care suggestions are provided only for Low and Medium severity levels.\nFor High severity, please consult a doctor — your case will be redirected to professionals.",
                style: TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
