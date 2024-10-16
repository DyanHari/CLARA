import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loggingg/chatbotscreen/chatbot_screen.dart';
import 'package:loggingg/servies/auth_service.dart';
import 'package:loggingg/textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'forgot_password.dart';
import 'package:loggingg/chatbotscreen/chat_history_manager.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final chatHistoryManager = ChatHistoryManager();
  bool _obscureText = true; // Add a boolean variable for password visibility
  bool rememberMe = false; // Add a boolean variable for remember me

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String adminEmail = 'admin@clara.com';
  String adminPassword = 'adminclara';

  // Add a method to handle remember me functionality
  void _handleRememberMe(bool? newValue) async {
    setState(() {
      rememberMe = newValue!;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (newValue!) {
      // Store user credentials securely (e.g., using shared preferences)
      // Example using shared preferences:
      await prefs.setBool('rememberMe', true);
      await prefs.setString('email', emailController.text);
      await prefs.setString('password', passwordController.text);
    } else {
      // Clear stored credentials
      // Example using shared preferences:
      await prefs.remove('rememberMe');
      await prefs.remove('email');
      await prefs.remove('password');
    }
  }

  // @override
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  //signuser in method
  Future<void> signUserIn(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool('rememberMe') ?? false;
    String? storedEmail = prefs.getString('email');
    String? storedPassword = prefs.getString('password');

    if (rememberMe && storedEmail != null && storedPassword != null) {
      emailController.text = storedEmail;
      passwordController.text = storedPassword;
    }

    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    Future<bool> isAdmin(String email, String password) async {
      if (email == adminEmail && password == adminPassword) {
        return true;
      }
      return false;
    }

    if (emailController.text == adminEmail && passwordController.text == adminPassword) {
      print('Logged in as admin');
    }

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (emailController.text == adminEmail && passwordController.text == adminPassword) {
        print('Logged in as admin');
      } else {
        // Check if the user's email is verified
        if (!userCredential.user!.emailVerified) {
          // If the email is not verified, sign the user out and show an error message
          await FirebaseAuth.instance.signOut();
          Navigator.pop(context); // Close the loading dialog
          showErrorMessage('Please verify your email before logging in.');
          return;
        }
      }

      // Clear the chat history for the new user
      await chatHistoryManager.clearChatHistory();

      // Load the chat history after successful sign-in
      await chatHistoryManager.loadChatHistory();

      // Pop the loading circle
      if (mounted) {
        Navigator.pop(context);
      }

      // Navigate to the next page after successful login
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChatbotScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      print('error:${e.code}');
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        print('No user found for that email or the password is incorrect');
        showErrorMessage(
            'No user found for that email or the password is incorrect');
      } else if (e.code == 'invalid-email') {
        print('The email address is badly formatted');
        showErrorMessage('The email address is badly formatted');
      } else {
        print('An unknown error occured: ${e.code}');
        showErrorMessage('An unknown error occured: ${e.code}');
      }
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 14.0),
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
                child: Column(
                  children: [
                    const SizedBox(height: 70),
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

                    const SizedBox(height: 51),

                    //GET STARTED
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 40.0), // Adjust the left padding as needed
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
                          padding: EdgeInsets.only(
                              left: 40.0), // Adjust the left padding as needed
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
                    ),

                    const SizedBox(height: 20),
                    //PASSWORD
                    MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: _obscureText,
                      suffixIcon: GestureDetector(
                        onTap: _toggleObscureText,
                        child: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    // REMEMBERME & FORGOT PASSWORD
                    Padding(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row(
                        children: [
                          Expanded(
                            // Wrap "Remember me" in Expanded
                            flex:
                            1, // Set flex ratio for fixed width (e.g., 2 parts)
                            child: Row(
                              // Nest another Row for checkbox and text
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: rememberMe,
                                  onChanged: _handleRememberMe,
                                ),
                                const Text('Remember me'),
                              ],
                            ),
                          ),
                          Expanded(
                            // Wrap "Forgot Password" in Expanded
                            flex: 1,
                            // Set flex ratio for remaining space (e.g., 3 parts)
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return const ForgotPasswordPage();
                                    }));
                              },
                              child: const Text(
                                'Forgot Password',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            // child: Text(
                            //   'Forgot Password',
                            //   style: TextStyle(
                            //     color: Colors.grey,
                            //     fontWeight: FontWeight.w500,
                            //   ),
                            //   textAlign: TextAlign.right, // Align text to the right
                            // ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    // LOG IN BUTTON
                    // VIA GMAIL

                    // Sign Up button
                    GestureDetector(
                      onTap: () async {
                        // Handle Sign Up functionality
                        // (e.g., navigate to sign up screen)
                        await signUserIn(context);
                      },
                      child: Container(
                        width: 280.0,
                        height: 55.0,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Center(
                          child: Text(
                            'Sign in',
                            style:
                            TextStyle(fontSize: 25.0, color: Colors.white),
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
                            Image.asset('assets/google.png',
                                width: 40, height: 40),
                            const SizedBox(width: 3.0),
                            const Text(
                              'Sign In with Google',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Dont have an account?'),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            'Sign Up',
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
          ],
        ),
      ),
    );
  }
}
