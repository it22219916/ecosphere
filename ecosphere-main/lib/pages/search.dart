import 'package:ecosphere/models/schedule.dart';
import 'package:ecosphere/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

import 'package:intl/intl.dart'; // Importing Timer

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FirestoreService _firestoreService = FirestoreService();

  String _selectedCity = 'All';
  String _searchQuery = '';
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  // Debounce function for the search input
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = query;
      });
    });
  }

  // Helper function to get the SVG path based on the waste collection type
  String _getSvgForActivity(String activity) {
    switch (activity) {
      case 'Recyclable Waste Collection':
        return 'assets/icons/recyclable_waste.svg';
      case 'E-Waste Collection':
        return 'assets/icons/e_waste.svg';
      case 'Battery Collection':
        return 'assets/icons/battery_waste.svg';
      case 'Plastics Recycling Collection':
        return 'assets/icons/plastics_recycling.svg';
      default:
        return 'assets/icons/default_waste.svg'; // Fallback icon
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/logo.png',
          height: 80,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black,),
            onPressed: () {
              // Navigate to the SearchPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 100,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            decoration: const BoxDecoration(
              color: Color(0xffF7F7F9),
              shape: BoxShape.circle
            ),
            child: const Center(
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
          
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<Schedule>>(
          stream: _firestoreService.getAllSchedulesStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error fetching schedules.'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No schedules available.'));
            }

            List<Schedule> schedules = snapshot.data!;

            // Extract unique cities
            Set<String> citySet = {};
            for (var schedule in schedules) {
              for (var activity in schedule.activities) {
                citySet.add(activity.city);
              }
            }
            List<String> cities = ['All', ...citySet];

            // Apply filters
            List<Schedule> filteredSchedules = schedules.where((schedule) {
              bool matchesCity = _selectedCity == 'All' ||
                  schedule.activities.any((activity) => activity.city == _selectedCity);
              bool matchesSearch = _searchQuery.isEmpty ||
                  schedule.activities.any((activity) => activity.activity
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase()));
              return matchesCity && matchesSearch;
            }).toList();

            return Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF9BF3D6), // Set the background color here (light green shade)
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(153, 216, 197, 197),
                        blurRadius: 5.0,
                        spreadRadius: 0.0,
                        offset: Offset(0.0, 1.0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Search by Activity',
                        suffixIcon: Icon(Icons.search),    
                        border: UnderlineInputBorder(borderSide: BorderSide.none),
                        filled: true, // Ensure this is true to apply the background color
                        fillColor: Colors.transparent, // Transparent fill, the background is handled by the container
                      ),
                      onChanged: _onSearchChanged, // Using debounced search
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                // Dropdown for City Filter
                DropdownButtonFormField<String>(
                  value: _selectedCity,
                  decoration: const InputDecoration(
                    labelText: 'Sort by City',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                  borderRadius: BorderRadius.circular(20),
                  items: cities.map((city) {
                    return DropdownMenuItem(
                      value: city,
                      child: Center(child: Text(city)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCity = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Display Filtered Schedules
                Expanded(
                  child: filteredSchedules.isEmpty
                      ? const Center(child: Text('No schedules found.'))
                      : ListView.builder(
                          itemCount: filteredSchedules.length,
                          itemBuilder: (context, index) {
                            Schedule schedule = filteredSchedules[index];
                           return ExpansionTile(
                            title: Text(
                              // Format the date to show the month name and day (e.g., October 8)
                              DateFormat('MMMM d').format(schedule.date.toLocal()), // This will format it as 'October 8'
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            children: schedule.activities.map((activity) {
                              String svgPath = _getSvgForActivity(activity.activity);
                              return ListTile(
                                leading: SvgPicture.asset(
                                  svgPath,
                                  width: 40,
                                  height: 40,
                                  semanticsLabel: 'Waste Collection Icon',
                                ),
                                title: Text(activity.activity),
                                subtitle: Row(
                                  children: [
                                    const Text('City: '),
                                    Text(activity.city, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 8.0),
                                    const Text('Collection Time: '),
                                    Text(activity.collectionTime, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
