import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPanelPage extends StatefulWidget {
  @override
  _AdminPanelPageState createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    ApiConfigurationPage(),
    KnowledgeBaseUpdatePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Panel')),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'API Configuration',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Knowledge Base',
          ),
        ],
      ),
    );
  }
}

class ApiConfigurationPage extends StatefulWidget {
  @override
  _ApiConfigurationPageState createState() => _ApiConfigurationPageState();
}

class _ApiConfigurationPageState extends State<ApiConfigurationPage> {
  final _apiFormKey = GlobalKey<FormState>();
  final _apiLinkController = TextEditingController();
  final _authTokenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to the API Configuration Page. Here you can update the API configuration for Clara.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Text(
            'Note: Clara is an application that is compatible only with Gemma models hosted on Hugging Face. You can find the Gemma model releases on Hugging Face using the following link:',
            style: TextStyle(fontSize: 16),
          ),
          GestureDetector(
            onTap: () {
              // Add your link opening logic here
            },
            child: Text(
              'https://huggingface.co/collections/google/gemma-release-65d5efbccdbb8c4202ec078b',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline),
            ),
          ),
          SizedBox(height: 16.0),
          Form(
            key: _apiFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'API Link:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _apiLinkController,
                  decoration: InputDecoration(
                    labelText: 'New API Link',
                    hintText: 'Example: https://api-inference.huggingface.co/models/google/gemma-1.1-7b-it',
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      return null;
                    }
                    return 'Please enter a valid API link';
                  },
                ),
                SizedBox(height: 16.0),
                Text(
                  'Authorization Token:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _authTokenController,
                  decoration: InputDecoration(
                    labelText: 'New Authorization Token',
                    hintText: 'Example: hf_AbcDTnEfGvlIhijStjMUwXmBo2ygLdWTrF',
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      return null;
                    }
                    return 'Please enter a valid authorization token';
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    final newApiLink = _apiLinkController.text.isNotEmpty
                        ? _apiLinkController.text
                        : null;
                    final newAuthToken = _authTokenController.text.isNotEmpty
                        ? _authTokenController.text
                        : null;

                    if (newApiLink != null || newAuthToken != null) {
                      final batch = FirebaseFirestore.instance.batch();
                      final docRef = FirebaseFirestore.instance
                          .collection('api_config')
                          .doc('gemma');

                      if (newApiLink != null) {
                        batch.update(docRef, {'link': newApiLink});
                      }

                      if (newAuthToken != null) {
                        batch.update(docRef, {'auth_token': newAuthToken});
                      }

                      await batch.commit();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('API configuration updated')),
                      );
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class KnowledgeBaseUpdatePage extends StatefulWidget {
  @override
  _KnowledgeBaseUpdatePageState createState() => _KnowledgeBaseUpdatePageState();
}

class _KnowledgeBaseUpdatePageState extends State<KnowledgeBaseUpdatePage> {
  final _javaFormKey = GlobalKey<FormState>();
  final _javaKeywordsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to the Knowledge Base Update Page. Here you can add new Java keywords to Clara\'s knowledge base.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Form(
            key: _javaFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New knowledge:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _javaKeywordsController,
                  decoration: InputDecoration(
                    labelText: '',
                    hintText: '',
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      return null;
                    }
                    return 'Please enter a valid keyword';
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_javaFormKey.currentState!.validate()) {
                      final newJavaKeyword = _javaKeywordsController.text;

                      final docRef = FirebaseFirestore.instance
                          .collection('keywords')
                          .doc('java');

                      await docRef.update({
                        'keywords': FieldValue.arrayUnion([newJavaKeyword]),
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Knowledge Base Updated')),
                      );

                      _javaKeywordsController.clear();
                    }
                  },
                  child: Text('Update Knowledge'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('keywords')
                .doc('java')
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (!snapshot.hasData || snapshot.data!.data() == null) {
                return Text('No keywords found');
              }

              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
              List<String> keywords = List<String>.from(data['keywords']);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Added Knowledge:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  for (String keyword in keywords)
                    Dismissible(
                      key: Key(keyword),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                        ),
                      ),
                      onDismissed: (direction) async {
                        final docRef = FirebaseFirestore.instance
                            .collection('keywords')
                            .doc('java');

                        await docRef.update({
                          'keywords': FieldValue.arrayRemove([keyword]),
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Knowledge removed')),
                        );
                      },
                      child: ListTile(
                        title: Text(keyword.replaceAll('"', '')),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}