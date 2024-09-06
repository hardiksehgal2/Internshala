// ignore_for_file: unnecessary_string_interpolations, avoid_print, unused_element

import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:internshala/screens/filter.dart';
import 'package:internshala/utils/decoration.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AllInternships extends StatefulWidget {
  const AllInternships({Key? key}) : super(key: key);

  @override
  State<AllInternships> createState() => _AllInternshipsState();
}

class _AllInternshipsState extends State<AllInternships> {
  late Future<List<Internship>> futureInternships;
  bool? workFromHomeFilter;
  List<String>? cityFilter;
  bool? partTimeFilter;
  String? durationFilter;
  List<String>? profileFilter;
  int totalInternships = 0;
  List<Internship>? allInternships;

  @override
  void initState() {
    super.initState();
    futureInternships = fetchInternships();
  }

  Future<void> _applyFilters() async {
    final filters = await Get.to(() => FilterScreen(
          initialFilters: {
            'selectedProfiles': profileFilter,
            'selectedCities': cityFilter,
            'workFromHome': workFromHomeFilter,
            'selectedDuration': durationFilter,
          },
        ));

    if (filters != null) {
      setState(() {
        profileFilter = filters['selectedProfiles'] as List<String>?;
        workFromHomeFilter = filters['workFromHome'] as bool?;
        cityFilter = filters['selectedCities'] as List<String>?;
        durationFilter = filters['selectedDuration'] as String?;
      });
      _updateFilteredInternships();
    }
  }

  int get selectedFiltersCount {
    int count = 0;
    if (profileFilter != null && profileFilter!.isNotEmpty)
      count += profileFilter!.length;
    if (workFromHomeFilter != null && workFromHomeFilter!) count++;
    if (cityFilter != null && cityFilter!.isNotEmpty)
      count += cityFilter!.length;
    if (durationFilter != null) count++;
    return count;
  }

  void _updateFilteredInternships() {
    if (allInternships != null) {
      setState(() {
        totalInternships = _filterInternships(allInternships!).length;
      });
    }
  }

  List<Internship> _filterInternships(List<Internship> internships) {
    return internships.where((internship) {
      final matchProfile = profileFilter == null ||
          profileFilter!.isEmpty ||
          profileFilter!.contains(internship.profileName);
      final matchWorkFromHome = workFromHomeFilter == null ||
          internship.workFromHome == workFromHomeFilter;
      final matchCity = cityFilter == null ||
          cityFilter!.isEmpty ||
          internship.locationNames
              .any((location) => cityFilter!.contains(location));
      final matchDuration =
          durationFilter == null || internship.duration == durationFilter;

      return matchProfile && matchWorkFromHome && matchCity && matchDuration;
    }).toList();
  }

  Widget _buildActiveFilters() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 0,
      children: [
        if (profileFilter != null)
          for (var profile in profileFilter!)
            _buildFilterChip(profile, () {
              setState(() {
                profileFilter!.remove(profile);
                if (profileFilter!.isEmpty) {
                  profileFilter = null;
                }
              });
              _updateFilteredInternships();
            }),
        if (cityFilter != null)
          for (var city in cityFilter!)
            _buildFilterChip(city, () {
              setState(() {
                cityFilter!.remove(city);
                if (cityFilter!.isEmpty) {
                  cityFilter = null;
                }
              });
              _updateFilteredInternships();
            }),
        if (durationFilter != null)
          _buildFilterChip(durationFilter!, () {
            setState(() {
              durationFilter = null;
            });
            _updateFilteredInternships();
          }),
        if (workFromHomeFilter != null && workFromHomeFilter!)
          _buildFilterChip("Work from Home", () {
            setState(() {
              workFromHomeFilter = null;
            });
            _updateFilteredInternships();
          }),
      ],
    );
  }

Widget _buildFilterChip(String label, VoidCallback onDeleted) {
  return Container(
    margin: const EdgeInsets.only(right: 8),
    child: Chip(
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), 
        side: const BorderSide(color: Colors.grey), 
      ),
      deleteIcon: const Icon(
        Icons.clear,
        size: 16,
        color: Colors.grey,
      ),
      onDeleted: onDeleted,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      labelPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0), 
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Internships"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _applyFilters,
                  child: Container(
                    height: 30,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue, width: 2),
                    ),
                    child: Stack(
                      alignment: selectedFiltersCount > 0
                          ? Alignment.centerLeft
                          : Alignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: selectedFiltersCount > 0 ? 10 : 0,
                          ),
                          child: const Text(
                            "Filter",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        if (selectedFiltersCount > 0)
                          Positioned(
                            right: 4,
                            child: CircleAvatar(
                              backgroundColor: Colors.blue,
                              radius: 10,
                              child: Text(
                                selectedFiltersCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _buildActiveFilters(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Internship>>(
              future: futureInternships,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  allInternships = snapshot.data;
                  final filteredInternships =
                      _filterInternships(allInternships!);

                  if (totalInternships == 0) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        totalInternships = filteredInternships.length;
                      });
                    });
                  }

                  if (filteredInternships.isEmpty) {
                    return const Center(child: Text('No internships found.'));
                  }

                  return ListView.builder(
                    itemCount: filteredInternships.length,
                    itemBuilder: (context, index) {
                      final internship = filteredInternships[index];
                      return InternshipCard(internship: internship);
                    },
                  );
                } else {
                  return const Center(child: Text('No internships found.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class InternshipCard extends StatelessWidget {
  final Internship internship;

  const InternshipCard({Key? key, required this.internship}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (internship.isActive)
                  Container(
                    width: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/images/zigzag.svg",
                              height: 20,
                              width: 20,
                            ),
                            const SizedBox(width: 6),
                            "Actively hiring".text.size(14).make(),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 200,
                  child: Row(
                    children: [
                      internship.profileName.text.bold.xl.make().expand(),
                    ],
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                internship.companyName.text.gray400.make(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/images/home(2).svg",
                      height: 14,
                      width: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                        ' ${internship.workFromHome ? "Work from Home" : internship.locationNames.join(", ")}'),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/images/play_button.svg",
                      height: 14,
                      width: 14,
                    ),
                    const SizedBox(width: 8),
                    internship.startDate.text.make(),
                    const SizedBox(width: 15),
                    SvgPicture.asset(
                      "assets/images/calendar.svg",
                      height: 14,
                      width: 14,
                    ),
                    const SizedBox(width: 8),
                    internship.duration.text.make(),
                  ],
                ),
                const SizedBox(height: 12),
                if (!internship.workFromHome &&
                    internship.locationNames.isNotEmpty)
                  Text('${internship.stipendAmount}'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    internship.isPpo
                        ? const CustomContainer(
                            text: 'Internship with job offer')
                        : const CustomContainer(text: 'Internship'),
                    const SizedBox(width: 10),
                    if (internship.isInternationalJob)
                      const CustomContainer(text: 'International'),
                  ],
                ),
                const SizedBox(height: 12),
                CustomContainer(
                  svgPath: 'assets/images/time.svg',
                  text: internship.postedByLabel,
                ),
                Divider(
                  color: Colors.grey.shade300,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: "View details".text.lg.blue300.make(),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      height: 40,
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue.shade400,
                      ),
                      child: Center(
                        child: "Apply now".text.lg.white.make(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<List<Internship>> fetchInternships() async {
  final url = Uri.parse('https://internshala.com/flutter_hiring/search');
  try {
    final response = await http.get(url);
    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final internshipsData =
          data['internships_meta'] as Map<String, dynamic>? ?? {};

      List<Internship> internships = [];
      internshipsData.forEach((key, value) {
        internships.add(Internship.fromJson(value));
      });

      print('Number of internships fetched: ${internships.length}');
      return internships;
    } else {
      throw Exception('Failed to load internships');
    }
  } catch (e) {
    print('Error fetching internships: $e');
    rethrow;
  }
}

class Internship {
  final Map<String, dynamic> data;

  Internship({required this.data});

  factory Internship.fromJson(Map<String, dynamic> json) {
    return Internship(data: json);
  }

  String get profileName => data['profile_name'] ?? 'No Title';
  String get companyName => data['company_name'] ?? 'No Company Name';
  String get employmentType => data['employment_type'] ?? 'N/A';
  bool get workFromHome => data['work_from_home'] ?? false;
  String get startDate => data['start_date'] ?? 'N/A';
  String get duration => data['duration'] ?? 'N/A';

  String get stipendAmount => data['stipend']['salary'] ?? 'N/A';

  List<String> get locationNames =>
      List<String>.from(data['location_names'] ?? []);
  String get companyLogo => data['company_logo'] ?? '';

  bool get isInternationalJob => data['is_international_job'] ?? false;
  bool get isPpo => data['is_ppo'] ?? false;
  bool get isActive => data['is_active'] ?? false;
  String get postedByLabel => data['posted_by_label'] ?? 'Unknown';
}
