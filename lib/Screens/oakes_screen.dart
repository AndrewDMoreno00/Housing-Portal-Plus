import 'package:flutter/material.dart';
import 'package:housing_portal_plus/Screens/home_screen.dart';

class OakesScreen extends StatelessWidget {
  const OakesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: 
        Text(
          'Oakes College',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
              margin: EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
                child: Image.asset(
                  'assets/oakes.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center (
              child: Text(
                'Oakes college was founded in 1972',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
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
                SizedBox(width: 20),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                minimumSize: Size(260, 50),
              ),
              child: Text('Button 5', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
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
                SizedBox(width: 20),
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
      ),
    );
  }
}
