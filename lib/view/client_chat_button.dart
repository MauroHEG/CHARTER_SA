import 'dart:async';

import 'package:charter_appli_travaux_mro/view/services/conversation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

class ClientChatButton extends StatefulWidget {
  const ClientChatButton({super.key});

  @override
  _ClientChatButtonState createState() => _ClientChatButtonState();
}

class _ClientChatButtonState extends State<ClientChatButton> {
  final ConversationService _conversationService = ConversationService();
  final ValueNotifier<int> _unreadMessages = ValueNotifier<int>(0);
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  @override
  void initState() {
    super.initState();
    _fetchUnreadMessages();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Stream<int> _fetchUnreadMessages() async* {
    String clientId = FirebaseAuth.instance.currentUser!.uid;

    QuerySnapshot adminSnapshot = await FirebaseFirestore.instance
        .collection('utilisateurs')
        .where('role', isEqualTo: 'admin')
        .limit(1)
        .get();

    if (adminSnapshot.docs.isNotEmpty) {
      String adminId = adminSnapshot.docs.first.id;

      String conversationId =
          await _conversationService.getOrCreateConversation(clientId, adminId);

      yield* FirebaseFirestore.instance
          .collection('conversations/$conversationId/messages')
          .where('isRead', isEqualTo: false)
          .where('senderId', isEqualTo: adminId)
          .snapshots()
          .map((snapshot) => snapshot.docs.length);
    } else {
      yield 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _unreadMessages,
      builder: (context, unreadCount, child) {
        return ElevatedButton(
          onPressed: () async {
            // Marquer les messages comme lus lors de l'accès au chat
            _unreadMessages.value = 0;

            // La logique pour accéder au chat reste la même
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
                  builder: (BuildContext context) => ChatScreen(
                    conversationId: conversationId,
                    adminId: adminId,
                    clientId: clientId,
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Aucun administrateur trouvé"),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: unreadCount > 0
                ? Colors.orange
                : const Color(
                    0xFF7BF853), // Couleur du bouton lorsqu'il n'y a pas de messages non lus
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(30), // Rayon de la bordure arrondie
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 30, vertical: 15), // Padding du bouton
            textStyle: const TextStyle(fontSize: 18), // Taille du texte
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Discuter avec un administrateur',
                style: TextStyle(color: Colors.black),
              ),
              if (unreadCount > 0)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      '$unreadCount',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
