import 'dart:math';
import 'package:flutter/material.dart';
import 'constant.dart';
import 'suggestion.dart';

List<Suggestion> getRandomSuggestions(int count) {
  List<Suggestion> suggestions = List.from(allSuggestions); // Create a copy of the suggestions list
  List<Suggestion> randomSuggestions = []; // Create an empty list to store random suggestions
  Random random = Random();

  for (int i = 0; i < count; i++) {
    int index = random.nextInt(suggestions.length);
    randomSuggestions.add(suggestions.removeAt(index));
  }

  return randomSuggestions;
}

void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ),
  );
}