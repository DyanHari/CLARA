import 'package:flutter/material.dart';
import 'package:loggingg/screens/authpage.dart';
import 'package:loggingg/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loggingg/screens/signup.dart';
import '../firebase_options.dart';
import '../screens/verification.dart';
import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return  const MaterialApp(
      title:'Clara',
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}