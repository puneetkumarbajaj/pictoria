import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final String _userId = FirebaseAuth.instance.currentUser!.uid;
  void _saveProfileChanges() async {
    await _fireStore.collection('users').doc(_userId).update({
      'username': _usernameController.text,
      'bio': _bioController.text,
    });
    Navigator.pop(context, true); // Go back to the profile page after saving
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Name input field
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'username'),
            ),
            SizedBox(height: 10),

            TextField(
              controller: _bioController,
              decoration: InputDecoration(labelText: 'Bio'),
            ),
            SizedBox(height: 20),
            // Save button
            ElevatedButton(
              onPressed: _saveProfileChanges,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
