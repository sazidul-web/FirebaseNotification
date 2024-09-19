import 'package:flutter/material.dart';

class Messagescreen extends StatefulWidget {
  final String id;
  const Messagescreen({Key? key, required this.id}) : super(key: key);
  @override
  State<Messagescreen> createState() => _MessagescreenState();
}

class _MessagescreenState extends State<Messagescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('MessageScreen' + widget.id),
      ),
      body: Center(
        child: Text('Hello i am MessageScreen'),
      ),
    );
  }
}
