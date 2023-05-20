import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../view/chat_screen.dart';

class AdminConversationsScreen extends StatefulWidget {
  const AdminConversationsScreen({super.key});

  @override
  _AdminConversationsScreenState createState() =>
      _AdminConversationsScreenState();
}

class _AdminConversationsScreenState extends State<AdminConversationsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String adminId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conversations"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('conversations')
            .where('participants', arrayContains: adminId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              String clientId = document['participants'].firstWhere(
                  (participant) => participant != adminId,
                  orElse: () => '');
              String conversationId = document.id;

              return FutureBuilder<DocumentSnapshot>(
                future:
                    _firestore.collection('utilisateurs').doc(clientId).get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Erreur : ${snapshot.error}");
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.data!.exists) {
                    // Si l'utilisateur n'existe pas, renvoyez un widget vide
                    return SizedBox.shrink();
                  }

                  return ListTile(
                    title: Text(
                        "${snapshot.data!['prenom']} ${snapshot.data!['nom']}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.chat),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => ChatScreen(
                              conversationId: conversationId,
                              adminId: adminId,
                              clientId:
                                  clientId, // Vous devez déterminer l'ID du client ici
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
