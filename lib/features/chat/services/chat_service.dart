import 'package:admin_project/features/chat/components/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverId, String message) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        senderId: currentUserId,
        senderemail: currentUserEmail,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp);

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _firestore
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getUserChats(String userId) {
    return _firestore
        .collection('chatRoom')
        .where('messages.senderId',
            isEqualTo: userId) // Query for senderId in messages
        .snapshots()
        .map((snapshot) {
      snapshot.docs.forEach((doc) {
        // Log each document data
        print('Fetched chat room: ${doc.data()}');
      });
      return snapshot; // Return the snapshot if needed elsewhere
    });
  }
}
