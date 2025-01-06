// chat_event.dart
import 'package:cloud_firestore/cloud_firestore.dart';

// chat_state.dart
abstract class ChatState {}

class ChatInitialState extends ChatState {}

class ChatLoadingState extends ChatState {}

class ChatLoadedState extends ChatState {
  final List<DocumentSnapshot> messages;
  ChatLoadedState(this.messages);
}

class ChatErrorState extends ChatState {
  final String error;
  ChatErrorState(this.error);
}
