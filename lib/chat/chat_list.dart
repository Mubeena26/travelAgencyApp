import 'package:admin_project/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatLitsshow extends StatefulWidget {
  const ChatLitsshow({super.key});

  @override
  State<ChatLitsshow> createState() => _ChatLitsshowState();
}

class _ChatLitsshowState extends State<ChatLitsshow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const Icon(
          Icons.chat,
          color: Colors.black,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 176, 217, 233),
        title: Text(
          'CHATS',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 176, 217, 233),
                const Color.fromARGB(255, 219, 243, 255),
                const Color.fromARGB(255, 115, 173, 204)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: buildChatRoomList()),
    );
  }

  Widget buildChatRoomList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chatRoom').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final List<DocumentSnapshot> chatRooms = snapshot.data!.docs;

        return ListView.builder(
          itemCount: chatRooms.length,
          itemBuilder: (context, index) {
            final chatroom = chatRooms[index];
            return StreamBuilder<QuerySnapshot>(
              stream: chatroom.reference
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .limit(1)
                  .snapshots(),
              builder: (context, messageSnapshot) {
                if (messageSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (messageSnapshot.hasError) {
                  return Center(child: Text('Error: ${messageSnapshot.error}'));
                }

                if (!messageSnapshot.hasData ||
                    messageSnapshot.data!.docs.isEmpty) {
                  return const ListTile(
                    title: Text('No messages'),
                  );
                }

                final messageDoc = messageSnapshot.data!.docs.first;
                final data = messageDoc.data()! as Map<String, dynamic>;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Card(
                    color: const Color.fromARGB(255, 41, 182, 246),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        data['senderemail'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        data['message'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Text(
                          //   DateFormat('hh:mm a').format(
                          //     (data['timestamp'] as Timestamp).toDate(),
                          //   ),
                          //   style: const TextStyle(color: black54),
                          // ),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              print("Navigating to ChatScreen with:");
                              print("Chatroom ID: ${chatroom.id}");
                              print("Sender Email: ${data['senderemail']}");
                              print("Sender ID: ${data['senderid']}");
                              return ChatScreenn(
                                chatroomId: chatroom.id,
                                senderemail: data['senderemail'],
                                senderid: data['senderid'],
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
