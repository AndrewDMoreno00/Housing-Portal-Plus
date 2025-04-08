import 'package:flutter/material.dart';
import 'package:housing_portal_plus/Screens/home_screen.dart';
import 'package:firebase_database/firebase_database.dart';

class KresgeScreen extends StatefulWidget {
  const KresgeScreen({super.key});

  @override
  State<KresgeScreen> createState() => _KresgeScreenState();
}

class _KresgeScreenState extends State<KresgeScreen> {
  final reviewKey = GlobalKey(); // For scroll targeting
  List<Map<dynamic, dynamic>> reviews = [];
  int visibleReviews = 1;
  
  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("submissions/cowell");
    final snapshot = await ref.get();

    if (snapshot.exists) {
      List<Map<dynamic, dynamic>> loadedReviews = [];
      for (var child in snapshot.children) {
        Map<dynamic, dynamic>? data = child.value as Map<dynamic, dynamic>?;
        if (data != null) {
          loadedReviews.add(data);
        }
      }
      setState(() {
        reviews = loadedReviews;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cowell College'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                Scrollable.ensureVisible(
                  reviewKey.currentContext!,
                  duration: const Duration(milliseconds: 500),
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
                  'assets/',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center (
              child: Text(
                'Cowell college',
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Scrollable.ensureVisible(
                  reviewKey.currentContext!,
                  duration: const Duration(milliseconds: 500),
                );
              },
              child: const Text('Reviews'),
            ),
            const SizedBox(height: 20),

            // Review Section
            //int visibleReviews = 1; // Start with 1 visible
            // Replace your review section widget with this:
            Container(
              key: reviewKey,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Student Reviews", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  if (reviews.isEmpty)
                    const Text("No reviews yet.")
                  else ...[
                    // Show only the visible ones
                    ...reviews.take(visibleReviews).map((review) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Transfer: ${review['are_you_a_transfer_student_'] ?? 'N/A'}"),
                              Text("Currently in Dorm: ${review['do_you_currently_live_in_an_apartment_or_dorm_'] ?? 'N/A'}"),
                              Text("Rate place: ${review['how_would_you_rate_your_dorm_apartment_'] ?? 'N/A'}"),
                              Text("View: ${review['how_is_the_view_outside_your_window_feel_free_to_be_descriptive_or_vague_'] ?? ''}"),
                            ],
                          ),
                        ),
                      );
                    }),

                    // Only show the button if there are more to show
                    if (visibleReviews < reviews.length)
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              visibleReviews += 1;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text("Show More", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

