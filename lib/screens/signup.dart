import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loggingg/screens/verification.dart';
import 'package:loggingg/servies/auth_service.dart';
import 'package:loggingg/textfield.dart';


class SignupPage extends StatefulWidget {

  final Function()? onTap;
  const SignupPage({super.key, required this.onTap});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  bool _obscureTextConfirmPassword = true;
  bool _obscureTextPassword = true;
  final _formKey = GlobalKey<FormState>();
  final emailController =   TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isAllFieldsFilled() {
    return emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
  }


  void _toggleObscureTextPassword() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }

  void _toggleObscureTextConfirmPassword() {
    setState(() {
      _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
    });
  }


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }




  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  // Function to save email to Firestore
  /*Future<void> saveEmailToFirestore(String email) async {
    await FirebaseFirestore.instance.collection('try').doc(email).set({
      'email': email,
      'created_at': Timestamp.now(),
    });
  }*/



  void signUserUp(BuildContext context) async {
    try {
      if (passwordController.text == confirmPasswordController.text) {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);


        // Save email to Firestore after successful registration
        //await saveEmailToFirestore(emailController.text);


        // Send verification email
        await userCredential.user!.sendEmailVerification();

        // Navigate to the VerifyPage
        Future.delayed(Duration.zero, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VerifyPage(email: emailController.text)),
          );
        });

        // Pop the loading circle
      } else {
        // Passwords don't match
        showErrorMessage("Passwords don't match");
      }
    } on FirebaseAuthException catch (e) {
      // Pop the loading circle


      // Show error message
      showErrorMessage(e.code);
    }
  }






  void showErrorMessage(String message){
    showDialog(context: context, builder: (context){
      return  AlertDialog(
        backgroundColor: Colors.red,
        title: Center(
          child: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Stack(
          children: [
            // Green circle background in upper right position
            Positioned(
              top: -190,
              right: -140,
              child: Container(
                width: 430,
                height: 460,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      //TITLE
                      const Text(
                        'CLARA',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Text(
                        'AN AI JAVA CHATBOT',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      const SizedBox(height: 26),

                      //GET STARTED
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 40.0), // Adjust the left padding as needed
                            child: Text(
                              'Greetings',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 40.0), // Adjust the left padding as needed
                            child: Text(
                              'Sign in your account',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      //EMAIL
                      MyTextField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                        validator: validateEmail,
                      ),
                      const SizedBox(height: 9),
                      MyTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: _obscureTextPassword,
                        suffixIcon: GestureDetector(
                          onTap: _toggleObscureTextPassword,
                          child: Icon(
                            _obscureTextPassword ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),
                        validator: validatePassword,
                      ),
                      const SizedBox(height: 9),
                      MyTextField(
                        controller: confirmPasswordController,
                        hintText: 'Confirm Password',
                        obscureText:_obscureTextConfirmPassword,
                        suffixIcon: GestureDetector(
                          onTap: _toggleObscureTextConfirmPassword,
                          child: Icon(
                            _obscureTextConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),
                        validator: (value) {
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 11),
                      // Sign Up button with conditional behavior
                      GestureDetector(
                        onTap: isAllFieldsFilled()
                            ? () {
                          if (_formKey.currentState!.validate()) {
                            signUserUp(context);
                          }
                        }
                            : null, // Call signUserUp only if agreeToTerms is true
                        child: Container(
                          width: 280.0,
                          height: 55.0,
                          decoration: BoxDecoration(
                            color: isAllFieldsFilled() ? Colors.green : Colors.grey[400], // Change color based on agreement
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Center(
                            child: Text(
                              'Sign Up',
                              style: TextStyle(fontSize: 25.0, color: Colors.white),
                            ),
                          ),
                        ),
                      ),


                      const SizedBox(height: 12),

                      GestureDetector(
                        onTap: () {
                          // Handle Sign Up with Google functionality
                          AuthService().signInWithGoogle();
                        },
                        child: Container(
                          width: 280.0,
                          height: 55.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/google.png', width: 40, height: 40),
                              const SizedBox(width: 3.0),
                              const Text(

                                'Sign Up with Google',
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account?'),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: Text('Sign In',
                              style: TextStyle(
                                color: Colors.green[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
