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
  List<String> temporairCourse = [];
  bool listAugment = false;

  void _createTopic(BuildContext context) async {
    if (temporairCourse.isEmpty) return;

    print("=== DÉBUT ENVOI ===");
    print("Nombre d'articles : ${temporairCourse.length}");

    for (int i = 0; i < temporairCourse.length; i++) {
      bool estLeDernier = (i == temporairCourse.length - 1);

      print(
        "Article $i : ${temporairCourse[i]} - Dernier: $estLeDernier - Silent: ${!estLeDernier}",
      );

      await FirebaseFirestore.instance.collection('topics').add({
        'title': temporairCourse[i].trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'silent': !estLeDernier,
      });
    }

    print("=== FIN ENVOI ===");

    if (!context.mounted) return;
    _titleController.clear();
    temporairCourse.clear();
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
              ElevatedButton(
                onPressed: () {
                  ListeCourseUtils.deleteMultiTopic(context, topics);
                },
                child: Text("Réinitaliser la liste"),
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
                                    ListeCourseUtils.deleteOneTopic(
                                      context,
                                      topic.id,
                                    );
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
              title: Text("Quel Ajout ?"),
              content: TextField(
                controller: _titleController,
                decoration: InputDecoration(hintText: "Nom de l'article"),
              ),
              actions: [
                TextButton(
                  onPressed: () => {
                    temporairCourse = [],
                    print(temporairCourse),
                    Navigator.of(ctx).pop(),
                  },
                  child: Text("Annuler"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.trim().isEmpty) return;
                    setState(() {
                      temporairCourse.add(_titleController.text);
                      _titleController.text = "";
                      listAugment = true;
                      print(temporairCourse);
                    });
                  },
                  child: Text("Ajouter"),
                ),

                ElevatedButton(
                  onPressed: () => {
                    if (_titleController.text != "")
                      {temporairCourse.add(_titleController.text)},
                    _createTopic(ctx),
                    setState(() {
                      listAugment = false;
                    }),
                  },
                  child: Text("Valider"),
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
