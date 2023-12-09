import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pictoria/screens/chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chats'),
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance.collection('users').get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: (snapshot.data! as dynamic).docs.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChatPage(
                              receiverUserID: (snapshot.data! as dynamic)
                                  .docs[index]['uid'],
                              receiverUserEmail: (snapshot.data! as dynamic)
                                  .docs[index]['email'],
                              receiverUsername: (snapshot.data! as dynamic)
                                  .docs[index]['username'],
                            ))),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            (snapshot.data! as dynamic).docs[index]
                                ['photoUrl']),
                      ),
                      title: Text(
                          (snapshot.data! as dynamic).docs[index]['username']),
                    ),
                  );
                });
          },
        ));
  }
}
