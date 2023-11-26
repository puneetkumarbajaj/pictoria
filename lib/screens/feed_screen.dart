import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
            onPressed: () {},
            icon: const Icon(
              Icons.messenger_outline,
            ),
          ),
        ],
      ),
      body: const PostCard(),
    );
  }
}
