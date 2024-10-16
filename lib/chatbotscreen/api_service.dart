import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class ApiService {
  static Future<Map<String, dynamic>> getApiConfig() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('api_config')
        .doc('gemma')
        .get();
    final data = snapshot.data();
    if (data != null && data.containsKey('link') && data.containsKey('auth_token')) {
      return {
        'link': data['link'],
        'auth_token': data['auth_token'],
      };
    }
    throw Exception('API configuration not found');
  }

  // Define your temperature values
  static const List<double> temperatures = [0.1, 0.5, 1.2, 1.25, 1.5, 1.55];


  static Future<String> sendMessageWithPrompt(String inputText, String contextString, String combinedString) async {
    final config = await getApiConfig();
    final _baseUrl = config['link'];
    final _authorization = 'Bearer ${config['auth_token']}';

    // Generate a random index and temperature value inside the method
    final Random _random = Random();
    final int randomIndex = _random.nextInt(temperatures.length);
    final double randomTemperature = temperatures[randomIndex];

    final headers = {'Content-Type': 'application/json', 'Authorization': _authorization};
    final data = '''
    {
      "inputs": "$contextString $inputText $combinedString",
      "parameters": {
        "max_new_tokens": 600,
        "temperature": $randomTemperature
      }
    }
    ''';

    final response = await http.post(Uri.parse(_baseUrl), headers: headers, body: data);

    if (response.statusCode != 200) {
      throw Exception('Failed to load response please try again later!');
    }

    final jsonResponse = jsonDecode(response.body);
    final generatedText = jsonResponse[0]['generated_text'];

    return generatedText;
  }
}