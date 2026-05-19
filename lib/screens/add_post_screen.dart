import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  TextEditingController postController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseAuth auth = FirebaseAuth.instance;

  void addPost() async {
    String post = postController.text.trim();

    if (post.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Write something")));

      return;
    }

    try {
      User user = auth.currentUser!;

      // get username from users collection
      DocumentSnapshot userDoc = await firestore
          .collection("users")
          .doc(user.uid)
          .get();

      String username = userDoc["username"];

      // add post
      await firestore.collection("posts").add({
        "post": post,

        "userId": user.uid,

        "userEmail": user.email,

        "username": username,

        "likes": [],

        "comments": [],

        "time": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Post Added")));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Add News")),

      body: Padding(
        padding: EdgeInsets.all(width * 0.05),

        child: Column(
          children: [
            TextField(
              controller: postController,

              maxLines: 6,

              decoration: InputDecoration(
                hintText: "Write your news...",

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: addPost,

                child: const Text("Post News"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
