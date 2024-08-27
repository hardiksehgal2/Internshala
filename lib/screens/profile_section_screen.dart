import 'package:flutter/material.dart';

class ProfileSelectionScreen extends StatefulWidget {
  final List<String> selectedProfiles;

  const ProfileSelectionScreen({Key? key, required this.selectedProfiles}) : super(key: key);

  @override
  State<ProfileSelectionScreen> createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  List<String> profiles = [
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
        actions: [
          TextButton(
            child: const Text('Clear all', style: TextStyle(color: Colors.blue)),
            onPressed: () {
              setState(() {
                selectedProfiles.clear();
              });
            },
          ),
          TextButton(
            child: const Text('Apply', style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.pop(context, selectedProfiles);
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
                hintText: 'Search profile',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
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
                    child: Chip(
                      label: Text(selectedProfiles[index]),
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () {
                        setState(() {
                          selectedProfiles.removeAt(index);
                        });
                      },
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