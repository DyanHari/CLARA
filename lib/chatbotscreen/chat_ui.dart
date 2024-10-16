import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loggingg/chatbotscreen/HowToChatScreen.dart';
import 'package:loggingg/screens/authpage.dart';
import 'package:loggingg/servies/auth_service.dart';
import 'account_picture_selection.dart';
import 'dialogs.dart';
import 'message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_history_manager.dart';
import 'chatbot_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'saved_messages_screen.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'about_clara.dart';
import 'search_conversation_screen.dart';
import 'admin_panel_page.dart';

class ChatUI {
  static Widget buildAppBarTitle(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double maxWidth = constraints.maxWidth;
        double fontSize = maxWidth * 0.07;
        fontSize = max(fontSize, 30.0);
        fontSize = min(fontSize, 30.0);

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'CLARA',
              style: GoogleFonts.montserrat(
                color: Colors.black,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            Text(
              'AN AI JAVA CHATBOT',
              style: GoogleFonts.montserrat(
                color: Colors.black,
                fontSize: fontSize * 0.4,
                letterSpacing: 1.5,
              ),
            ),
          ],
        );
      },
    );
  }



  static void updateSelectedImagePath(String newImagePath) {
    selectedImagePath = newImagePath;
  }

  static void clearMessagesAndNavigate(BuildContext context,
      List<Message> messages, TextEditingController textController) {
    // Clear the messages and the text controller
    messages.clear();
    textController.clear();

    // Navigate to a new instance of ChatbotScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ChatbotScreen()),
    );
  }

  String generateFilename(String messageText) {
    var bytes = utf8.encode(messageText);
    var digest = md5.convert(bytes);
    return '${digest.toString()}.txt';
  }

  Future<void> downloadMessage(String messageText) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/${user.uid}';
      final fileName = generateFilename(messageText);
      final file = File('$path/$fileName');

      await Directory(path).create(recursive: true);
      await file.writeAsString(messageText);
    }
  }


  static Widget buildProcessingIndicator(double screenWidth) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.green.shade50,
              // Set background color to transparent
              backgroundImage: AssetImage('assets/bot_avatar.png'),
            ),
            SizedBox(width: 8.0),
            Row(
              children: List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Text(
                    '.',
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildSavedMessageBubble(
    String messageText,
    DateTime timestamp,
    double screenWidth,
    BuildContext context,
    Function(String) onDelete,
  ) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: screenWidth * 0.97,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(
                  right: screenWidth * 0.001,
                  bottom: screenWidth * 0.01,
                ),
                child: Text(
                  DateFormat('yyyy-MM-dd – kk:mm').format(timestamp),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: screenWidth * 0.03,
                  ),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 0.1),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('assets/bot_avatar.png'),
                  ),
                ),
                Flexible(
                  child: Stack(
                    children: [

                      Container(
                        padding: EdgeInsets.all(23.5),
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0),
                            bottomLeft: Radius.zero,
                            bottomRight: Radius.circular(15.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.35),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText.rich(
                              formatText(messageText, screenWidth),
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: GoogleFonts.roboto().fontFamily,
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.normal,
                              ),
                            ),

                          ],
                        ),
                      ),
                      Positioned(
                        top: screenWidth * 0.005,
                        right: screenWidth * 0.02,
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          iconSize: screenWidth * 0.04,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Delete message'),
                                  content: Text(
                                      'Are you sure you want to delete this message?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Delete'),
                                      onPressed: () {
                                        onDelete(messageText);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ],
        ),


      ),
    );
  }

  static TextSpan formatText(String text, double screenWidth) {
    final List<InlineSpan> children = [];
    final List<String> parts = text.split('```');

    for (int i = 0; i < parts.length; i++) {
      final String part = parts[i];

      if (i % 2 == 1) {
        children.add(WidgetSpan(
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: SelectableText(
              part,
              style: TextStyle(
                fontFamily: 'monospace',
                color: Colors.black,
                fontSize:
                    screenWidth * 0.03, // Set font size based on screen width
              ),
            ),
          ),
        ));
      } else {
        final List<String> boldParts = part.split('**');
        for (int j = 0; j < boldParts.length; j++) {
          final String boldPart = boldParts[j];

          if (j % 2 == 1) {
            children.add(TextSpan(
                text: boldPart,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth *
                        0.03))); // Set font size based on screen width
          } else {
            children.add(TextSpan(
                text: boldPart,
                style: TextStyle(
                    fontSize: screenWidth *
                        0.03))); // Set font size based on screen width
          }
        }
      }
    }

    return TextSpan(children: children);
  }

  static Widget buildMessageBubble(Message message, double screenWidth,
      BuildContext context, ChatUI chatUI,) {
    return Stack(
      children: [
        Align(
          alignment:
              message.isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth * 0.97,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: message.isUser
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                if (!message.isUser)
                  Padding(
                    padding: const EdgeInsets.only(right: 0.1),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage('assets/bot_avatar.png'),
                    ),
                  ),
                Flexible(
                  child: Container(
                    padding: message.isUser
                        ? EdgeInsets.all(12.0)
                        : EdgeInsets.all(23.5),
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: message.isUser ? Colors.green : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(message.isUser ? 15.0 : 0.0),
                        topRight: Radius.circular(message.isUser ? 15.0 : 15.0),
                        bottomLeft:
                            Radius.circular(message.isUser ? 15.0 : 15.0),
                        bottomRight:
                            Radius.circular(message.isUser ? 0.0 : 15.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.35),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText.rich(
                          formatText(message.text, screenWidth),
                          style: TextStyle(
                            color: message.isUser ? Colors.white : Colors.black,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!message.isUser)
          Positioned(
            top: screenWidth * 0.005,
            right: screenWidth * 0.025,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PopupMenuButton<String>(
                icon: Icon(Icons.more_vert,
                    color: Colors.green.shade600, size: screenWidth * 0.05),
                onSelected: (value) {
                  if (value == 'copy') {
                    Clipboard.setData(ClipboardData(text: message.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Text copied to clipboard'),
                        backgroundColor: Colors.green.shade500,
                      ),
                    );
                  } else if (value == 'download') {
                    chatUI.downloadMessage(message.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Message downloaded'),
                        backgroundColor: Colors.green.shade500,
                      ),
                    );
                  } else if (value == 'reply') {

                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'copy',
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.copy, color: Colors.green.shade600, size: 18.0),
                        SizedBox(width: 8.0),
                        Text('Copy message', style: TextStyle(fontSize: 16.0)),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'download',
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.download, color: Colors.green.shade600, size: 18.0),
                        SizedBox(width: 8.0),
                        Text('Download message', style: TextStyle(fontSize: 16.0)),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'reply',
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.reply, color: Colors.green.shade600, size: 18.0),
                        SizedBox(width: 8.0),
                        Text('Reply', style: TextStyle(fontSize: 16.0)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }






  static Widget buildDrawer(
      BuildContext context,
      VoidCallback onNewChat,
      ChatHistoryManager chatHistoryManager,
      String selectedImagePath,
      Function(BuildContext) onShowAccountPictureSelection,
      String userEmail,
      ) {
    final chatHistoryManager = ChatHistoryManager();
    final chatHistory = chatHistoryManager.chatHistory;
    final user = FirebaseAuth.instance.currentUser;
    String email = user != null ? user.email ?? 'user@email.com' : 'user@email.com';

    return Drawer(
      child: LayoutBuilder(
        builder: (BuildContext drawerContext, BoxConstraints constraints) {
          final double maxWidth = constraints.maxWidth;
          final double fontSize = maxWidth * 0.05;


          return Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.green.shade200,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0), // Adjust the opacity to change the shadow intensity
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.grey.withOpacity(0.2)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      widthFactor: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              onShowAccountPictureSelection(context);
                            },
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage(selectedImagePath),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            email,
                            style: TextStyle(fontSize: fontSize * 1, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: ListView(
                    children: [
                      ListTile(
                        leading: Icon(Icons.save, color: Colors.green), // Change the color of the icon for Saved Messages
                        title: Text("Saved Messages"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SavedMessagesScreen()),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.delete, color: Colors.red), // Change the color of the icon for Delete Conversation
                        title: Text("Delete Conversation"),
                        onTap: () async {
                          final shouldDeleteConversation =
                          await showDeleteConversationConfirmationDialog(context);
                          if (shouldDeleteConversation) {
                            // Delete the conversation and log out the user
                            chatHistoryManager.deleteConversation();
                            await AuthService.signUserOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => AuthPage())
                            );
                          }
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.search),
                        title: Text("Search in Conversation"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SearchConversationScreen()),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.help_outline, color: Colors.blue), // Change the color of the icon to your preference
                        title: Text("How to chat with Clara"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HowToChatScreen()),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.info_outline, color: Colors.blue), // Change the color of the icon for About Clara
                        title: Text("About Clara"),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AboutClaraPage()));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (userEmail == 'admin@clara.com') // Check if the user is an admin
                ListTile(
                  title: Text('Admin Panel'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminPanelPage()),
                    );
                  },
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  title: Text("Logout"),
                  leading: Icon(Icons.exit_to_app),
                  onTap: () async {
                    await chatHistoryManager.clearChatHistory();
                    await FirebaseAuth.instance.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  AuthPage()),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
