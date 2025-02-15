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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 600,
              height: 200,
              margin: EdgeInsets.only(top: 20),
              child: Image(
                image: AssetImage('porter.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 20), // Add spacing between image and buttons
          // First row with two buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  minimumSize: Size(120, 50),
                ),
                child: Text('Button 1', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(width: 20), // Space between buttons
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  minimumSize: Size(120, 50),
                ),
                child: Text('Button 2', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 20), // Space between rows
          // Long button in the middle
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              minimumSize: Size(260, 50), // Longer width for middle button
            ),
            child: Text('Button 5', style: TextStyle(color: Colors.white)),
          ),
          SizedBox(height: 20), // Space between rows
          // Last row with two buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  minimumSize: Size(120, 50),
                ),
                child: Text('Button 3', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(width: 20), // Space between buttons
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  minimumSize: Size(120, 50),
                ),
                child: Text('Button 4', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}