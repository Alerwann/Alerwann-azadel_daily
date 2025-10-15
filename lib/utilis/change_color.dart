import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> changeColor(String color) async {
  await FirebaseFirestore.instance.collection('appState').doc('hearts').update({
    'selectedColor': color,
  });
}

MaterialColor getColor(String colorName) {
  switch (colorName) {
    case 'red':
      return Colors.red;
    case 'blue':
      return Colors.blue;
    case 'green':
      return Colors.green;
    case 'yellow':
      return Colors.yellow;
    case 'grey':
      return Colors.grey;
    default:
      return Colors.grey;
  }
}
