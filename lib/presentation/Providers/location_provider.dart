import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final locationBoxProvider = Provider<Box<String>>((ref) {
  final box = Hive.box<String>('savedLocations');

  if (!box.isOpen) {
    throw Exception("Hive box 'savedLocations' is not open.");
  }

  return box;
});

final locationListProvider = StateNotifierProvider<LocationNotifier, List<String>>((ref) {
  final box = ref.watch(locationBoxProvider);
  return LocationNotifier(box);
});

class LocationNotifier extends StateNotifier<List<String>> {
  final Box<String> _box;

  LocationNotifier(this._box) : super(_box.values.toList());

  void addLocation(String city) {
    if (!_box.values.contains(city)) {
      _box.add(city);
      state = [..._box.values];
    }
  }

  void removeLocation(String city) {
    final key = _box.keys.firstWhere((k) => _box.get(k) == city, orElse: () => null);
    if (key != null) {
      _box.delete(key);
      state = [..._box.values];
    }
  }
}
