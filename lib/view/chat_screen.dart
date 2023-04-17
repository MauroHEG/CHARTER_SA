import 'package:charter_appli_travaux_mro/view/services/chat_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/messages.dart';

class ChatScreen extends StatefulWidget {
  final String conversationId;

  ChatScreen({required this.conversationId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
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
                    return Text(messages[index].content);
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
                          senderId:
                              'SENDER_ID', // Remplacer par l'ID de l'utilisateur/administrateur actuel
                          senderType:
                              'SENDER_TYPE', // Remplacer par "client" ou "admin" selon le côté
                          recipientId:
                              'RECIPIENT_ID', // Remplacer par l'ID de l'administrateur ou du client avec qui on discute
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
