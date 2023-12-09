import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pictoria/screens/messages_screen.dart';
import 'package:pictoria/utils/colors.dart';
import 'package:pictoria/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Text("Pictoria",
            style: GoogleFonts.pacifico(
              textStyle: TextStyle(
                  fontSize: 30, color: Color.fromARGB(255, 250, 250, 250)),
            )),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MessagesScreen()));
            },
            icon: const Icon(
              Icons.messenger_outline,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) => Container(
              child: PostCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            ),
            itemCount: snapshot.data!.docs.length,
          );
        },
      ),
    );
  }
}
