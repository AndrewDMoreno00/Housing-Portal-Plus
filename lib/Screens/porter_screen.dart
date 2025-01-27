import 'package:flutter/material.dart';

class PorterScreen extends StatelessWidget {
  const PorterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Porter College'),
      ),
      body: Center(
        child: Image(
          image: AssetImage('assets/download.jpg')
          ), 
      ),
    );
  }
}