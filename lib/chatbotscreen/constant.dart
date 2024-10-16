import 'suggestion.dart';

const String contextString = "<start_of_turn>(Act as 'Clara' a chatbot only for learning Java so you should not answer questions if its not about Java.The context of my question is always about Java.)  user ";
const String endString = "<end_of_turn>";
const String startOfTurn = "  <start_of_turn>model"; // Added two spaces for separation

String combinedString = endString + startOfTurn;




final List<Suggestion> allSuggestions = [
  Suggestion("String Concatenation", "Can you explain string concatenation in Java?"),
  Suggestion("Data Types", "What are the different data types in Java?"),
  Suggestion("Variables", "Can you tell me about variables in Java?"),
  Suggestion("Hello World Program", "How do I create a hello world program"),
  Suggestion("For Loop", "Can you teach me about for loops in Java?"),
  Suggestion("If-Else Statements", "Could you explain if-else statements in Java?"),
  Suggestion("Arrays", "What are arrays in Java and how do I use them?"),
  Suggestion("Objects and Classes", "What is objects and classes in Java?"),
  Suggestion("Inheritance", "Could you tell me more about inheritance in Java?"),
  Suggestion("While Loop", "Can you explain while loops in Java?"),
];
