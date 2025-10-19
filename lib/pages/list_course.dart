import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'post_list.dart';

class TopicListScreen extends StatelessWidget {
 
  final _titleController = TextEditingController();

  TopicListScreen({super.key});

  void _createTopic(BuildContext context) async {
    if (_titleController.text.trim().isEmpty) return;

    await FirebaseFirestore.instance.collection('topics').add({
      'title': _titleController.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
      'replyCount': 0,
    });

    _titleController.clear();
    Navigator.of(context).pop(); // ferme le dialogue
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forum")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('topics')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final topics = snapshot.data!.docs;
          return ListView.builder(
            itemCount: topics.length,
            itemBuilder: (context, index) {
              var topic = topics[index];
              return ListTile(
                title: Text(topic['title']),
                subtitle: Text("${topic['replyCount']} réponses"),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PostListScreen(topicId: topic.id),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text("Nouveau sujet"),
              content: TextField(
                controller: _titleController,
                decoration: InputDecoration(hintText: "Titre du sujet"),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text("Annuler"),
                ),
                ElevatedButton(
                  onPressed: () => _createTopic(ctx),
                  child: Text("Créer"),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
