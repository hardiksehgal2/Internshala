import 'package:flutter/material.dart';

class CitySelectionScreen extends StatefulWidget {
  final List<String> selectedCities;

  const CitySelectionScreen({Key? key, required this.selectedCities}) : super(key: key);

  @override
  State<CitySelectionScreen> createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen> {
  List<String> cities = [
    'New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix', 'Philadelphia', 'San Antonio',
    'San Diego', 'Dallas', 'San Jose', 'Delhi', 'Lucknow'
  ];

  List<String> selectedCities = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedCities = List.from(widget.selectedCities);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select City'),
        actions: [
          TextButton(
            child: const Text('Clear all', style: TextStyle(color: Colors.blue)),
            onPressed: () {
              setState(() {
                selectedCities.clear();
              });
            },
          ),
          TextButton(
            child: const Text('Apply', style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.pop(context, selectedCities);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search city',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
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
                    child: Chip(
                      label: Text(selectedCities[index]),
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () {
                        setState(() {
                          selectedCities.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index) {
                final city = cities[index];
                if (searchController.text.isNotEmpty &&
                    !city.toLowerCase().contains(searchController.text.toLowerCase())) {
                  return const SizedBox.shrink();
                }
                return CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(city),
                  value: selectedCities.contains(city),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedCities.add(city);
                      } else {
                        selectedCities.remove(city);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
