import 'package:charter_appli_travaux_mro/view/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String currentId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: SafeArea(
        child: Column(
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
                      Message message = messages[index];
                      return FutureBuilder<String>(
                        future: getUserName(message.senderId),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            bool isAdmin = message.senderType == "admin";
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                              child: Column(
                                crossAxisAlignment: isAdmin
                                    ? CrossAxisAlignment.start
                                    : CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    snapshot.data!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: isAdmin
                                          ? Colors.blue.shade100
                                          : Colors.green.shade100,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 12.0,
                                    ),
                                    margin: EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      message.content,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () async {
                      if (_messageController.text.isNotEmpty) {
                        String currentUserId =
                            currentId; // Remplacer cette valeur par l'ID de l'utilisateur actuel
                        String currentUserRole =
                            await getUserRole(currentUserId);
                        String recipientId = currentUserRole == 'admin'
                            ? widget.clientId
                            : widget.adminId;
                        _chatService.sendMessage(
                          Message(
                            senderId: currentUserId,
                            senderType: currentUserRole,
                            recipientId: recipientId,
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
      ),
    );
  }

  Future<String> getUserRole(String userId) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('utilisateurs')
        .doc(userId)
        .get();
    if (userSnapshot.exists) {
      return userSnapshot['role'];
    }
    return 'user';
  }

  Future<String> getUserName(String userId) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('utilisateurs')
        .doc(userId)
        .get();

    DocumentSnapshot clientSnapshot = await FirebaseFirestore.instance
        .collection('clients')
        .doc(userId)
        .get();

    if (userSnapshot.exists) {
      return '${userSnapshot['prenom']} ${userSnapshot['nom']}';
    } else if (clientSnapshot.exists) {
      return '${clientSnapshot['prenom']} ${clientSnapshot['nom']}';
    } else {
      return 'Utilisateur inconnu';
    }
  }
}
