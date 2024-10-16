import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutClaraPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Clara',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green.shade200, // Update the app bar color
      ),
      backgroundColor: Colors.green.shade50, // Update the background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Clara is an artificial intelligence (AI) chatbot powered by a pre-trained large language model (LLM) known as Gemma, created by Google. Clara is designed to facilitate user acquisition of Java programming language concepts and provide comprehensive explanations on a wide range of Java topics.',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Developed by:',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'John Paolo P. Coyoca\nJohn Harry M. Duavis\nJasmin P. Perolina\nJC Lhyn Aniar\nMichael John P. Arevalo\nKaile Lorde M. Malimban',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Clara is a thesis project by a team of six computer science students at Cavite State University.',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'To learn more about Gemma, the large language model that powers Clara, visit the Google Developers Blog.',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}