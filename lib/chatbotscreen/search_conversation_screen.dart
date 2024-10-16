import 'package:flutter/material.dart';
import 'message.dart';
import 'chat_history_manager.dart';
import 'chat_ui.dart';

class SearchConversationScreen extends StatefulWidget {
  @override
  _SearchConversationScreenState createState() => _SearchConversationScreenState();
}

class _SearchConversationScreenState extends State<SearchConversationScreen> {
  final ChatHistoryManager _chatHistoryManager = ChatHistoryManager();
  List<Message> _searchResults = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchResults = _chatHistoryManager.chatHistory;
  }

  void _performSearch(String query) {
    List<Message> results = _chatHistoryManager.chatHistory
        .where((message) => message.text.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.green.shade200, // Match the background color
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green.shade200, // Match the background color of the AppBar
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
            title: ChatUI.buildAppBarTitle(context), // Use the custom AppBar title
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _performSearch,
              decoration: InputDecoration(
                hintText: 'Search conversation...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final message = _searchResults[index];
                return ChatUI.buildMessageBubble(message, screenWidth, context, ChatUI(),);
              },
            ),
          ),
        ],
      ),
    );
  }
}