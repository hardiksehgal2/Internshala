import 'package:flutter/material.dart';

class ProfileSelectionScreen extends StatefulWidget {
  final List<String> selectedProfiles;

  const ProfileSelectionScreen({Key? key, required this.selectedProfiles}) : super(key: key);

  @override
  State<ProfileSelectionScreen> createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  List<String> profiles = [
    'Data Science',
    '.NET Development', '3D Printing', 'ASP.NET Development', 'Accounts', 'Acting',
    'Aerospace Engineering', 'Agriculture & Food Engineering', 'Analytics', 'Anchoring',
    'Android App Development', 'Angular.js Development', 'Animation', 'Architecture',
    'Artificial Intelligence (AI)', 'Audio Making/Editing', 'Auditing',
    'Automobile Engineering', 'Backend Development', 'Bank', 'Big Data', 'Bioinformatics',
    'Biology'
  ];

  List<String> selectedProfiles = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedProfiles = List.from(widget.selectedProfiles);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actions: [
          TextButton(
            child: const Text('Clear all', style: TextStyle(color: Colors.blue)),
            onPressed: () {
              setState(() {
                selectedProfiles.clear();
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context, selectedProfiles);
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
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18),
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
                        hintText: 'Search profile',
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
                    child: Icon(Icons.search, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
          if (selectedProfiles.isNotEmpty)
            Container(
              height: 40, 
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 19),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: selectedProfiles.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              selectedProfiles[index],
                              style: const TextStyle(color: Colors.white, fontSize: 14.0), 
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white, size: 18), 
                            onPressed: () {
                              setState(() {
                                selectedProfiles.removeAt(index);
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
              itemCount: profiles.length,
              itemBuilder: (context, index) {
                final profile = profiles[index];
                if (searchController.text.isNotEmpty &&
                    !profile.toLowerCase().contains(searchController.text.toLowerCase())) {
                  return const SizedBox.shrink();
                }
                return CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(profile),
                  value: selectedProfiles.contains(profile),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedProfiles.add(profile);
                      } else {
                        selectedProfiles.remove(profile);
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
