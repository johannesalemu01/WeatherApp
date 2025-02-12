import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather/presentation/Providers/location_provider.dart';
import 'package:weather/presentation/Providers/weather_provider.dart';

class LocationSelectionScreen extends ConsumerStatefulWidget {
  const LocationSelectionScreen({super.key});

  @override
  _LocationSelectionScreenState createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState
    extends ConsumerState<LocationSelectionScreen> {
  String searchQuery = "";

  void _filterLocations(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  void _addLocationAndRedirect(String city) {
    final locationNotifier = ref.read(locationListProvider.notifier);
    locationNotifier.addLocation(city);
    Navigator.pop(context, city);
  }

  @override
  Widget build(BuildContext context) {
    final savedLocations = ref.watch(locationListProvider);
    final filteredLocations = savedLocations
        .where((city) => city.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Edit Locations",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              style: const TextStyle(color: Colors.white70),
              onChanged: _filterLocations,
              decoration: InputDecoration(
                label:
                    const Text('CITY', style: TextStyle(color: Colors.white70)),
                hintText: "Enter the name of the city",
                hintStyle: const TextStyle(color: Colors.white38),
                suffixIcon: IconButton(
                    onPressed: () {
                      if (searchQuery.isNotEmpty &&
                          !savedLocations.contains(searchQuery)) {
                        _addLocationAndRedirect(searchQuery);
                      }
                    },
                    icon: Icon(Icons.search),
                    color: Colors.white),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white70),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (searchQuery.isNotEmpty &&
                    !savedLocations.contains(searchQuery)) {
                  _addLocationAndRedirect(searchQuery);
                }
              },
              child: const Text("Add and Search City"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredLocations.length,
                itemBuilder: (context, index) {
                  String city = filteredLocations[index];
                  bool isSaved = savedLocations.contains(city);

                  return GestureDetector(
                    onTap: () {
                      if (isSaved) {
                        ref.read(selectedCityProvider.notifier).state = city;
                        ref
                            .read(locationListProvider.notifier)
                            .removeLocation(city);
                        _addLocationAndRedirect(city);
                      } else {
                        _addLocationAndRedirect(city);
                      }
                    },
                    child: Card(
                      color: Colors.grey[900],
                      child: ListTile(
                        title: Text(city,
                            style: const TextStyle(color: Colors.white)),
                        trailing: isSaved
                            ? InkWell(
                                onTap: () => ref
                                    .read(locationListProvider.notifier)
                                    .removeLocation(city),
                                child: const Icon(Icons.remove,
                                    color: Colors.green),
                              )
                            : const Icon(Icons.remove, color: Colors.green),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
