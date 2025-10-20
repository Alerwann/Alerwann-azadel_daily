import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListeCourseUtils {

    static   void deleteTopic(BuildContext context, String indexTopic) async {
    await FirebaseFirestore.instance
        .collection('topics')
        .doc(indexTopic)
        .delete();
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  //ajouter la fonction de notifications pour la liste
}