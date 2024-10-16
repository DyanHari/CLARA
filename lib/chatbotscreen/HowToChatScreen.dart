import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class HowToChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'How to chat with Clara',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green.shade200,
      ),
      backgroundColor: Colors.green.shade50,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Here are some tips on how to properly send a prompt with Clara:',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: '1. ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'Be specific: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'Clara works best when you ask specific questions or provide clear prompts.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: '2. ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'Use proper grammar and spelling: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'Clara may not understand prompts with poor grammar or spelling.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: '3. ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'Clara focuses on one query at a time: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'Clara cannot remember past conversations or build upon them. Each question you ask Clara should be treated as an independent prompt.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: '4. ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'Avoid using abbreviations or slang: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'Clara may not understand abbreviations or slang that are not commonly used.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: '5. ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'Provide context: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'If your prompt requires context, make sure to provide enough information for Clara to understand.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: '6. ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'Stick to Java-related questions: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'Clara is designed to answer questions related to Java, so please avoid asking questions about other programming languages or unrelated topics.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Examples:',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.close,
                        color: Colors.red,
                        size: screenWidth * 0.05,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'what is java?',
                          style: TextStyle(fontSize: screenWidth * 0.045),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.check,
                        color: Colors.green,
                        size: screenWidth * 0.05,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Can you define what is java?',
                          style: TextStyle(fontSize: screenWidth * 0.045),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '',
                          style: TextStyle(fontSize: screenWidth * 0.01),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.close,
                        color: Colors.red,
                        size: screenWidth * 0.05,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'for loops?',
                          style: TextStyle(fontSize: screenWidth * 0.045),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.check,
                        color: Colors.green,
                        size: screenWidth * 0.05,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Can you explain what is for loops?',
                          style: TextStyle(fontSize: screenWidth * 0.045),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '',
                          style: TextStyle(fontSize: screenWidth * 0.01),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.close,
                        color: Colors.red,
                        size: screenWidth * 0.05,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'objects and classes',
                          style: TextStyle(fontSize: screenWidth * 0.045),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.check,
                        color: Colors.green,
                        size: screenWidth * 0.05,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Can you help me  understand objects and classes?',
                          style: TextStyle(fontSize: screenWidth * 0.045),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '',
                          style: TextStyle(fontSize: screenWidth * 0.01),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.close,
                        color: Colors.red,
                        size: screenWidth * 0.05,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Inheritance in Java?',
                          style: TextStyle(fontSize: screenWidth * 0.045),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.check,
                        color: Colors.green,
                        size: screenWidth * 0.05,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'I want to learn Inheritance can you help me?',
                          style: TextStyle(fontSize: screenWidth * 0.045),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '',
                          style: TextStyle(fontSize: screenWidth * 0.01),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.close,
                        color: Colors.red,
                        size: screenWidth * 0.05,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'polymorphism?',
                          style: TextStyle(fontSize: screenWidth * 0.045),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.check,
                        color: Colors.green,
                        size: screenWidth * 0.05,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Can you provide information about polymorphism in Java?',
                          style: TextStyle(fontSize: screenWidth * 0.045),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '',
                          style: TextStyle(fontSize: screenWidth * 0.01),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.close,
                        color: Colors.red,
                        size: screenWidth * 0.05,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'encapsulation in Java?',
                          style: TextStyle(fontSize: screenWidth * 0.045),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.check,
                        color: Colors.green,
                        size: screenWidth * 0.05,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Can you explain encapsulation in Java?',
                          style: TextStyle(fontSize: screenWidth * 0.045),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}