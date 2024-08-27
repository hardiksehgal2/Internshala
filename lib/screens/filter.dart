import 'package:flutter/material.dart';
import 'package:internshala/screens/city_selection_screen.dart';
import 'package:internshala/screens/profile_section_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
        actions: [
          IconButton(icon: const Icon(Icons.bookmark_border), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
          IconButton(icon: const Icon(Icons.chat_bubble_outline), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('PROFILE', style: TextStyle(color: Colors.grey)),
              if (selectedProfiles.isNotEmpty)
                Container(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedProfiles.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Chip(
                          label: Text(selectedProfiles[index]),
                          deleteIcon: const Icon(Icons.close),
                          onDeleted: () {
                            setState(() {
                              selectedProfiles.removeAt(index);
                              _saveSelectedFilters();
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ListTile(
                leading: const Icon(Icons.add, color: Colors.blue),
                title: const Text('Add profile', style: TextStyle(color: Colors.blue)),
                onTap: () => _navigateToProfileSelection(context),
              ),
              const Text('CITY', style: TextStyle(color: Colors.grey)),
              if (selectedCities.isNotEmpty)
                Container(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedCities.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Chip(
                          label: Text(selectedCities[index]),
                          deleteIcon: const Icon(Icons.close),
                          onDeleted: () {
                            setState(() {
                              selectedCities.removeAt(index);
                              _saveSelectedFilters();
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ListTile(
                leading: const Icon(Icons.add, color: Colors.blue),
                title: const Text('Add city', style: TextStyle(color: Colors.blue)),
                onTap: () {
                  _navigateToCitySelection(context);
                },
              ),
              const Text('INTERNSHIP TYPE', style: TextStyle(color: Colors.grey)),
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
              const Text('Maximum Duration', style: TextStyle(color: Colors.grey)),
              DropdownButton<String>(
                hint: const Text('Choose duration'),
                value: selectedDuration,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDuration = newValue;
                    _saveSelectedFilters();
                  });
                },
                items: <String>['1 Month', '2 Months', '3 Months', '4 Months', '6 Months', '12 Months', '24 Months', '36 Months']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              if (selectedDuration != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(selectedDuration!),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              selectedDuration = null;
                              _saveSelectedFilters();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _applyFilters,
                child: const Text('Apply Filters'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToProfileSelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileSelectionScreen(selectedProfiles: selectedProfiles)),
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
      MaterialPageRoute(builder: (context) => CitySelectionScreen(selectedCities: selectedCities)),
    );
    if (result != null) {
      setState(() {
        selectedCities = result;
        _saveSelectedFilters();
      });
    }
  }
}
