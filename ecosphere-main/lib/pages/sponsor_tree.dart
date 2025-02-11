import 'package:ecosphere/pages/sponsor_payment.dart';
import 'package:flutter/material.dart';

class SponsorTreePage extends StatefulWidget {
  @override
  _SponsorTreePageState createState() => _SponsorTreePageState();
}

class _SponsorTreePageState extends State<SponsorTreePage> {
  final List<String> cities = ['City 1', 'City 2', 'City 3', 'City 4'];
  String? selectedCity;
  final Map<String, bool> selectedTrees = {
    'Tree 1 - 5000': false,
    'Tree 2 - 7500': false,
    'Tree 3 - 10000': false,
    'Tree 4 - 15000': false,
  };

  final Map<String, String> treeImages = {
    'Tree 1 - 5000': 'assets/images/tree1.png',
    'Tree 2 - 7500': 'assets/images/tree2.png',
    'Tree 3 - 10000': 'assets/images/tree3.png',
    'Tree 4 - 15000': 'assets/images/tree4.png',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sponsor', style: TextStyle(color:Color(0xff185519), fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown for City Selection
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select City',
                border: OutlineInputBorder(),
              ),
              value: selectedCity,
              items: cities.map((city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCity = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Text for Tree Selection
            const Text(
              'Select Tree',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // GridView for Tree Images with Checkboxes
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0,
                ),
                itemCount: selectedTrees.keys.length,
                itemBuilder: (context, index) {
                  String tree = selectedTrees.keys.elementAt(index);
                  return Stack(
                    children: [
                      // Tree Image with rounded corners
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTrees[tree] = !selectedTrees[tree]!;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selectedTrees[tree]!
                                  ? Colors.green
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              treeImages[tree]!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      // Checkbox in the top right corner
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Checkbox(
                          value: selectedTrees[tree],
                          onChanged: (bool? value) {
                            setState(() {
                              selectedTrees[tree] = value!;
                            });
                          },
                        ),
                      ),

                      // Tree label
                      Positioned(
                        bottom: 8,
                        left: 8,
                        right: 8,
                        child: Text(
                          tree.split(' - ')[0], // Display Tree 1, Tree 2, etc.
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff185519),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Sponsor Button
            Center(
              child: ElevatedButton.icon(
                onPressed: selectedCity != null
                    ? () {
                        // Logic to navigate to Payment page
                        List<String> sponsoredTrees = selectedTrees.entries
                            .where((element) => element.value)
                            .map((e) => e.key)
                            .toList();
                        int totalAmount = calculateTotalAmount(sponsoredTrees);

                        // Navigate to Payment Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SponsorPaymentPage(
                              city: selectedCity!,
                              trees: sponsoredTrees,
                              totalAmount: totalAmount,
                            ),
                          ),
                        );
                      }
                    : null, // Disable button if city not selected
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff185519),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  fixedSize: const Size(200.0, 50.0), // Adjust width and height as needed
                ),
                icon: const Icon(Icons.spa, color: Colors.white),
                label: const Text('Sponsor', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int calculateTotalAmount(List<String> trees) {
    int total = 0;
    for (String tree in trees) {
      if (tree.contains('5000')) {
        total += 5000;
      } else if (tree.contains('7500')) {
        total += 7500;
      } else if (tree.contains('10000')) {
        total += 10000;
      } else if (tree.contains('15000')) {
        total += 15000;
      }
    }
    return total;
  }
}
