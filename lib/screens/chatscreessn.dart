import 'package:flutter/material.dart';
import 'package:loggingg/servies/auth_service.dart';
import 'message.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class ChatbotScreen extends StatefulWidget {
ChatbotScreen({super.key});

  final AuthService _authService = AuthService();

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class Suggestion {
  final String title;
  final String description;

  Suggestion(this.title, this.description);
}

class _ChatbotScreenState extends State<ChatbotScreen> with SingleTickerProviderStateMixin {
  final FocusNode _inputFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final List<Message> _messages = []; // List of Message objects
  bool _isProcessing = false; // Flag to indicate if waiting for bot response
  final List<Suggestion> _allSuggestions = [
    Suggestion("String Concatenation", "Can you explain string concatenation in Java?"),
    Suggestion("Data Types", "What are the different data types in Java?"),
    Suggestion("Variables", "Can you tell me about variables in Java?"),
    Suggestion("Hello World Program", "How do I create a hello world program in Java?"),
    Suggestion("For Loop", "Can you teach me about for loops in Java?"),
    Suggestion("If-Else Statements", "Could you explain if-else statements in Java?"),
    Suggestion("Arrays", "What are arrays in Java and how do I use them?"),
    Suggestion("Objects and Classes", "Can you help me understand objects and classes in Java?"),
    Suggestion("Inheritance", "Could you tell me more about inheritance in Java?"),
    Suggestion("While Loop", "Can you explain while loops in Java?"),
  ];

  late AnimationController _controller;

  final String contextString = ".Remember, you are Clara and if this is a phatic conversation, just answer this as usual. Otherwise, the context of the conversation is Java programming language";
  bool _showSuggestions = false; // Flag to track suggestions visibility
  List<Suggestion> _randomSuggestions = []; // List to store the randomized suggestions

  @override
  void initState() {
    super.initState();
    _showSuggestions = true;
    _randomSuggestions = _getRandomSuggestions(3); // Generate 3 random suggestions
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    // Add the following line to show the welcome dialog when the app is launched
    WidgetsBinding.instance.addPostFrameCallback((_) => _showWelcomeDialog(context));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _showWelcomeDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Clara'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Hi, I am Clara, an AI Java Chatbot.'),
                Text('I can help you in your Java learning journey.'),
                Text('Just ask me any questions related to Java, and I will do my best to answer them.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog when the user presses the button
              },
            ),
          ],
        );
      },
    );
  }

  List<Suggestion> _getRandomSuggestions(int count) {
    List<Suggestion> suggestions = List.from(_allSuggestions); // Create a copy of the suggestions list
    Random random = Random();

    for (int i = 0; i < count; i++) {
      int index = random.nextInt(suggestions.length);
      _randomSuggestions.add(suggestions.removeAt(index));
    }

    return _randomSuggestions;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _sendMessage(String inputText) async {
    try {
      if (inputText.isNotEmpty) {
        setState(() {
          _messages.add(Message(text: inputText, isUser: true)); // Add user message
          _isProcessing = true;
          _scrollController.animateTo( // Scroll to the bottom of the list
            _scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
        });

        final headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer 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',
        };

        final data = '''{
          "inputs": "$inputText",
          "parameters": {
            "max_new_tokens": 600
          }
        }''';
        final url = Uri.parse('https://api-inference.huggingface.co/models/google/gemma-2b-it');

        print('Sending request to API with data: $data');

        final res = await http.post(url, headers: headers, body: data);
        final status = res.statusCode;

        print('API response status code: $status');

        if (status != 200) throw Exception(
            'http.post error: statusCode= $status');

        final jsonResponse = jsonDecode(res.body);
        final generatedText = jsonResponse[0]['generated_text'];

        print('API response: $generatedText');

        setState(() {
          _messages.add(Message(text: generatedText, isUser: false)); // Add bot message
          _isProcessing = false;
          _textController.clear();
          _scrollController.animateTo( // Scroll to the bottom of the list
            _scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
          if (_messages.last.text.isEmpty) {
            _messages.removeLast();
          }
        });

        _inputFocusNode.unfocus();
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      String errorMessage;
      if (e is SocketException) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (e is FormatException) {
        errorMessage = 'Invalid response format. Please try again later.';
      } else {
        errorMessage = 'An unknown error occurred. Please try again later.';
      }
      _showErrorSnackBar(errorMessage);
      print('Error: $e');
    }
  }

  Future<void> _sendMessageWithPrompt(String inputText) async {
    _textController.clear();
    try {
      if (inputText.isNotEmpty) {
        setState(() {
          _messages.add(Message(text: inputText, isUser: true)); // Add user message
          _isProcessing = true;
          _showSuggestions = false;
          _scrollController.animateTo( // Scroll to the bottom of the list
            _scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
        });

        Future.delayed(Duration(milliseconds: 300), () {
          FocusScope.of(context).requestFocus(_inputFocusNode);
        });

        final headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer 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',
        };

        final data = '''{
          "inputs": "$inputText $contextString",
          "parameters": {
            "max_new_tokens": 600
          }
        }''';
        final url = Uri.parse(
            'https://api-inference.huggingface.co/models/google/gemma-2b-it');

        print('Sending request to API with data: $data');

        final res = await http.post(url, headers: headers, body: data);
        final status = res.statusCode;

        print('API response status code: $status');

        if (status != 200) throw Exception(
            'http.post error: statusCode= $status');

        final jsonResponse = jsonDecode(res.body);
        final generatedText = jsonResponse[0]['generated_text'];

        print('API response: $generatedText');

        setState(() {
          _messages.add(Message(text: generatedText, isUser: false)); // Add bot message
          _isProcessing = false;
          _textController.clear();
          _scrollController.animateTo( // Scroll to the bottom of the list
            _scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
          if (_messages.last.text.isEmpty) {
            _messages.removeLast();
          }
        });

        _inputFocusNode.unfocus();
      }
    }  catch (e) {
      setState(() {
        _isProcessing = false;
      });
      String errorMessage;
      if (e is SocketException) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (e is FormatException) {
        errorMessage = 'Invalid response format. Please try again later.';
      } else {
        errorMessage = 'An unknown error occurred. Please try again later.';
      }
      _showErrorSnackBar(errorMessage);
      print('Error: $e');
    }
  }

  void _sendSuggestion(Suggestion suggestion) {
    _sendMessage(suggestion.description); // Pass the suggestion description to _sendMessage
    setState(() {
      _showSuggestions = false; // Hide suggestions after clicking one
    });
  }

  Widget _buildAppBarTitle(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double maxWidth = constraints.maxWidth;
        double fontSize = maxWidth * 0.07; // Start with 7% of the max width

        // Set a minimum font size of 20.0
        fontSize = max(fontSize, 30.0);

        // Set a maximum font size of 30.0
        fontSize = min(fontSize, 30.0);

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('CLARA',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
            SizedBox(height: 0.5),
            Text('AN AI JAVA CHATBOT',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: fontSize * 0.4,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProcessingIndicator(double screenWidth) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/bot_avatar.png'),
            ),
            SizedBox(width: 8.0),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Row(
                  children: List.generate(3, (index) {
                    double dotOpacity = 1.0;
                    if (_controller.status == AnimationStatus.forward) {
                      dotOpacity = index == _controller.value.floor() ? 1.0 : 0.3;
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Opacity(
                        opacity: dotOpacity,
                        child: Text(
                          '.',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: _buildAppBarTitle(context),
        centerTitle: true,
        backgroundColor: Colors.green.shade400,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController, // Assign the controller here
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return Align(
                        alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: screenWidth * 0.97, // Set max width to 70% of screen width
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                            children: [
                              if (!message.isUser)
                                Padding(
                                  padding: const EdgeInsets.only(right: 0.1),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage('assets/images/bot_avatar.png'),
                                  ),
                                ),
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.all(12.0),
                                  margin: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: message.isUser ? Colors.green : Colors.white,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Text(
                                    message.text,
                                    style: TextStyle(
                                      color: message.isUser ? Colors.white : Colors.black,
                                      fontFamily: GoogleFonts.roboto().fontFamily,
                                      fontSize: screenWidth * 0.035,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (_showSuggestions)
                  Column(
                    children: _randomSuggestions.map((suggestion) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          height: screenHeight * 0.13, // Increase the height to accommodate both title and description
                          width: screenWidth * 0.7,
                          child: ElevatedButton(
                            onPressed: () => _sendSuggestion(suggestion),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  suggestion.title,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.05, // Adjust the font size as needed
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  suggestion.description,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035, // Adjust the font size as needed
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(1),
                              foregroundColor: Colors.black,
                              side: BorderSide(color: Colors.green.withOpacity(1)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                if (_isProcessing)
                  _buildProcessingIndicator(screenWidth), // Use the updated _buildProcessingIndicator method
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            height: screenHeight * 0.07,
            width: screenWidth * 0.9,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    focusNode: _inputFocusNode, // Assign the FocusNode here
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(.8),
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.green.shade700,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.green.shade700,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.green.shade700,
                          width: 2.5,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send, color: Colors.green.shade700),
                        onPressed: _isProcessing ? null : () => _sendMessageWithPrompt(_textController.text),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 10,
        child: BottomAppBar(
          color: Colors.green.shade50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double maxWidth = constraints.maxWidth;
          final double fontSize = maxWidth * 0.05;

          return Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  "Username",
                  style: TextStyle(fontSize: fontSize, color: Colors.white),
                ),
                accountEmail: Text(
                  "user@email.com",
                  style: TextStyle(fontSize: fontSize * 0.8, color: Colors.white),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://www.cio.com/wp-content/uploads/2023/08/chatbot_ai_machine-learning_emerging-tech-100778305-orig.jpg?quality=50&strip=all&w=1024"),
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      title: Text("Chat History"),
                      onTap: () => Navigator.pushNamed(context, '/chatHistory'),
                    ),
                    Divider(),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  title: Text("Logout"),
                  leading: Icon(Icons.exit_to_app),
                  onTap: () async {
                    await AuthService.signUserOut();
                    Navigator.pushReplacementNamed(context, '/LoginPage'); // Replace '/login' with your desired route
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