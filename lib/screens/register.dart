import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_storage.dart';
import 'home.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  Future<void> register() async {
    final user = User(
      username: usernameCtrl.text,
      password: passwordCtrl.text,
      email: emailCtrl.text,
    );

    if (UserHive.getUser(user.username) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Utilisateur déjà existant")));
      return;
    }

    await UserHive.saveUser(user);
      ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Compte créé avec succès !")),
  );

Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => HomePage()),
);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: usernameCtrl, decoration: InputDecoration(labelText: "Username")),
            TextField(controller: emailCtrl,decoration: InputDecoration(labelText: "Email"),keyboardType: TextInputType.emailAddress,),
            TextField(controller: passwordCtrl, obscureText: true, decoration: InputDecoration(labelText: "Password")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: register, child: Text("Créer le compte")),
          ],
        ),
      ),
    );
  }
}
