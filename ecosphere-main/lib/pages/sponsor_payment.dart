import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SponsorPaymentPage extends StatelessWidget {
  final String city;
  final List<String> trees;
  final int totalAmount;

  const SponsorPaymentPage({super.key, required this.city, required this.trees, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sponsor', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff185519)), ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selected Trees',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: trees.length,
                itemBuilder: (context, index) {
                  String tree = trees[index];
                  int treeCost = _getTreeCost(tree);
                  return ListTile(
                    title: Text(tree.split(' - ')[0]),
                    subtitle: Text(city),
                    trailing: Text('Rs. $treeCost'),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Rs. $totalAmount',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      _handlePayment(context); // Handle payment and save the trees
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff185519),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 60),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.payment, color: Colors.white),
                    label: const Text('Pay', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 60),
                      elevation: 0,
                    ),
                    child: const Text('Cancel', style: TextStyle(color: Color(0xff185519)),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getTreeCost(String tree) {
    if (tree.contains('5000')) return 5000;
    if (tree.contains('7500')) return 7500;
    if (tree.contains('10000')) return 10000;
    if (tree.contains('15000')) return 15000;
    return 0;
  }

  // Handle payment logic and save sponsored trees
  void _handlePayment(BuildContext context) async {
    try {
      // Get current user
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Loop through each tree and save it in Firestore
        for (String tree in trees) {
          int treeCost = _getTreeCost(tree);
          await FirebaseFirestore.instance.collection('sponsored_trees').add({
            'treeType': tree.split(' - ')[0],
            'city': city,
            'status': 'healthy',
            'userId': currentUser.uid,
            'cost': treeCost,
            'timestamp': FieldValue.serverTimestamp(), // Optional: To track when it was sponsored
          });
        }

        // Show success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Payment Successful'),
              content: const Text('Your sponsorship has been recorded. Thank you for contributing!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.pushNamed(context, '/mytrees'); // Go back to the previous page
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Handle the case where the user is not logged in
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You need to be logged in to sponsor trees')),
        );
      }
    } catch (e) {
      // Handle any errors that occur during the saving process
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
