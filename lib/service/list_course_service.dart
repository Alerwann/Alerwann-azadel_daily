import 'package:cloud_firestore/cloud_firestore.dart';

void createNewTopic(String achat, String content) async {
 

  var topicRef = await FirebaseFirestore.instance.collection('topics').add({
    'course': achat,
  
    'createdAt': FieldValue.serverTimestamp(),
    'replyCount': 0,
  });

  // 2. Créer le premier post (le message initial)
  await FirebaseFirestore.instance.collection('posts').add({
    'topicId': topicRef.id,

    'content': content,
    'createdAt': FieldValue.serverTimestamp(),
  });

}
