import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';


String selectedImagePath = 'assets/image1.png'; // Default image path

class AccountPictureSelection extends StatefulWidget {
  final Function(String) onImageSelected;

  AccountPictureSelection({required this.onImageSelected});

  @override
  _AccountPictureSelectionState createState() => _AccountPictureSelectionState();
}

class _AccountPictureSelectionState extends State<AccountPictureSelection> {
  String _selectedImagePath = selectedImagePath; // Set the default image path

  List<String> imagePaths = [
    'assets/image1.png',
    'assets/image2.png',
    'assets/image3.png',
    'assets/image4.png',
    'assets/image5.png',
    'assets/image6.png',
    'assets/image7.png',
    'assets/image8.png',
    'assets/image9.png',
    'assets/image10.png',
    'assets/image11.png',
    'assets/image12.png',
    'assets/image13.png',
    'assets/image14.png',
    'assets/image15.png',
    'assets/image16.png',
  ];

  Future<void> _selectImage(String imagePath) async {
    setState(() {
      _selectedImagePath = imagePath;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userEmail = user.email ?? 'user@email.com';
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedImagePath_$userEmail', imagePath);
    }

    // Call the callback function
    widget.onImageSelected(imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Change 'yourColor' to the color you want
      appBar: AppBar(
        title: Text(
          'Select Account Picture',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.width * 0.04, // Set the font size to 5% of the screen width, for example
            fontWeight: FontWeight.bold, // Set the font weight to bold
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        backgroundColor: Colors.green.shade200, // Change 'yourColor' to the color you want
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage(_selectedImagePath),
            ),
            SizedBox(height: 75),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                children: List.generate(imagePaths.length, (index) {
                  return IconButton(
                    onPressed: () => _selectImage(imagePaths[index]),
                    icon: Image.asset(
                      imagePaths[index],
                      width: MediaQuery.of(context).size.width * 0.15, // Set the width to 15% of the screen width, for example
                      height: MediaQuery.of(context).size.height * 0.15, // Set the height to 15% of the screen width, for example
                    ),
                  );
                }),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                selectedImagePath = _selectedImagePath; // Update the selected image path
                Navigator.pop(context); // Pop the AccountPictureSelection widget

                // Show a SnackBar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Changes saved successfully!',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04, // Set the font size to 5% of the screen width, for example
                        color: Colors.black, // Set the text color
                      ),
                    ),
                    backgroundColor: Colors.green.shade50,
                    duration: Duration(seconds: 3), // Set the duration of the SnackBar
                  ),
                );
              },
              child: Text(
                'Confirm',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04, // Set the font size to 5% of the screen width, for example
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width * 0.5, 50), // Set the width to 50% of the screen width, for example
                backgroundColor: Colors.green.shade50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}