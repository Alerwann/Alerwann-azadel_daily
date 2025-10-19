import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostListScreen extends StatelessWidget {
  final String topicId;

  const PostListScreen({super.key, required this.topicId});

  void _addPost(BuildContext context) async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Nouveau message"),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(hintText: "Écris ton message..."),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                await FirebaseFirestore.instance.collection('posts').add({
                  'topicId': topicId,
                  'content': controller.text.trim(),
                  'createdAt': FieldValue.serverTimestamp(),
                });

                // Optionnel : incrémenter replyCount
                FirebaseFirestore.instance
                    .collection('topics')
                    .doc(topicId)
                    .update({'replyCount': FieldValue.increment(1)});
              }
              Navigator.of(ctx).pop();
            },
            child: Text("Envoyer"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Messages")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('topicId', isEqualTo: topicId)
            .orderBy('createdAt', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final posts = snapshot.data!.docs;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              var post = posts[index];
              return ListTile(
                title: Text(post['content']),
                subtitle: Text(
                  " Posté à ${DateTime.now().difference(post['createdAt'].toDate()).inHours}h",
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addPost(context),
        child: Icon(Icons.add_comment),
      ),
    );
  }
}
