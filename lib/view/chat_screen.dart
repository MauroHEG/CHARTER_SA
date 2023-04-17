import 'package:charter_appli_travaux_mro/view/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/messages.dart';

class ChatScreen extends StatefulWidget {
  final String conversationId;
  final String adminId;
  final String clientId;

  ChatScreen(
      {required this.conversationId,
      required this.adminId,
      required this.clientId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream:
                  _chatService.getConversationMessages(widget.conversationId),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Message>> snapshot) {
                if (snapshot.hasError) {
                  return Text('Erreur : ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                List<Message> messages = snapshot.data!;

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final message = messages[index];
                    final isClient = message.senderId == widget.clientId;
                    final senderNameFuture = isClient
                        ? _firestore
                            .collection('utilisateurs')
                            .doc(widget.clientId)
                            .get()
                        : _firestore
                            .collection('utilisateurs')
                            .doc(widget.adminId)
                            .get();

                    return FutureBuilder<DocumentSnapshot>(
                      future: senderNameFuture,
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Erreur : ${snapshot.error}');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        String senderName =
                            '${snapshot.data!['prenom']} ${snapshot.data!['nom']}';
                        return Column(
                          crossAxisAlignment: isClient
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.end,
                          children: [
                            Text(senderName,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(message.content),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Écrire un message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      _chatService.sendMessage(
                        Message(
                          senderId: widget.adminId,
                          senderType: 'admin',
                          recipientId: widget.clientId,
                          content: _messageController.text,
                          timestamp: DateTime.now(),
                        ),
                        widget.conversationId,
                      );
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
