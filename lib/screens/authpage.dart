import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loggingg/chatbotscreen//chatbot_screen.dart';
import 'package:loggingg/screens/login_or_register.dart';

class AuthPage extends StatelessWidget{
  const AuthPage({super.key});


  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          // user logged in
          if(snapshot.hasData){
            User? user = snapshot.data;
            // check if email is verified
            if(user?.emailVerified ?? false){
              return  ChatbotScreen();
            }
          }

          // user not logged in or email not verified
          return const LoginOrRegisterPage();
        },
      ),
    );
  }
}