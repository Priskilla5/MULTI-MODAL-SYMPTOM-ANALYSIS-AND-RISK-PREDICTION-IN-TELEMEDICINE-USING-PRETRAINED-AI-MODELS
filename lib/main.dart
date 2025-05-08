import 'package:digixcare/Screens/AuthScreen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://aapzkqishiozgvhjivgz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFhcHprcWlzaGlvemd2aGppdmd6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ5NjQzMTcsImV4cCI6MjA2MDU0MDMxN30.EghCo0w5W8W6d6FPy2pId5-A-LV9CBvu6JnCxoNNBwQ',
  );

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthScreen(),
    );
  }
}
