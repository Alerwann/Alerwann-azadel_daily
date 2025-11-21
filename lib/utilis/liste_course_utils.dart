import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListeCourseUtils {
  static void deleteOneTopic(BuildContext context, String indexTopic) async {
    // indexTopic = 'test2';
    print("🫟 delete one indextopic -> $indexTopic");

    await FirebaseFirestore.instance
        .collection('topics')
        .doc(indexTopic)
        .delete();
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  static void deleteMultiTopic(BuildContext context, List alltopic) async {
    print("🫟 delete all");

    if (alltopic.isEmpty) return;

    for (int i = 0; i < alltopic.length; i++) {
      // bool estLeDernier = (i == alltopic.length - 1);
      bool estLeDernier = (i == 0);
      if (estLeDernier) {
        await FirebaseFirestore.instance
            .collection('topics')
            .doc(alltopic[i].id)
            .update({'silent': false});


        print("👻 ${alltopic[i]['title']} va être effacé");
    

        print("✅ vérif : ${alltopic[i]['title']}");
      } else {
        await FirebaseFirestore.instance
            .collection('topics')
            .doc(alltopic[i].id)
            .update({'silent': true});
        
      }
          await FirebaseFirestore.instance
          .collection('topics')
          .doc(alltopic[i].id)
          .delete();
    }
  }
}


  //ajouter la fonction de notifications pour la liste

