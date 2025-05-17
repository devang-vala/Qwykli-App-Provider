// ================= HOME SCREEN PROVIDER TESTS ====================
import 'package:flutter_test/flutter_test.dart';
import 'package:shortly_provider/features/Home/data/home_screen_provider.dart';

void main() {
  late HomeScreenProvider provider;

  setUp(() {
    provider = HomeScreenProvider(initialLocation: 'Noida Sector 128');
  });

  group('HomeScreenProvider', () {
    test('Initial values are set correctly', () {
      expect(provider.isActive, false);
      expect(provider.selectedLocation, 'Noida Sector 128');
      expect(provider.savedLocations.contains('Noida Sector 128'), true);
    });

    test('Toggling active status updates value', () {
      provider.toggleActiveStatus(true);
      expect(provider.isActive, true);

      provider.toggleActiveStatus(false);
      expect(provider.isActive, false);
    });

    test('Setting selected location works', () {
      provider.setSelectedLocation('DLF Phase 3, Gurgaon');
      expect(provider.selectedLocation, 'DLF Phase 3, Gurgaon');
      expect(provider.savedLocations.contains('DLF Phase 3, Gurgaon'), true);
    });

    test('Adding a new location only if unique & non-empty', () {
      provider.addNewLocation('New Colony');
      expect(provider.savedLocations.contains('New Colony'), true);
      expect(provider.selectedLocation, 'New Colony');

      final previousCount = provider.savedLocations.length;
      provider.addNewLocation('');
      provider.addNewLocation('New Colony'); // duplicate
      expect(provider.savedLocations.length, previousCount);
    });

    test('Using current location updates selectedLocation', () {
      provider.useCurrentLocation('Current City');
      expect(provider.selectedLocation, 'Current City');
    });
  });
}