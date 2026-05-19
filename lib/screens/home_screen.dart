import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'profile_screen.dart';

import 'edit_post_screen.dart';

import 'add_post_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // delete post
  void deletePost(String id) async {
    await firestore.collection("posts").doc(id).delete();
  }

  // like unlike
  void likePost(String docId, List likes) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    if (likes.contains(userId)) {
      likes.remove(userId);
    } else {
      likes.add(userId);
    }

    await firestore.collection("posts").doc(docId).update({"likes": likes});
  }

  // edit comment
  void editComment(String docId, List comments, int index, String oldText) {
    TextEditingController controller = TextEditingController(text: oldText);

    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Comment"),

          content: TextField(controller: controller),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {
                comments[index]["text"] = controller.text;

                await firestore.collection("posts").doc(docId).update({
                  "comments": comments,
                });

                Navigator.pop(context);
              },

              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  // delete comment
  void deleteComment(String docId, List comments, int index) async {
    comments.removeAt(index);

    await firestore.collection("posts").doc(docId).update({
      "comments": comments,
    });
  }

  // popup
  void showPostDetails(String docId) {
    TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,

      isScrollControlled: true,

      backgroundColor: Colors.white,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),

      builder: (context) {
        return StreamBuilder<DocumentSnapshot>(
          stream: firestore.collection("posts").doc(docId).snapshots(),

          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            var data = snapshot.data!.data() as Map<String, dynamic>;

            List comments = data["comments"] ?? [];

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,

                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),

              child: SizedBox(
                height: 650,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Center(
                      child: Container(
                        width: 60,
                        height: 5,

                        decoration: BoxDecoration(
                          color: Colors.grey,

                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // username + gmail
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.deepPurple.shade100,

                          child: const Icon(
                            Icons.person,

                            color: Colors.deepPurple,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              data["username"],

                              style: const TextStyle(
                                fontWeight: FontWeight.bold,

                                fontSize: 18,
                              ),
                            ),

                            Text(
                              data["userEmail"],

                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // post
                    Container(
                      width: double.infinity,

                      padding: const EdgeInsets.all(15),

                      decoration: BoxDecoration(
                        color: Colors.grey[200],

                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: Text(
                        data["post"],

                        style: const TextStyle(fontSize: 18),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Comments",

                      style: TextStyle(
                        fontSize: 20,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // comments
                    Expanded(
                      child: comments.isEmpty
                          ? const Center(child: Text("No Comments Yet"))
                          : ListView.builder(
                              itemCount: comments.length,

                              itemBuilder: (context, index) {
                                var comment = comments[index];

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),

                                  padding: const EdgeInsets.all(12),

                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],

                                    borderRadius: BorderRadius.circular(15),
                                  ),

                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,

                                              children: [
                                                Text(
                                                  comment["username"],

                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),

                                                Text(
                                                  comment["userEmail"],

                                                  style: const TextStyle(
                                                    color: Colors.grey,

                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          if (comment["userId"] ==
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                            IconButton(
                                              onPressed: () {
                                                editComment(
                                                  docId,

                                                  comments,

                                                  index,

                                                  comment["text"],
                                                );
                                              },

                                              icon: const Icon(
                                                Icons.edit,
                                                size: 20,
                                              ),
                                            ),

                                          if (comment["userId"] ==
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                            IconButton(
                                              onPressed: () {
                                                deleteComment(
                                                  docId,

                                                  comments,

                                                  index,
                                                );
                                              },

                                              icon: const Icon(
                                                Icons.delete,
                                                size: 20,
                                              ),
                                            ),
                                        ],
                                      ),

                                      const SizedBox(height: 8),

                                      Text(comment["text"]),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),

                    // add comment
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: commentController,

                            decoration: InputDecoration(
                              hintText: "Write comment",

                              filled: true,

                              fillColor: Colors.grey[200],

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),

                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        CircleAvatar(
                          child: IconButton(
                            onPressed: () async {
                              String text = commentController.text.trim();

                              if (text.isNotEmpty) {
                                // get username
                                var userData = await firestore
                                    .collection("users")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .get();

                                comments.add({
                                  "text": text,

                                  "username": userData["username"],

                                  "userEmail":
                                      FirebaseAuth.instance.currentUser!.email,

                                  "userId":
                                      FirebaseAuth.instance.currentUser!.uid,
                                });

                                await firestore
                                    .collection("posts")
                                    .doc(docId)
                                    .update({"comments": comments});

                                commentController.clear();
                              }
                            },

                            icon: const Icon(Icons.send),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

        title: const Text("News Feed"),

        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,

                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },

            icon: const Icon(Icons.person),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,

            MaterialPageRoute(builder: (context) => const AddPostScreen()),
          );
        },

        child: const Icon(Icons.add),
      ),

      body: Padding(
        padding: EdgeInsets.all(width * 0.03),

        child: StreamBuilder(
          stream: firestore
              .collection("posts")
              .orderBy("time", descending: true)
              .snapshots(),

          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            var posts = snapshot.data!.docs;

            if (posts.isEmpty) {
              return const Center(child: Text("No News Yet"));
            }

            return ListView.builder(
              itemCount: posts.length,

              itemBuilder: (context, index) {
                var data = posts[index];

                return GestureDetector(
                  onTap: () {
                    showPostDetails(data.id);
                  },

                  child: Card(
                    margin: const EdgeInsets.only(bottom: 15),

                    elevation: 3,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(15),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.deepPurple.shade100,

                                child: const Icon(
                                  Icons.person,

                                  color: Colors.deepPurple,
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      data["username"],

                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,

                                        fontSize: 16,
                                      ),
                                    ),

                                    Text(
                                      data["userEmail"],

                                      style: const TextStyle(
                                        color: Colors.grey,

                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          Text(
                            data["post"],

                            style: const TextStyle(fontSize: 16),
                          ),

                          const SizedBox(height: 15),

                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  likePost(data.id, data["likes"]);
                                },

                                icon: Icon(
                                  data["likes"].contains(
                                        FirebaseAuth.instance.currentUser!.uid,
                                      )
                                      ? Icons.favorite
                                      : Icons.favorite_border,

                                  color: Colors.red,
                                ),
                              ),

                              Text("${data["likes"].length}"),

                              const SizedBox(width: 10),

                              const Icon(Icons.comment),

                              const SizedBox(width: 5),

                              Text("${data["comments"].length}"),

                              const Spacer(),

                              if (data["userId"] ==
                                  FirebaseAuth.instance.currentUser!.uid)
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,

                                      MaterialPageRoute(
                                        builder: (context) => EditPostScreen(
                                          docId: data.id,

                                          oldPost: data["post"],
                                        ),
                                      ),
                                    );
                                  },

                                  icon: const Icon(Icons.edit),
                                ),

                              if (data["userId"] ==
                                  FirebaseAuth.instance.currentUser!.uid)
                                IconButton(
                                  onPressed: () {
                                    deletePost(data.id);
                                  },

                                  icon: const Icon(Icons.delete),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
