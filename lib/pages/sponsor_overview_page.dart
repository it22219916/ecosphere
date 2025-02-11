import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SponsorOverviewPage extends StatelessWidget {
  const SponsorOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Sponsor A Tree',
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              color: Color(0xff185519),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Program Overview Title
            Row(
              children: [
                Text(
                  'Program Overview',
                  style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                      color: Color(0xff185519),
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.park_outlined,
                  color: Color(0xff185519),
                  size: 28,
                ),
              ],
            ),
            const SizedBox(height: 64),

            // Section 1: How it works
            _buildSection(
              context,
              title: "How it works",
              description:
                  "Sponsor a tree, make a donation, and track its growth with real-time updates through the app.",
              imageUrl: 'assets/images/how_it_works.png', // Example image
            ),
            const SizedBox(height: 32),

            // Section 2: Purpose of the program
            _buildSection2(
              context,
              title: "Purpose of the program",
              description:
                  "To encourage individuals to contribute to urban greening and environmental sustainability.",
              imageUrl: 'assets/images/purpose.png', // Example image
            ),
            const SizedBox(height: 32),

            // Section 3: Impact so far
            _buildSection(
              context,
              title: "Impact so far",
              description:
                  "Helps reduce carbon footprint, improve air quality, and foster greener urban spaces.",
              imageUrl: 'assets/images/impact.png', // Example image
            ),
            const SizedBox(height: 98),

            // Sponsor Button
            ElevatedButton(
              onPressed: () {
                // Navigate to the sponsor tree page
                Navigator.pushNamed(context, '/sponsorpage');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff185519),
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Sponsor',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0, // Change this based on the active page
        selectedItemColor: const Color(0xff185519),
        unselectedItemColor: const Color(0xffB9B9B9),
        items: const [
          BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
          ),
          BottomNavigationBarItem(
        icon: Icon(Icons.calendar_month),
        label: 'Calendar',
          ),
          BottomNavigationBarItem(
        icon: Icon(Icons.notifications),
        label: 'Notifications',
          ),
          BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
          ),
        ],
        onTap: (index) {
          // Handle navigation based on the tapped item
          switch (index) {
        case 0:
          Navigator.pushNamed(context, '/home');
          break;
        case 1:
          Navigator.pushNamed(context, '/calendar');
          break;
        case 2:
          Navigator.pushNamed(context, '/notifications');
          break;
        case 3:
          Navigator.pushNamed(context, '/profile');
          break;
          }
        },
            )
    );
  }

  
}


Widget _buildSection(BuildContext context,
      {required String title, required String description, required String imageUrl}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Title and Description
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.raleway(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
}

Widget _buildSection2(BuildContext context,
      {required String title, required String description, required String imageUrl}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and Description
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.raleway(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        // Image
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }