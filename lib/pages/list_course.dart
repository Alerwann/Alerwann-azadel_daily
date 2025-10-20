import 'package:azadel_daily/utilis/liste_course_utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TopicListScreen extends StatefulWidget {
  const TopicListScreen({super.key});

  @override
  State<TopicListScreen> createState() => _TopicListScreenState();
}

class _TopicListScreenState extends State<TopicListScreen> {
  final _titleController = TextEditingController();

  void _createTopic(BuildContext context) async {
    if (_titleController.text.trim().isEmpty) return;

    await FirebaseFirestore.instance.collection('topics').add({
      'title': _titleController.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    if (!context.mounted) return;
    _titleController.clear();
    Navigator.of(context).pop();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Liste de course")),
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
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Ce qui manque cette semaine",
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 60),
              Expanded(
                child: ListView.builder(
                  itemCount: topics.length,
                  itemBuilder: (context, index) {
                    var topic = topics[index];
                    return ListTile(
                      title: Text(
                        topic['title'],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                         
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Supprimer " ${topic['title']} "?'),
                                actions: [
                                  TextButton(
                                    onPressed: Navigator.of(context).pop,
                                    child: Text('Non'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      ListeCourseUtils.deleteTopic(context, topic.id);
                                   
                                    },
                                    child: Text('Oui'),
                                  ),
                                ],
                              ),
                            );
                       
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
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
