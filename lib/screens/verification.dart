import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:loggingg/chatbotscreen/chatbot_screen.dart';
import 'package:loggingg/screens/login.dart';

class VerifyPage extends StatefulWidget {
  final String email;

  const VerifyPage({super.key, required this.email});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  bool _resendButtonEnabled = true;
  int _timer = 120;
  bool _isLinkExpired = false;

  @override
  void initState() {
    super.initState();
    checkEmailVerification();
  }

  Future<void> checkEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  ChatbotScreen()),
      );
    } else {
      Timer(const Duration(seconds: 60), () {
        setState(() {
          _isLinkExpired = true;
        });
      });
    }
  }


  Future<void> resendEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    }
  }

  void _toggleResendButton() {
    setState(() {
      _resendButtonEnabled = !_resendButtonEnabled;
      if (!_resendButtonEnabled) {
        _timer = 120;
        _isLinkExpired = false;
      }
    });
    if (!_resendButtonEnabled) {
      Timer.periodic(const Duration(seconds: 1), (Timer t) {
        setState(() {
          if (_timer < 1) {
            t.cancel();
            _resendButtonEnabled = true;
          } else {
            _timer = _timer - 1;
          }
        });
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body:  SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 0.0, left: 00.0, right: 00.0, top: 0.0), // Adjust padding as needed
                    child: Text(
                      'CLARA',
                      style: TextStyle(
                        letterSpacing: 3.0,
                        color: Colors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const Text(
                    'AN AI JAVA CHATBOT',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 23),
                  Column( // Arrange elements vertically
                    children: [
                      Container( // Existing container with green circle and image
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/Verification.png',
                          width: 50, // Adjust width as needed
                          height: 50,
                        ),
                      ),
                      const SizedBox(height: 22), // Add some spacing
                      // const Text(
                      //   'Verify your email address',
                      //   style: TextStyle(
                      //     color: Colors.black,
                      //     fontSize: 25,
                      //     fontWeight: FontWeight.w900,
                      //   ),
                      // ),
                      // const Text(
                      //   'In order to start your',
                      //   style: TextStyle(
                      //     color: Colors.black,
                      //     fontSize: 17,
                      //   ),
                      // ),
                      // const Text(
                      //   'learning experience in Java,',
                      //   style: TextStyle(
                      //     color: Colors.black,
                      //     fontSize: 17,
                      //   ),
                      // ),
                      // const Text(
                      //   'you need to verify your email.',
                      //   style: TextStyle(
                      //     color: Colors.black,
                      //     fontSize: 15,
                      //   ),
                      // ),
                      const SizedBox(height: 23),
                      // const Text(
                      //   "All good! Once you verify, you're just a click away from logging in.",
                      //   style: TextStyle(
                      //     color: Colors.black,
                      //     fontSize: 13,
                      //   ),
                      // ),
                      //const SizedBox(height: 18),
                      // Text(
                      //   'You will receive an email with the verification link. If an account exists with "${widget.email}", make sure to check your junk or spam folders as well.',
                      //   style: TextStyle(
                      //     color: Colors.black,
                      //     fontSize: 13,
                      //   ),
                      // ),
                      RichText(
                        textAlign: TextAlign.center, // Center align the text
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 21,
                          ),
                          children: <TextSpan>[
                            const TextSpan(text: 'You will receive an email with the verification link. If an account exists with '),
                            TextSpan(
                              text: widget.email,
                              style: const TextStyle(fontWeight: FontWeight.bold), // Make email bold
                            ),
                            const TextSpan(text: ', make sure to check your '),
                            const TextSpan(
                              text: 'junk or spam folders',
                              style: TextStyle(fontWeight: FontWeight.bold), // Make 'junk or spam folders' bold
                            ),
                            const TextSpan(text: ' as well.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 60),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage(onTap: () {  },),
                              ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          minimumSize: const Size(224, 48),
                          textStyle: const TextStyle(fontSize: 25.0),
                        ),
                        child: const Text('Proceed to Login'),
                      ),
                      const SizedBox(height: 15),

                      TextButton(
                        onPressed: _isLinkExpired && _resendButtonEnabled ? () async {
                          await resendEmailVerification();
                          _toggleResendButton();
                        } : null,
                        child: _resendButtonEnabled
                            ? const Text('Resend email verification link')
                            : Text('Resend in $_timer seconds'),
                      ),
                      /*Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      TextButton(
                        onPressed: () {,
                        ),
                        ],
                      ),*/
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
//
// class VerifyPage extends StatefulWidget {
//   final String email;
//
//   const VerifyPage({super.key, required this.email});
//
//   @override
//   State<VerifyPage> createState() => _VerifyPageState();
// }
//
// class _VerifyPageState extends State<VerifyPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[300],
//       body:  SafeArea(
//         child: Stack(
//           children: [
//             Center(
//               child: Column(
//                 children: [
//                   const SizedBox(height: 20),
//                   const Padding(
//                     padding: EdgeInsets.only(bottom: 0.0, left: 00.0, right: 00.0, top: 0.0), // Adjust padding as needed
//                     child: Text(
//                       'CLARA',
//                       style: TextStyle(
//                         letterSpacing: 3.0,
//                         color: Colors.black,
//                         fontSize: 40,
//                         fontWeight: FontWeight.w900,
//                       ),
//                     ),
//                   ),
//                   const Text(
//                     'AN AI JAVA CHATBOT',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 13,
//                       fontWeight: FontWeight.w900,
//                     ),
//                   ),
//                   const SizedBox(height: 23),
//                   Column( // Arrange elements vertically
//                     children: [
//                       Container( // Existing container with green circle and image
//                         width: 120,
//                         height: 120,
//                         decoration: BoxDecoration(
//                           color: Colors.green.shade50,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Image.asset(
//                           'assets/images/Verification.png',
//                           width: 50, // Adjust width as needed
//                           height: 50,
//                         ),
//                       ),
//                       const SizedBox(height: 20), // Add some spacing
//                       const Text(
//                         'Verify your email address',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 25,
//                           fontWeight: FontWeight.w900,
//                         ),
//                       ),
//                       const Text(
//                         'In order to start your',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 15,
//                         ),
//                       ),
//                       const Text(
//                         'learning experience in Java,',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 15,
//                         ),
//                       ),
//                       const Text(
//                         'you need to verify your email.',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 15,
//                         ),
//                       ),
//                       const SizedBox(height: 23),
//                       const Text(
//                         "Enter your OTP code number",
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: Colors.black,
//                         ),
//                       ),
//                        Text(
//                         //${emailAddress.text}
//                         widget.email,
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       const SizedBox(height: 18),
//                       //EMAIL
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                         child: TextField(
//
//                           decoration: InputDecoration(
//                               enabledBorder:  OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(14.0),
//                                 borderSide: const BorderSide(color: Colors.white),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12.0),
//                                 borderSide: BorderSide(color: Colors.grey.shade400),
//                               ),
//                               fillColor: Colors.grey.shade200,
//                               filled: true,
//                               hintText: '0123',
//                               hintStyle: TextStyle(color: Colors.grey[500])),
//                         ),
//                       ),
//                       const SizedBox(height: 18),
//                       ElevatedButton(
//                         onPressed: () {
//                         },
//                         child: const Text('Verify Email'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                           minimumSize: const Size(224, 48),
//                           textStyle: const TextStyle(fontSize: 25.0),
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       const Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text('Resend the code in '),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }






// tamang ui verification
// import 'package:flutter/material.dart';
//
// class VerifyPage extends StatelessWidget {
//   const VerifyPage({super.key, required String email});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[300],
//       body:  SafeArea(
//         child: Stack(
//           children: [
//             Center(
//               child: Column(
//                 children: [
//                   const SizedBox(height: 20),
//                   const Padding(
//                     padding: EdgeInsets.only(bottom: 0.0, left: 00.0, right: 00.0, top: 0.0), // Adjust padding as needed
//                     child: Text(
//                       'CLARA',
//                       style: TextStyle(
//                         letterSpacing: 3.0,
//                         color: Colors.black,
//                         fontSize: 40,
//                         fontWeight: FontWeight.w900,
//                       ),
//                     ),
//                   ),
//                   const Text(
//                     'AN AI JAVA CHATBOT',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 13,
//                       fontWeight: FontWeight.w900,
//                     ),
//                   ),
//                   const SizedBox(height: 23),
//                   Column( // Arrange elements vertically
//                     children: [
//                       Container( // Existing container with green circle and image
//                         width: 120,
//                         height: 120,
//                         decoration: BoxDecoration(
//                           color: Colors.green.shade50,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Image.asset(
//                           'assets/images/Verification.png',
//                           width: 50, // Adjust width as needed
//                           height: 50,
//                         ),
//                       ),
//                       const SizedBox(height: 20), // Add some spacing
//                       const Text(
//                         'Verify your email address',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 25,
//                           fontWeight: FontWeight.w900,
//                         ),
//                       ),
//                       const Text(
//                         'In order to start your',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 15,
//                         ),
//                       ),
//                       const Text(
//                         'learning experience in Java,',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 15,
//                         ),
//                       ),
//                       const Text(
//                         'you need to verify your email.',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 15,
//                         ),
//                       ),
//                       const SizedBox(height: 23),
//                       const Text(
//                         "Enter your OTP code number",
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: Colors.black,
//                         ),
//                       ),
//                       const Text(
//                         //${emailAddress.text}
//                         "examplename@gmail.com",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       const SizedBox(height: 18),
//                       //EMAIL
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                         child: TextField(
//
//                           decoration: InputDecoration(
//                               enabledBorder:  OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(14.0),
//                                 borderSide: const BorderSide(color: Colors.white),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12.0),
//                                 borderSide: BorderSide(color: Colors.grey.shade400),
//                               ),
//                               fillColor: Colors.grey.shade200,
//                               filled: true,
//                               hintText: '0123',
//                               hintStyle: TextStyle(color: Colors.grey[500])),
//                         ),
//                       ),
//                       const SizedBox(height: 18),
//                       ElevatedButton(
//                         onPressed: () {
//                         },
//                         child: const Text('Verify Email'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                           minimumSize: const Size(224, 48),
//                           textStyle: const TextStyle(fontSize: 25.0),
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       const Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text('Resend the code in '),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }