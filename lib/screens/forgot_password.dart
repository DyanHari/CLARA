import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  final _emailController = TextEditingController();




 /* Future resetPassword()async{
    try{
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());

    } on FirebaseAuthException catch (e){
      print(e);
      showErrorMessage(e.code);
    }
  }*/

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }


  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('Email sent! If you did not receive an email, please sign up.'),
            );
          });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password',style: TextStyle(fontSize: 24.0),),
        backgroundColor: Colors.green[700],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            const Text('Enter your email so we can send you a password reset link.',
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    enabledBorder:  OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.grey[500])),
              ),
            ),
            const SizedBox(height: 20.0),
            MaterialButton(

              onPressed: resetPassword,
              color: Colors.green[400],
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }

}
