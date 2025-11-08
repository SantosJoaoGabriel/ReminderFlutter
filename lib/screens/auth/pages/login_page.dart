import 'package:financing_app/screens/auth/pages/register_page.dart';
import 'package:financing_app/screens/expenses/reminder_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _error;
  bool _success = false;
  bool _isCreatingUser = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final size = MediaQuery.of(context).size;
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: dark ? Colors.blueGrey[900] : Colors.blueGrey[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: size.width > 420 ? 420 : size.width * 0.95,
            ),
            child: Card(
              color: dark ? Colors.grey[850] : Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.network(
                        "https://th.bing.com/th/id/OIP.Lddo6-yQCJntaifsBG1tLgHaHa?w=184&h=185&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3",
                        width: 90,
                        height: 90,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 16),
                      Text('Reminder App',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _email,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: dark ? Colors.blueGrey[800] : Colors.grey[200],
                        ),
                        style: TextStyle(color: dark ? Colors.white : Colors.black87),
                        validator: (v) => v != null && v.contains('@') ? null : 'Digite um email válido',
                        autofillHints: const [AutofillHints.email],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _password,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: dark ? Colors.blueGrey[800] : Colors.grey[200],
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        obscureText: _obscurePassword,
                        style: TextStyle(color: dark ? Colors.white : Colors.black87),
                        validator: (v) => v != null && v.length >= 6 ? null : 'A senha deve ter no mínimo 6 caracteres',
                      ),
                      if (_error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(_error!,
                              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                        ),
                      if (_success)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            'Conta criada com sucesso!',
                            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                        ),
                      const SizedBox(height: 30),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: auth.isLoading || _isCreatingUser
                            ? const CircularProgressIndicator()
                            : Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: _signIn,
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        backgroundColor: Colors.blueAccent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)),
                                      ),
                                      child: const Text('Entrar', style: TextStyle(fontSize: 18)),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (_) => const RegisterPage()),
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        side: const BorderSide(color: Colors.blueAccent),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)),
                                      ),
                                      child: const Text('Criar Conta', style: TextStyle(fontSize: 18, color: Colors.blueAccent)),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _error = null;
      _success = false;
      _isCreatingUser = false;
    });

    try {
      await context.read<AuthService>().signIn(_email.text.trim(), _password.text.trim());
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const RemindersPage()));
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _handleFirebaseError(e));
    } catch (e) {
      setState(() => _error = 'Erro inesperado: ${e.toString()}');
    }
  }

  String _handleFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Usuário não encontrado para esse email.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'email-already-in-use':
        return 'Esse email já está cadastrado.';
      case 'invalid-email':
        return 'Email inválido.';
      default:
        return e.message ?? 'Erro de autenticação';
    }
  }
}