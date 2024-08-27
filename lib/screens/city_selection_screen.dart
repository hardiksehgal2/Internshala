import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:internshala/screens/city_data.dart';

class CitySelectionScreen extends StatefulWidget {
  final List<String> selectedCities;

  const CitySelectionScreen({Key? key, required this.selectedCities}) : super(key: key);

  @override
  State<CitySelectionScreen> createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen> {
  List<String> cities = CityData.cities;
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
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actions: [
          TextButton(
            child: const Text('Clear all', style: TextStyle(color: Colors.blue)),
            onPressed: () {
              setState(() {
                selectedCities.clear();
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 19.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context, selectedCities);
              },
              child: Container(
                height: 40,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.blue.shade400,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(child: const Text('Apply', style: TextStyle(color: Colors.white))),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 18),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search city',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Icon(Icons.location_city, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
          if (selectedCities.isNotEmpty)
            Container(
              height: 40, // Decreased height
              padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 19),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: selectedCities.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      // padding: const EdgeInsets.symmetric(horizontal: 8.0), 
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(

                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: Text(
                              selectedCities[index],
                              style: const TextStyle(color: Colors.white, fontSize: 14.0),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white,size:18),
                            onPressed: () {
                              setState(() {
                                selectedCities.removeAt(index);
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
