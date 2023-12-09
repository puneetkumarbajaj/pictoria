import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pictoria/resources/chat_service.dart';
import 'package:pictoria/utils/colors.dart';
import 'package:pictoria/widgets/chat_bubble.dart';
import 'package:pictoria/widgets/text_field_input.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;
  final String receiverUsername;
  const ChatPage(
      {super.key,
      required this.receiverUserEmail,
      required this.receiverUserID,
      required this.receiverUsername});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserID, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverUsername)),
      body: Column(
        children: [Expanded(child: _buildMessageList()), _buildMessageInput()],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.receiverUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          );
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(QueryDocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    Timestamp firestoreTimestamp = data["timestamp"];
    DateTime dateTime = firestoreTimestamp.toDate();
    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(formattedDateTime),
          const SizedBox(height: 5),
          ChatBubble(
            message: data['message'],
            color: (data['senderId'] == _firebaseAuth.currentUser!.uid)
                ? Colors.blue
                : Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: TextFieldInput(
            hintText: 'Enter message',
            textInputType: TextInputType.text,
            textEditingController: _messageController,
          ),
        ),
        IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.arrow_upward,
              size: 40,
            ))
      ],
    );
  }
}
