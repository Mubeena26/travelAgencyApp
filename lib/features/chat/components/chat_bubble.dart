import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderemail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  Message(
      {required this.senderId,
      required this.senderemail,
      required this.receiverId,
      required this.message,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'senderid': senderId,
      'senderemail': senderemail,
      'recieverid': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
