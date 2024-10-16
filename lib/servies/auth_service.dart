import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loggingg/chatbotscreen/chat_history_manager.dart'; // Import the ChatHistoryManager class

class AuthService {
  final chatHistoryManager = ChatHistoryManager(); // Create an instance of ChatHistoryManager

  // Google sign in
  signInWithGoogle() async {
    // Interactive sign-in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // Obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    // New credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // Sign in
    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    // Clear the chat history when a new user signs in
    if (userCredential.user != null) {
      await chatHistoryManager.loadChatHistory();
    }

    return userCredential;
  }

  // Sign out method
  static Future<void> signUserOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut(); // Sign out from Google as well

    // Clear the chat history when the user signs out
    final chatHistoryManager = ChatHistoryManager();
    await chatHistoryManager.clearChatHistory();
  }
}
