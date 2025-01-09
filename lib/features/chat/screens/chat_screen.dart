// ignore_for_file: avoid_print

import 'package:admin_project/features/core/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatScreenn extends StatefulWidget {
  final String chatroomId;
  final String senderemail;
  final String senderid;

  const ChatScreenn({
    super.key,
    required this.chatroomId,
    required this.senderemail,
    required this.senderid,
  });

  @override
  State<ChatScreenn> createState() => _ChatScreennState();
}

class _ChatScreennState extends State<ChatScreenn> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final ChatService _chatService = ChatService();

  final TextEditingController _controller = TextEditingController();
  void _sendMessage() async {
    print("Sending message...");
    if (_controller.text.isNotEmpty) {
      try {
        await _chatService.sendMessage(
            widget.chatroomId, 'admin', _controller.text, widget.senderemail);
        _controller.clear();
        print("Message sent successfully.");
      } catch (e) {
        print("Failed to send message: $e");
      }
    }
  }

  void _deleteMessage(String chatRoomId, String messageId) async {
    try {
      await _chatService.deleteMessage(chatRoomId, messageId);
      print("Message deleted successfully.");
    } catch (e) {
      print("Failed to delete message: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: home,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: lightPrimary,
            )),
        backgroundColor: home,
        toolbarHeight: 80,
        titleSpacing: 20,
        automaticallyImplyLeading: false,
        title: Text(
          widget.senderemail,
          style:
              const TextStyle(color: lightPrimary, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessagelist(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessagelist() {
    return StreamBuilder(
      stream: _chatService.getMessages(widget.chatroomId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error ${snapshot.error}");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("loading....");
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("No messages yet"),
          );
        }
        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.message,
                    color: blackcolor,
                    size: 30,
                  ),
                  hintText: 'Type a message.....',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: blackcolor,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: blackcolor,
                      width: 2.0,
                    ),
                  ),
                  suffixIcon: IconButton(
                    color: blackcolor,
                    iconSize: 35,
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      _sendMessage();
                      print('ChatRoom ID: ${widget.chatroomId}');
                      print('Sender ID: ${widget.senderid}');
                      print('Sender Email: ${widget.senderemail}');
                    },
                  )),
            ),
          ),
        ],
      ),
    );
  }

  String? adminId;

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    const String currentUserId = 'admin';
    bool isSentByMe = data['senderid'] == currentUserId;
    String messageId = document.id;
    bool isDeletded = data['isdeleted'] ?? false;
    if (isDeletded) {
      return Container(
        alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(
          'This message was deleted',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: grey,
          ),
        ),
      );
    }
    return Dismissible(
      key: Key(messageId),
      direction:
          isSentByMe ? DismissDirection.endToStart : DismissDirection.none,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: blackcolor,
            title: const Text(
              'Delete Message',
              style: TextStyle(color: blackcolor),
            ),
            content: const Text(
              'Are you sure you want to delete this message?',
              style: TextStyle(color: blackcolor),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: blackcolor),
                ),
              ),
              TextButton(
                onPressed: () {
                  _deleteMessage(widget.chatroomId, messageId);
                  Navigator.of(context).pop(true);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ).then((value) {
          if (value) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  backgroundColor: blackcolor,
                  content: Center(
                      child: Text(
                    'Message deleted',
                    style: TextStyle(
                        color: blackcolor, fontWeight: FontWeight.bold),
                  ))),
            );
          }
          return value;
        });
      },
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: Align(
        alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: ChatBubble(
          message: data['message'],
          timestamp: data['timestamp'],
          isSentByMe: isSentByMe,
        ),
      ),
    );
  }
}

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String chatRoomId, String senderId, String message,
      String senderEmail) async {
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        senderId: senderId,
        senderemail: senderEmail,
        message: message,
        timestamp: timestamp,
        isDeleted: false);

    // String chatRoomId = senderId;

    await _firestore
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());
  }

  Future<void> deleteMessage(String chatRoomId, String messageId) async {
    await _firestore
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("messages")
        .doc(messageId)
        .delete();
  }

  Stream<QuerySnapshot> getMessages(String chatRoomId) {
    return _firestore
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getUserChats(String adminId) {
    return _firestore
        .collection('chatRoom')
        .where('participants', arrayContains: adminId)
        .snapshots();
  }
}

class Message {
  final String senderId;
  final String senderemail;
  final String message;
  final Timestamp timestamp;
  final bool isDeleted;

  Message(
      {required this.senderId,
      required this.senderemail,
      required this.message,
      required this.timestamp,
      required this.isDeleted});

  Map<String, dynamic> toMap() {
    return {
      'senderid': senderId,
      'senderemail': senderemail,
      'message': message,
      'timestamp': timestamp,
      'isdeleted': isDeleted
    };
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final Timestamp timestamp;
  final bool isSentByMe;

  const ChatBubble({
    super.key,
    required this.message,
    required this.timestamp,
    required this.isSentByMe,
  });

  @override
  Widget build(BuildContext context) {
    DateTime date = timestamp.toDate();
    String formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(date);

    return Container(
      margin: isSentByMe
          ? const EdgeInsets.only(left: 50, top: 10, bottom: 10, right: 10)
          : const EdgeInsets.only(right: 50, top: 10, bottom: 10, left: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: isSentByMe
            ? LinearGradient(
                colors: [chatgradient, chatgradient2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [button1, button2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: isSentByMe
            ? const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              )
            : const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: isSentByMe ? whitecolor : whitecolor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            formattedDate,
            style: TextStyle(
              fontSize: 12,
              color: isSentByMe ? whitecolor : whitecolor,
            ),
          ),
        ],
      ),
    );
  }
}
