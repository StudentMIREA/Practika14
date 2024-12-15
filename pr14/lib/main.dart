import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pr14/auth/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://aiyydvjkhezcmdlwaflp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFpeXlkdmpraGV6Y21kbHdhZmxwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE5MTA1MzksImV4cCI6MjA0NzQ4NjUzOX0.XTQfN0Jz8FlVisI8CB3ixI9c2xZBNY8d4XKIRaPo_qI',
  );
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthGate(),
    );
  }
}
