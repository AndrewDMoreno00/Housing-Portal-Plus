import 'package:flutter/material.dart';
import 'package:housing_portal_plus/Screens/cowell_screen.dart';
import 'package:housing_portal_plus/Screens/stevenson_screen.dart';
import 'package:housing_portal_plus/Screens/merril_screen.dart';
import 'package:housing_portal_plus/Screens/kresge_screen.dart';
import 'package:housing_portal_plus/Screens/rachel_carson_screen.dart';
import 'package:housing_portal_plus/Screens/porter_screen.dart';
import 'package:housing_portal_plus/Screens/oakes_screen.dart';
import 'package:housing_portal_plus/Screens/crown_screen.dart';
import 'package:housing_portal_plus/Screens/nine_screen.dart'; 
import 'package:housing_portal_plus/Screens/john_screen.dart'; 
import 'package:housing_portal_plus/Screens/google_map.dart';
import 'package:housing_portal_plus/screens/chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double screenWidth = MediaQuery.of(context).size.width;

    final List<Map<String, dynamic>> colleges = [
      {'title': 'Cowell College', 'screen': CowellScreen()},
      {'title': 'Stevenson College', 'screen': StevensonScreen()},
      {'title': 'Crown College', 'screen': CrownScreen()},
      {'title': 'Merril College', 'screen': MerrilScreen()},
      {'title': 'Porter College', 'screen': PorterScreen()},
      {'title': 'Kresge College', 'screen': KresgeScreen()},
      {'title': 'Oakes College', 'screen': OakesScreen()},
      {'title': 'Rachel Carson College', 'screen': RachelScreen()},
      {'title': 'College Nine', 'screen': NineScreen()},
      {'title': 'John R. Lewis', 'screen': JohnScreen()},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Housing Portal Plus',
              style: TextStyle(fontSize: 16),
            ),
            Image.asset(
              'assets/Snailwithsign.png', 
              height: 70,        
            ),
          ],
        ),
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
              icon: Icon(Icons.map, color: Colors.white),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MapScreen()),
                  (route) => false,
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.chat, color: Colors.white),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SearchAnchor(
                  builder: (BuildContext context, SearchController controller) {
                    return SearchBar(
                      controller: controller,
                      padding: const WidgetStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      onTap: () {
                        controller.openView();
                      },
                      onChanged: (_) {
                        controller.openView();
                      },
                        leading: const Icon(Icons.search),
                    );
                  },
                  suggestionsBuilder: (BuildContext context, SearchController controller) {
                    final query = controller.text.toLowerCase();

                    final filteredColleges = colleges
                        .where((college) => college['title'].toLowerCase().contains(query))
                        .toList();

                    return filteredColleges.map((college) {
                      return ListTile(
                        title: Text(college['title']),
                        onTap: () {
                          controller.closeView(college['title']);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => college['screen']),
                          );
                        },
                      );
                    }).toList();
                  },
                ),
              ),
              SizedBox(height: 16),
              CustomTile(
                title: 'Cowell College',
                color: Color(0xFFFFD700), 
                destinationPage: CowellScreen(), 
                imageAsset: 'assets/cowell_power.png', 
              ),
              SizedBox(height: 16),
              CustomTile(
                title: 'Stevenson College',
                color: Color(0xFFFFD700), 
                destinationPage: StevensonScreen(), 
                imageAsset: 'assets/stevenson_power.png', 
              ),
              SizedBox(height: 16),
              CustomTile(
                title: 'Crown College',
                color: Color(0xFFFFD700), 
                destinationPage: CrownScreen(), 
                imageAsset: 'assets/crown_power.png', 
              ),
              SizedBox(height: 16),
              CustomTile(
                title: 'Merrill College',
                color: Color(0xFFFFD700), 
                destinationPage: MerrilScreen(), 
                imageAsset: 'assets/merrill_power.png', 
              ),
              SizedBox(height: 16),
              CustomTile(
                title: 'Porter College',
                color: Color(0xFFFFD700),
                destinationPage: PorterScreen(),
                imageAsset: 'assets/squiggle.jpg',
              ),
              SizedBox(height: 16),
              CustomTile(
                title: 'Kresge College',
                color: Color(0xFFFFD700), 
                destinationPage: KresgeScreen(), 
                imageAsset: 'assets/leaf.png', 
              ),
              SizedBox(height: 16),
              CustomTile(
                title: 'Oakes College',
                color: Color(0xFFFFD700), 
                destinationPage: OakesScreen(), 
                imageAsset: 'assets/oakes_power.png', 
              ),
              SizedBox(height: 16),
              CustomTile(
                title: 'Rachel Carson College',
                color: Color(0xFFFFD700), 
                destinationPage: RachelScreen(), 
                imageAsset: 'assets/rachel_power.png', 
              ),
              SizedBox(height: 16),
              CustomTile(
                title: 'College Nine',
                color: Color(0xFFFFD700), 
                destinationPage: NineScreen(), 
                imageAsset: 'assets/nine_power.png', 
              ),
              SizedBox(height: 16),
              CustomTile(
                title: 'John R. Lewis',
                color: Color(0xFFFFD700), 
                destinationPage: JohnScreen(), 
                imageAsset: 'assets/john_power.png', 
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen()),
            );
          },
        backgroundColor: Colors.blue,
        tooltip: 'Chat with Sammy',
        child: Icon(Icons.chat),
      ),
    );
  }
}

class CustomTile extends StatelessWidget {
  final String title;
  final Color color;
  final Widget destinationPage;
  final String imageAsset;

  const CustomTile({
    super.key,
    required this.title,
    required this.color,
    required this.destinationPage,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationPage),
        );
      },
      child: Container(
        width: screenWidth * 0.9, // 90% of screen width
        height: screenWidth * 0.13, // Adjust this to your desired height
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Image.asset(
              imageAsset,
              //width: 40,
              width: screenWidth * 0.2, // 30% of screen width
              height: screenWidth * 0.3, // Maintain aspect ratio
              //height: 60,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
