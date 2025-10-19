// lib/post_list_screen.dart
import 'package:flutter/material.dart';

class PostListScreen extends StatelessWidget {
  final String topicId;

  const PostListScreen({super.key, required this.topicId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Messages")),
      body: Center(child: Text("Messages du sujet ID: $topicId")),
    );
  }
}
