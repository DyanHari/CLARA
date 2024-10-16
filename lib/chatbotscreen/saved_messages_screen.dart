import 'dart:io';
//import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'chat_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SavedMessagesScreen extends StatefulWidget {
  const SavedMessagesScreen({super.key});

  @override
  _SavedMessagesScreenState createState() => _SavedMessagesScreenState();
}

class _SavedMessagesScreenState extends State<SavedMessagesScreen> {
  List<Map<String, dynamic>> _savedMessages = [];
  List<Map<String, dynamic>> _filteredMessages = [];
  String _selectedTimeframe = 'Last 7 days';

  final List<String> _timeframeOptions = ['Today', 'Yesterday', 'Last 7 days'];

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  @override
  void initState() {
    super.initState();
    _loadSavedMessages();
  }

  Future<void> _loadSavedMessages() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/${user.uid}';
      final entities = await Directory(path).list().toList();

      final files = entities.whereType<File>().toList();

      final messages = await Future.wait(
        files.map((file) async {
          final message = await file.readAsString();
          final timestamp = file.lastModifiedSync().millisecondsSinceEpoch; // Convert the timestamp to milliseconds since the epoch
          return {
            'text': message,
            'timestamp': timestamp,
          };
        }).toList(),
      );

      setState(() {
        _savedMessages = messages;
      });

      _filterMessages();
    }
  }

  void _filterMessages() {
    //print('Filtering messages for $_selectedTimeframe');

    List<Map<String, dynamic>> filteredList = [];

    switch (_selectedTimeframe) {
      case 'Today':
        filteredList = _savedMessages.where((message) {
          final date = DateTime.fromMillisecondsSinceEpoch(message['timestamp']);
          final isToday = isSameDay(date, DateTime.now());
          //print('Message "${message['text']}" - Today: $isToday');
          return isToday;
        }).toList();
        break;
      case 'Yesterday':
        filteredList = _savedMessages.where((message) {
          final date = DateTime.fromMillisecondsSinceEpoch(message['timestamp']);
          final isYesterday = isSameDay(date, DateTime.now().subtract(const Duration(days: 1)));
          //print('Message "${message['text']}" - Yesterday: $isYesterday');
          return isYesterday;
        }).toList();
        break;
      case 'Last 7 days':
      default:
        filteredList = _savedMessages.where((message) {
          final date = DateTime.fromMillisecondsSinceEpoch(message['timestamp']);
          final isLast7Days = DateTime.now().difference(date).inDays <= 7;
          //print('Message "${message['text']}" - Last 7 days: $isLast7Days');
          return isLast7Days;
        }).toList();
        break;
    }

    setState(() {
      _filteredMessages = filteredList;
    });
  }



  Future<void> _deleteMessageFile(String messageText) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/${user.uid}';
      final fileName = ChatUI().generateFilename(messageText); // Use ChatUI to generate the filename
      final file = File('$path/$fileName');

      if (await file.exists()) {
        await file.delete();
        setState(() {
          _savedMessages.removeWhere((message) => message == messageText);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: Text(
          'Saved Messages',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.width * 0.04, // Set the font size to 5% of the screen width, for example
            fontWeight: FontWeight.bold, // Set the font weight to bold
          ),
        ),
        backgroundColor: Colors.green.shade200,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Spacer(),DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedTimeframe,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.grey, size: 25,), // Define icon here
                    style: const TextStyle(fontSize: 17, color: Colors.grey),
                    items: _timeframeOptions.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 3), // Add padding here
                          child: Text(value),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedTimeframe = newValue!;
                        _filterMessages();
                      });
                    },
                  ),
                ),
                /*DropdownButtonHideUnderline( // Wrap with DropdownButtonHideUnderline
                  child: DropdownButton2<String>( // Use DropdownButton2
                    value: _selectedTimeframe,
                    iconEnabledColor: Colors.grey,
                    iconSize: 25,
                    style: TextStyle(fontSize: 17, color: Colors.grey),
                    items: _timeframeOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedTimeframe = newValue!;
                        _filterMessages();
                      });
                    },
                    buttonPadding: EdgeInsets.only(right: 7), // Adjust the button padding
                    itemPadding: EdgeInsets.only(right: 3), // Adjust the item padding
                  ),
                ),*/
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredMessages.length,
              itemBuilder: (context, index) {
                final message = _filteredMessages[index];
                final messageText = message['text'];
                final timestamp = DateTime.fromMillisecondsSinceEpoch(message['timestamp']);

                print('Displaying message: $messageText');

                return ChatUI.buildSavedMessageBubble(
                  messageText,
                  timestamp,
                  screenWidth,
                  context,
                      (String messageText) {
                    _deleteMessageFile(messageText);
                    setState(() {
                      _savedMessages.removeWhere((message) => message['text'] == messageText);
                      _filterMessages();
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}