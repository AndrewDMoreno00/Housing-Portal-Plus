import 'package:flutter/material.dart';
import 'package:housing_portal_plus/Screens/porter_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Housing Portal Plus',
        style: TextStyle(
          fontSize: 16
        ),
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
                suggestionsBuilder: 
                    (BuildContext context, SearchController controller) {
                  return List<ListTile>.generate(5, (int index) {
                    final String item = 'item $index';
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        controller.closeView(item);
                      },
                    );
                  });
                },
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PorterScreen()),
                );
              },
              child: SizedBox(
                height: 50,
                width: 650,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Porter College'),
                      Image.asset(
                        'assets/squiggle.jpg',
                        height: 300,
                        width: 170,
                        fit: BoxFit.cover,
                      ),  
                    ]
                  ) 
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
