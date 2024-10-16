import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> showWelcomeDialog(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final showWelcome = prefs.getBool('showWelcome') ?? true;


  if (showWelcome) {
    // Show a brief welcome dialog
    final screenSize = MediaQuery
        .of(context)
        .size;
    final dialogWidth = screenSize.width * 0.8;
    final dialogHeight = screenSize.height * 0.6;
    final textScaleFactor = screenSize.width < 600 ? 1.4 : 1.0;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text('Welcome, Learner! 🎓 ', style: TextStyle(
                fontSize: 16 * textScaleFactor, fontWeight: FontWeight.bold),),
          ),
          content: Padding(
            padding: EdgeInsets.all(dialogWidth * 0.005),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: dialogHeight * 0.04,),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(fontSize: 14 * textScaleFactor),
                      children: [
                        TextSpan(
                            text: '👋 Hi there!  I\'m Clara, your friendly AI Java Chatbot, and I\'m here to assist you on your Java journey!  '),
                        TextSpan(
                            text: 'Feel free to ask me anything related to Java, and I\'ll do my best to guide you through it.'),
                      ],
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                  'Next', style: TextStyle(fontSize: 15 * textScaleFactor)),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: dialogWidth * 0.05,
                    vertical: dialogHeight * 0.02),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the welcome dialog
                showInstructionsDialog(context); // Show the instructions dialog
              },
            ),
          ],
          backgroundColor: Colors.green.shade50,
        );
      },
    );
  }
}

Future<void> showInstructionsDialog(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final showInstructions = prefs.getBool('showInstructions') ?? true;

  if (showInstructions) {
    // Show additional instructions dialog
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth = screenSize.width * 0.8;
    final dialogHeight = screenSize.height * 0.6;
    final textScaleFactor = screenSize.width < 600 ? 1.4 : 1.0;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        bool doNotShowAgain = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Center(
                child: Text('How to chat with Clara 💬', style: TextStyle(fontSize: 14 * textScaleFactor, fontWeight: FontWeight.bold),),
              ),
              content: Padding(
                padding: EdgeInsets.all(dialogWidth * 0.005),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: dialogHeight * 0.04,),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(fontSize: 14 * textScaleFactor),
                          children: [
                            TextSpan(text: 'Please be specific with your questions so I can provide the best possible answer. '),
                            TextSpan(text: '\n'),
                            TextSpan(text: '\n'),
                            TextSpan(
                              text: '❌What is Java? ',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                            ),
                            TextSpan(text: '\n'),
                            TextSpan(
                              text: '✅Can you give me the definition of Java?',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                            TextSpan(text: '\n\n'),
                            TextSpan(
                              text: 'You can check out "How to chat with Clara" in the drawer for more information.',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      //crossAxisAlignment: CrossAxisAlignment.start, // Align the text to the start of the Row
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Checkbox(
                              value: doNotShowAgain,
                              onChanged: (newValue) {
                                setState(() {
                                  doNotShowAgain = newValue!;
                                });
                              },
                            ),
                            Text('Do not show this again', style: TextStyle(fontSize: 13 * textScaleFactor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Got it!', style: TextStyle(fontSize: 15 * textScaleFactor)),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: dialogWidth * 0.05, vertical: dialogHeight * 0.02),
                  ),
                  onPressed: () async {
                    if (doNotShowAgain) {
                      await prefs.setBool('showInstructions', false);
                      await prefs.setBool('showWelcome', false);
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
              backgroundColor: Colors.green.shade50,
            );
          },
        );
      },
    );
  }
}


Future<bool> showDeleteConversationConfirmationDialog(BuildContext context) async {
  final screenSize = MediaQuery.of(context).size;
  final dialogWidth = screenSize.width * 0.8;
  final dialogHeight = screenSize.height * 0.6;
  final textScaleFactor = screenSize.width < 600 ? 1.4 : 1.0;

  return await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Center(
          child: Text('Delete Conversation', style: TextStyle(fontSize: 16 * textScaleFactor, fontWeight: FontWeight.bold),),
        ),
        content: Padding(
          padding: EdgeInsets.all(dialogWidth * 0.005),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: dialogHeight * 0.04,),
                Text(
                  'Are you sure you want to delete the entire conversation history? This action cannot be undone. Please note that you will be logged out, and the changes will take effect after you log back in.',
                  style: TextStyle(fontSize: 15 * textScaleFactor),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel', style: TextStyle(fontSize: 15 * textScaleFactor)),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: dialogWidth * 0.05, vertical: dialogHeight * 0.02),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: Text('Delete', style: TextStyle(fontSize: 15 * textScaleFactor)),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: dialogWidth * 0.05, vertical: dialogHeight * 0.02),
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
        backgroundColor: Colors.red.shade50,
      );
    },
  ) ?? false;
}