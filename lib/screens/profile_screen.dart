import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController usernameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  bool isLoading = true;

  int totalPosts = 0;

  int totalComments = 0;

  // load user data
  void loadUserData() async {
    String userId = auth.currentUser!.uid;

    // get user info
    DocumentSnapshot userDoc = await firestore
        .collection("users")
        .doc(userId)
        .get();

    usernameController.text = userDoc["username"];

    emailController.text = userDoc["email"];

    // get posts
    QuerySnapshot postSnapshot = await firestore.collection("posts").get();

    int postCount = 0;

    int commentCount = 0;

    for (var post in postSnapshot.docs) {
      var data = post.data() as Map<String, dynamic>;

      // total posts
      if (data["userId"] == userId) {
        postCount++;
      }

      // total comments
      List comments = data["comments"] ?? [];

      for (var comment in comments) {
        if (comment["userId"] == userId) {
          commentCount++;
        }
      }
    }

    setState(() {
      totalPosts = postCount;

      totalComments = commentCount;

      isLoading = false;
    });
  }

  // update profile
  void updateProfile() async {
    String userId = auth.currentUser!.uid;

    String username = usernameController.text.trim();

    String email = emailController.text.trim();

    if (username.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Fill all fields")));

      return;
    }

    try {
      // update email
      await auth.currentUser!.verifyBeforeUpdateEmail(email);

      // update users collection
      await firestore.collection("users").doc(userId).update({
        "username": username,

        "email": email,
      });

      // update posts
      QuerySnapshot posts = await firestore
          .collection("posts")
          .where("userId", isEqualTo: userId)
          .get();

      for (var post in posts.docs) {
        await firestore.collection("posts").doc(post.id).update({
          "username": username,

          "userEmail": email,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile Updated. Verify your new email."),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void initState() {
    super.initState();

    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(width * 0.05),

              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // username
                  TextField(
                    controller: usernameController,

                    decoration: InputDecoration(
                      labelText: "Username",

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // email
                  TextField(
                    controller: emailController,

                    decoration: InputDecoration(
                      labelText: "Email",

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // update button
                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(
                      onPressed: updateProfile,

                      child: const Text("Update"),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // total posts
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.post_add),

                      title: const Text("Total Posts"),

                      subtitle: Text("$totalPosts"),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // total comments
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.comment),

                      title: const Text("Total Comments"),

                      subtitle: Text("$totalComments"),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // logout
                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(
                      onPressed: () async {
                        await auth.signOut();

                        Navigator.pushAndRemoveUntil(
                          context,

                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),

                          (route) => false,
                        );
                      },

                      child: const Text("Logout"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
