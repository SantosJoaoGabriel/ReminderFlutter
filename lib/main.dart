import 'package:financing_app/screens/auth/pages/login_page.dart';
import 'package:financing_app/screens/expenses/reminder_page.dart';
import 'package:financing_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    StreamProvider<User?>.value(
      value: FirebaseAuth.instance.authStateChanges(),
      initialData: null,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return MaterialApp(
      title: 'Reminder App',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Aqui decide qual tela exibir com base no usuário autenticado
      home: user == null ? const LoginPage() : const RemindersPage(),
    );
  }
}
