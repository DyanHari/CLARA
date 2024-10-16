import 'package:flutter/material.dart';
import 'package:loggingg/screens/authpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loggingg/screens/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';


bool show = false ;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  show =  prefs.getBool('hasSeenOnboarding') ?? true;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget{
  const MyApp({super.key});


  @override
  Widget build(BuildContext context){
    return   MaterialApp(
      title:'Clara',
      debugShowCheckedModeBanner: false,
      home: show ?  OnboardingScreen() : const AuthPage(),
    );
  }
}