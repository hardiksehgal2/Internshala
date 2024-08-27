// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:internshala/screens/city_selection_screen.dart';
import 'package:internshala/screens/profile_section_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class FilterScreen extends StatefulWidget {
  final Map<String, dynamic>? initialFilters;

  const FilterScreen({Key? key, this.initialFilters}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List<String> selectedProfiles = [];
  List<String> selectedCities = [];
  bool workFromHome = false;
  String? selectedDuration;

  @override
  void initState() {
    super.initState();
    _loadSelectedFilters();
  }

  Future<void> _loadSelectedFilters() async {
    if (widget.initialFilters != null) {
      setState(() {
        selectedProfiles = widget.initialFilters!['selectedProfiles'] ?? [];
        selectedCities = widget.initialFilters!['selectedCities'] ?? [];
        workFromHome = widget.initialFilters!['workFromHome'] ?? false;
        selectedDuration = widget.initialFilters!['selectedDuration'];
      });
    } else {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        selectedProfiles = prefs.getStringList('selectedProfiles') ?? [];
        selectedCities = prefs.getStringList('selectedCities') ?? [];
        workFromHome = prefs.getBool('workFromHome') ?? false;
        selectedDuration = prefs.getString('selectedDuration');
      });
    }
  }

  Future<void> _saveSelectedFilters() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selectedProfiles', selectedProfiles);
    await prefs.setStringList('selectedCities', selectedCities);
    await prefs.setBool('workFromHome', workFromHome);
    await prefs.setString('selectedDuration', selectedDuration ?? '');
  }

void _applyFilters() {
    Navigator.pop(context, {
      'selectedProfiles': selectedProfiles,
      'selectedCities': selectedCities,
      'workFromHome': workFromHome,
      'selectedDuration': selectedDuration,
    });
  }
  bool _validateFilters() {
    if (selectedProfiles.isEmpty &&
        selectedCities.isEmpty &&
        selectedDuration == null &&
        !workFromHome) {
      VxToast.show(context, msg: "Please select at least one filter");
      return false;
    }
    return true;
  }

  void _clearAllFilters() {
    setState(() {
      selectedProfiles.clear();
      selectedCities.clear();
      workFromHome = false;
      selectedDuration = null;
      _saveSelectedFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.bookmark_border), onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.notifications_none), onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.chat_bubble_outline), onPressed: () {}),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('PROFILE', style: TextStyle(color: Colors.grey)),
              SizedBox(
                height: 16,
              ),
              if (selectedProfiles.isNotEmpty)
                Container(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedProfiles.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade400,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  selectedProfiles[index],
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14.0),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.white, size: 18),
                                onPressed: () {
                                  setState(() {
                                    selectedProfiles.removeAt(index);
                                    _saveSelectedFilters();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ListTile(
                leading: const Icon(Icons.add, color: Colors.blue),
                title: const Text('Add profile',
                    style: TextStyle(color: Colors.blue)),
                onTap: () => _navigateToProfileSelection(context),
              ),
              SizedBox(
                height: 16,
              ),
              const Text('CITY', style: TextStyle(color: Colors.grey)),
              SizedBox(
                height: 16,
              ),
              if (selectedCities.isNotEmpty)
                Container(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedCities.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade400,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  selectedCities[index],
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14.0),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.white, size: 18),
                                onPressed: () {
                                  setState(() {
                                    selectedCities.removeAt(index);
                                    _saveSelectedFilters();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ListTile(
                leading: const Icon(Icons.add, color: Colors.blue),
                title: const Text('Add city',
                    style: TextStyle(color: Colors.blue)),
                onTap: () {
                  _navigateToCitySelection(context);
                },
              ),
              const Text('INTERNSHIP TYPE',
                  style: TextStyle(color: Colors.grey)),
              CheckboxListTile(
                title: const Text('Work from home'),
                value: workFromHome,
                onChanged: (value) {
                  setState(() {
                    workFromHome = value!;
                    _saveSelectedFilters();
                  });
                },
              ),
              "Maximum Duration".text.gray400.lg.make(),
              const SizedBox(
                height: 16,
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.blue.shade400,
                    width: 1.0,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: Text(
                      'Choose duration',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    value: selectedDuration,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDuration = newValue;
                        _saveSelectedFilters();
                      });
                    },
                    icon: selectedDuration != null
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDuration = null;
                                _saveSelectedFilters();
                              });
                            },
                            child:
                                Icon(Icons.close, color: Colors.blue, size: 18),
                          )
                        : Icon(Icons.arrow_drop_down, color: Colors.grey),
                    selectedItemBuilder: (BuildContext context) {
                      return <String>[
                        '1 Month',
                        '2 Months',
                        '3 Months',
                        '4 Months',
                        '6 Months',
                        '12 Months',
                        '24 Months',
                        '36 Months'
                      ].map<Widget>((String item) {
                        return Container(
                          alignment: Alignment.centerLeft,
                          constraints: const BoxConstraints(minWidth: 100),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade400,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                        );
                      }).toList();
                    },
                    items: <String>[
                      '1 Month',
                      '2 Months',
                      '3 Months',
                      '4 Months',
                      '6 Months',
                      '12 Months',
                      '24 Months',
                      '36 Months'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: _clearAllFilters,
                  child: Center(
                    child: Text(
                      'Clear all',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue.shade400,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: _applyFilters,
                  child: Center(
                    child: Text(
                      'Apply',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToProfileSelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ProfileSelectionScreen(selectedProfiles: selectedProfiles)),
    );
    if (result != null) {
      setState(() {
        selectedProfiles = result;
        _saveSelectedFilters();
      });
    }
  }

  void _navigateToCitySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              CitySelectionScreen(selectedCities: selectedCities)),
    );
    if (result != null) {
      setState(() {
        selectedCities = result;
        _saveSelectedFilters();
      });
    }
  }
}
