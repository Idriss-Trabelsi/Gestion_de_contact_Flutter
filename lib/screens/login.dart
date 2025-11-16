import 'package:flutter/material.dart';
import '../services/user_storage.dart';
import 'home.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  void login() {
    final ok = UserHive.login(usernameCtrl.text, passwordCtrl.text);

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Identifiants incorrects")));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Login avec succès !")),
  );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: usernameCtrl, decoration: InputDecoration(labelText: "Username")),
            TextField(controller: passwordCtrl, obscureText: true, decoration: InputDecoration(labelText: "Password")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: Text("Se connecter")),
            TextButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => RegisterPage())),
              child: Text("Créer un compte"),
            ),
          ],
        ),
      ),
    );
  }
}
