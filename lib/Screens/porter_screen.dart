import 'package:flutter/material.dart';
import 'package:housing_portal_plus/Screens/home_screen.dart';

class PorterScreen extends StatelessWidget {
  const PorterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Porter College'),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false,
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                Scrollable.ensureVisible(
                  context,
                  duration: Duration(milliseconds: 500),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Image(
          width: 750 ,
          image: AssetImage('assets/download.jpg')
          ), 
      ),
    );
  }
}