import 'package:charter_appli_travaux_mro/view/services/conversation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

class ClientChatButton extends StatefulWidget {
  @override
  _ClientChatButtonState createState() => _ClientChatButtonState();
}

class _ClientChatButtonState extends State<ClientChatButton> {
  final ConversationService _conversationService = ConversationService();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text('Discuter avec un administrateur'),
      onPressed: () async {
        String clientId = FirebaseAuth.instance.currentUser!.uid;

        QuerySnapshot adminSnapshot = await FirebaseFirestore.instance
            .collection('utilisateurs')
            .where('role', isEqualTo: 'admin')
            .limit(1)
            .get();

        if (adminSnapshot.docs.isNotEmpty) {
          String adminId = adminSnapshot.docs.first.id;

          String conversationId = await _conversationService
              .getOrCreateConversation(clientId, adminId);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  ChatScreen(conversationId: conversationId),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Aucun administrateur trouvé"),
            ),
          );
        }
      },
    );
  }
}
