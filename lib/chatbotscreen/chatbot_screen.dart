import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'chat_ui.dart';
import 'dialogs.dart';
import 'utilities.dart';
import 'api_service.dart';
import 'constant.dart';
import 'message.dart';
import 'suggestion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_history_manager.dart';
import 'suggestion_cards.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'account_picture_selection.dart';
import 'knowledge_base.dart';

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> with SingleTickerProviderStateMixin {
  bool _isScrollingUp = false;

  void deleteConversation() {
    _chatHistoryManager.deleteConversation().then((_) {
      _chatHistoryManager.loadChatHistory().then((_) {
        ChatUI.clearMessagesAndNavigate(context, _messages, _textController);
      });
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void updateMessagesWithChatHistory() {
    setState(() {
      _messages.clear();
      _messages.addAll(_currentChatHistory);
    });
  }

  void _toggleSuggestions() {
    setState(() {
      _showSuggestions = !_showSuggestions;
      if (_showSuggestions) {
        _randomSuggestions = getRandomSuggestions(3);
      }
    });
  }

  final _chatHistoryManager = ChatHistoryManager();
  final knowledgeBase = KnowledgeBase();

  List<Message> _currentChatHistory = [];

  final FocusNode _inputFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final List<Message> _messages = [];
  final FocusNode _textFieldFocusNode = FocusNode(); // Add this line
  bool _isProcessing = false;
  late AnimationController _controller;
  bool _showSuggestions = false;
  List<Suggestion> _randomSuggestions = [];
  String? _uid;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (mounted) {
          setState(() {
            _isScrollingUp = true;
          });
        }
      }
      if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (mounted) {
          setState(() {
            _isScrollingUp = false;
          });
        }
      }
    });
    _getUid().then((_) {
      // Move the call to loadChatHistory() inside the _getUid() callback
      _chatHistoryManager.loadChatHistory().then((_) {
        if (mounted) {
          setState(() {
            _currentChatHistory = _chatHistoryManager.chatHistory;
          });
          updateMessagesWithChatHistory();

          _getUserEmail().then((email) {
            if (mounted) {
              _userEmail = email;
            }
          });
          // Add this block of code to scroll to the bottom of the list.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
            }
          });
        }
      });
    });

    if (mounted) {
      _showSuggestions = true;
      _randomSuggestions = getRandomSuggestions(3);
      _controller = AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: this,
      )..repeat(reverse: true);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showWelcomeDialog(context);
        }
      });
    }
  }

  Future<void> _getUid() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _uid = user.uid;
    }
  }

  Future<String?> _getUserEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.email;
    }
    return null;
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _textFieldFocusNode.dispose(); // Add this line
    super.dispose();
  }

  void _addMessageAndScroll(Message message) {
    setState(() {
      _messages.add(message);
      _chatHistoryManager.addMessage(message); //firestore
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  void _addErrorMessageAndScroll(String errorMessage) {
    setState(() {
      _messages.add(Message(text: errorMessage, isUser: false, timestamp: DateTime.now()));
    });
    _scrollToBottom();
  }

  void _showAccountPictureSelection(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AccountPictureSelection(
          onImageSelected: (String imagePath) {
            setState(() {
              selectedImagePath = imagePath;
            });
          },
        );
      },
    );
  }

  Future<String> getSelectedImagePath() async {
    final user = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();
    if (user != null) {
      final userEmail = user.email ?? 'user@email.com';
      return prefs.getString('selectedImagePath_$userEmail') ?? 'assets/image1.png';
    }
    return 'assets/image1.png';
  }

  Future<void> _sendMessageWithPrompt(String inputText) async {
    _textController.clear();
    try {
      if (inputText.isNotEmpty) {
        // Check if the input text contains any of the Java-related keywords
        bool inmyKnowledgeBase = false;
        for (String keyword in knowledgeBase.javaKeywords) {
          if (inputText.toLowerCase().contains(keyword.toLowerCase())) {
            inmyKnowledgeBase = true;
            break;
          }
        }

        // Check if the input text contains any of the non-Java keywords
        bool containsNonJavaKeyword = false;
        for (String keyword in knowledgeBase.nonJavaKeywords) {
          if (inputText.toLowerCase().contains(keyword.toLowerCase())) {
            containsNonJavaKeyword = true;
            break;
          }
        }

        // Add the user's message to the chat history
        final userMessage = Message(text: inputText, isUser: true, timestamp: DateTime.now());
        _addMessageAndScroll(userMessage);

        if (inmyKnowledgeBase && !containsNonJavaKeyword) {
          _isProcessing = true;
          _showSuggestions = false;

          Future.delayed(Duration(milliseconds: 300), () {
            FocusScope.of(context).requestFocus(_inputFocusNode);
          });

          final generatedText = await ApiService.sendMessageWithPrompt(contextString,inputText,combinedString);

          final responseText = generatedText.replaceFirst('$contextString', '').trim();

          final userInput = responseText.replaceFirst('$inputText', '').trim();

          final prompt = userInput.replaceFirst('$combinedString', '').trim();

          final Message responseMessage = Message(text: prompt, isUser: false, timestamp: DateTime.now());
          _addMessageAndScroll(responseMessage);
          _isProcessing = false;
          _textController.clear();
          _inputFocusNode.unfocus();

          if (_messages.last.text.isEmpty) {
            _messages.removeLast();
          }
        } else if (containsNonJavaKeyword) {
          _addErrorMessageAndScroll('Oops! I didn\'t quite get that. Please ask a question related to Java.');
          _scrollToBottom();
        } else {
          _addErrorMessageAndScroll('I am very sorry my knowledge base is limited to Java only. Please ask a question related to Java.');
          _scrollToBottom();
        }
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
      showErrorSnackBar(context, errorMessage);
    }
  }





  void _sendSuggestion(Suggestion suggestion) {
    _sendMessageWithPrompt(suggestion.description);
    setState(() {
      _showSuggestions = false;
    });
    _textFieldFocusNode.unfocus(); // Add this line
  }

  Widget _buildSuggestionCards(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Let\'s Get Chatty! 💬',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045, // Adjust the font size based on screen width
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Java Ice Breakers',
                      style: TextStyle(
                        fontSize: screenWidth * 0.035, // Adjust the font size based on screen width
                        fontWeight: FontWeight.normal,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0.01, // Adjust the right position
                top: 0.01, // Adjust the top position
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showSuggestions = false;
                    });
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.red, // Set the color to red
                    size: screenWidth * 0.045, // Adjust the icon size based on screen width
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: _randomSuggestions.length,
          itemBuilder: (BuildContext context, int index) {
            final suggestion = _randomSuggestions[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: SuggestionCard(
                  title: suggestion.title,
                  description: suggestion.description,
                  onTap: () => _sendSuggestion(suggestion),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.green.shade200,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green.shade200,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
            title: ChatUI.buildAppBarTitle(context),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu, color: Colors.black),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            elevation: 0,
          ),
        ),
      ),
      drawer: FutureBuilder<String>(
        future: getSelectedImagePath(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Provide a default value when snapshot.data is null
            final selectedImagePath = snapshot.data ?? 'assets/image1.png';
            return _userEmail != null
                ? ChatUI.buildDrawer(
              context,
              deleteConversation,
              _chatHistoryManager,
              selectedImagePath,
              _showAccountPictureSelection,
              _userEmail!,
            )
                : Container();
          }
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      ListView.builder(
                        controller: _scrollController,
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          return ChatUI.buildMessageBubble(message, screenWidth, context, ChatUI());
                        },
                      ),
                      Visibility(
                        visible: _isScrollingUp && _scrollController.position.pixels != _scrollController.position.maxScrollExtent,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                                setState(() {
                                  _isScrollingUp = false;
                                });
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.green.shade600,
                                radius: screenWidth * 0.05,
                                child: Icon(
                                  Icons.arrow_downward,
                                  color: Colors.white,
                                  size: screenWidth * 0.04,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    if (_showSuggestions)
                      Column(
                        children: [
                          _buildSuggestionCards(screenWidth, screenHeight)
                        ],
                      ),
                  ],
                ),
                if (_isProcessing)
                  ChatUI.buildProcessingIndicator(screenWidth),
              ],
            ),
          ),
          Container(
            height: screenHeight * 0.1,
            width: screenWidth * 0.95,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.lightbulb),
                  onPressed: _toggleSuggestions,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Stack(
                      children: [
                        Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.shade700.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                        TextField(
                          controller: _textController,
                          focusNode: _textFieldFocusNode, // Add this line
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(.8),
                            hintText: 'Type your message...',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.green.shade700,
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.green.shade700,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.green.shade700,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                          ),
                          maxLines: null,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.green.shade900),
                  onPressed: _isProcessing
                      ? null
                      : () {
                    final inputText = _textController.text.trim();
                    if (inputText.isNotEmpty) {
                      _sendMessageWithPrompt(inputText);
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: 10,
        child: BottomAppBar(
          color: Colors.green.shade200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ),
      ),
    );
  }
}

class SuggestionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final String description;

  const SuggestionButton({
    required this.onPressed,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(screenWidth * 0.7, screenHeight * 0.10),
        backgroundColor: Colors.white.withOpacity(1),
        foregroundColor: Colors.black,
        side: BorderSide(color: Colors.green.withOpacity(1)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: screenWidth * 0.025,
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
