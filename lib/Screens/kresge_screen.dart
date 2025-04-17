import 'package:flutter/material.dart';
import 'package:housing_portal_plus/Screens/home_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:housing_portal_plus/screens/chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class KresgeScreen extends StatefulWidget {
  const KresgeScreen({super.key});

  @override
  State<KresgeScreen> createState() => _KresgeScreenState();
}

class _KresgeScreenState extends State<KresgeScreen> {
  final reviewKey = GlobalKey(); // For scroll targeting
  final imageGalleryKey = GlobalKey();
  final infoSectionKey = GlobalKey();

  List<Map<dynamic, dynamic>> reviews = [];
  int visibleReviews = 1;
  List<String> imageUrls = []; // To store image URLs
  List<String> dormImageUrls = [];

  @override
  void initState() {
    super.initState();
    fetchReviews();
    fetchImageUrls();
    fetchDormImageUrls();
  }

  Future<void> fetchReviews() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("submissions/kresge");
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
  // Fetch image URLs from Firebase Realtime Database
  Future<void> fetchImageUrls() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("images/kresge");
    final snapshot = await ref.get();

    if (snapshot.exists) {
      List<String> loadedImageUrls = [];
      for (var child in snapshot.children) {
        loadedImageUrls.add(child.value as String); // Assuming the value is a string URL
      }
      setState(() {
        imageUrls = loadedImageUrls;
      });
    }
  }
  Future<void> fetchDormImageUrls() async {
  DatabaseReference ref = FirebaseDatabase.instance.ref("dorm/kresge");
  final snapshot = await ref.get();

  if (snapshot.exists) {
    List<String> loadedDormUrls = [];
    for (var child in snapshot.children) {
      loadedDormUrls.add(child.value as String); // Assuming value is a URL string
    }
    setState(() {
      dormImageUrls = loadedDormUrls;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kresge College'),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width * 0.9,
                child: Image.asset(
                  'assets/kresge.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFFFD700), // Gold background
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '''
Kresge College, founded in 1971, emphasizes collaboration, participatory democracy, and intentional living. Located among the redwoods, it offers a small-college experience focused on personal growth, community, and practical learning. Kresge encourages students to engage creatively with social, political, and environmental challenges.
''',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.black, // Better contrast on gold
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Scrollable.ensureVisible(
                      infoSectionKey.currentContext!,
                      duration: const Duration(milliseconds: 500),
                    );
                  },
                  child: const Text('Info'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Scrollable.ensureVisible(
                      imageGalleryKey.currentContext!,
                      duration: const Duration(milliseconds: 500),
                    );
                  },
                  child: const Text('Image'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Scrollable.ensureVisible(
                      reviewKey.currentContext!,
                      duration: const Duration(milliseconds: 500),
                    );
                  },
                  child: const Text('Reviews'),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Image Gallery with Swipeable Feature
            if (imageUrls.isNotEmpty) 
              Column(
                key: imageGalleryKey,
                children: [
                  Text(
                    ' College Images',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 220,
                    child: PageView.builder(
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                imageUrls[index],
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return Center(child: CircularProgressIndicator());
                                },
                                errorBuilder: (context, error, stackTrace) =>
                                    Center(child: Icon(Icons.broken_image)),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            if (dormImageUrls.isNotEmpty)
              Column(
                children: [
                  Text(
                    ' Dorm Images',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  //SizedBox(height: 10),
                  SizedBox(
                    height: 320,
                    width: 450,
                    child: PageView.builder(
                      itemCount: dormImageUrls.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: AspectRatio(
                            aspectRatio: 16 / 10,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                dormImageUrls[index],
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return Center(child: CircularProgressIndicator());
                                },
                                errorBuilder: (context, error, stackTrace) =>
                                    Center(child: Icon(Icons.broken_image)),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            Container(
              key: infoSectionKey,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700), // Gold background
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Info",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        height: 1.4,
                      ),
                      children: [
                        const TextSpan(
                          text: '''
  Kresge’s curriculum is made up of three main pillars: its Core Course (for first-year students); its Transfer Curriculum (for Transfer students); and its Enhancement Curriculum (for all undergraduate students).
  The Core seminar (KRSG 1) invites first-year students to reflect on three Big Questions: Why do I learn? How do I learn? & From whom do I learn? These questions are a starting point for students to reflect on what is possible at Kresge, at UCSC, and beyond.

  Kresge College provides a lively, fun and creative residential community, with active participation from both students and staff. The college is composed of two sections, Kresge Proper and J & K Buildings. Students live more independently and are able to create a more home-like environment. In apartments, students can study, relax, cook their own meals and socialize with friends in a welcoming and comfortable atmosphere. Students have the opportunity to learn life skills within a cooperative living environment.

  Dining Services and the Division of Student Affairs and Success are pleased to announce the opening of Owl’s Nest Cafe. Located in Kresge College, Owl’s Nest provides food service Monday through Friday, 9 a.m. to 4 p.m. 
  Featuring a coffee and smoothie bar, the cafe currently offers patrons a variety of grab-and-go food items, including bagels, wraps and other pre-packaged foods. 

  Futre apartments coming soon to Kresge 2026
  
            ''',
                        ),
                        const TextSpan(
                          text: 'For more information, visit ',
                        ),
                        TextSpan(
                          text: 'kresge.ucsc.edu',
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final Uri url = Uri.parse('https://kresge.ucsc.edu/');
                              if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Could not launch $url')),
                                );
                              }
                            },
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
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

