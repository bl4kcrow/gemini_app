import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Gemini'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.red ,
              child: Icon(Icons.person_outline),
            ),
            title: Text('Basic Prompt'),
            subtitle: Text('Single prompt'),
            onTap: () => context.push('/basic-prompt'),
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.history_outlined),
            ),
            title: Text('Chat Context'),
            subtitle: Text('Chat preserving the context'),
            onTap: () => context.push('/chat-context'),
          ),
        ],
      ),
    );
  }
}