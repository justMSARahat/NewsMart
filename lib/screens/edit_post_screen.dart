import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPostScreen extends StatefulWidget {
  final String docId;
  final String oldPost;

  const EditPostScreen({super.key, required this.docId, required this.oldPost});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  // controller
  TextEditingController postController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    // old post show korbe
    postController.text = widget.oldPost;
  }

  // UPDATE
  void updatePost() async {
    await firestore.collection("posts").doc(widget.docId).update({
      "post": postController.text,
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Post Updated")));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Post")),

      body: Padding(
        padding: EdgeInsets.all(width * 0.05),

        child: Column(
          children: [
            TextField(
              controller: postController,

              decoration: const InputDecoration(
                labelText: "Edit Post",

                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: updatePost,

                child: const Text("Update"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
