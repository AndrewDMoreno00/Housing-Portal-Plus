import 'package:flutter/material.dart';
import 'package:housing_portal_plus/Screens/home_screen.dart';
import 'package:firebase_database/firebase_database.dart';

class StevensonScreen extends StatefulWidget {
  const StevensonScreen({super.key});

  @override
  State<StevensonScreen> createState() => _StevensonScreenState();
}

class _StevensonScreenState extends State<StevensonScreen> {
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
                      final furnitureCounts = review['what_furniture_do_you_have_in_your_dorm_please_include_your_roommates_furniture_too_']?.split(', ') ?? [];
                      final furnitureLabels = [
                        "Desks",
                        "Chairs",
                        "Wardrobes",
                        "Dressers",
                        "Drawers",
                        "Beds (Count lofted or bunked)",
                        "Shelves (Include closet ones)"
                      ];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Year: ${review ['what_year_are_you_'] ?? ''}"),
                              Text("Transfer: ${review['are_you_a_transfer_student_'] ?? 'N/A'}"),
                              Text("Currently in Dorm: ${review['do_you_currently_live_in_an_apartment_or_dorm_'] ?? 'N/A'}"),
                              Text("Rate place: ${review['how_would_you_rate_your_dorm_apartment_'] ?? 'N/A'}"),
                              Text("Rate closest bus stop: ${review['how_easy_is_it_to_get_to_your_dorm_room_as_if_you_were_coming_back_from_class_think_about_what_floor_you_are_on_the_stairs_you_have_to_walk_and_the_distance_you_have_to_travel_from_the_nearest_bus_stop_'] ?? 'N/A'}"),
                              Text("View outside window: ${review['how_is_the_view_outside_your_window_feel_free_to_be_descriptive_or_vague_'] ?? ''}"),
                              Text("Area around: ${review['is_there_anything_you_don_t_like_about_the_area_around_your_dorm_such_as_pathways_or_a_hill_for_example_'] ?? ''}"),
                              Text("Like/don't like about place: ${review['is_there_anything_you_don_t_like_about_your_dorm_'] ?? 'N/A'}"),
                              Text("Anything Broken: ${review['is_there_or_was_there_anything_broken_in_your_dorm_if_you_called_cruzfix_please_let_us_know_'] ?? 'N/A'}"),
                              Text("Building reside in: ${review['what_building_do_you_reside_in_'] ?? 'N/A'}"),
                              Text("Floor: ${review['what_floor_are_you_on_'] ?? 'N/A'}"),
                              Text("Missing roommate?: ${review['who_is_in_your_living_space_if_you_re_missing_a_roommate_in_your_triple_for_example_i_e_they_never_arrived_select_triple_for_room_type_and_double_for_number_of_people_'] ?? 'N/A'}"),
                              const SizedBox(height: 8),
                              const Text("Furniture:", style: TextStyle(fontWeight: FontWeight.bold)),
                              for (int i = 0; i < furnitureLabels.length; i++)
                                Text("${furnitureLabels[i]}: ${furnitureCounts.length > i ? furnitureCounts[i] : 'N/A'}"),
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

