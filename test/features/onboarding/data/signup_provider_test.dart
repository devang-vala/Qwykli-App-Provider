// ================= SIGNUP PROVIDER + VALIDATION TESTS ====================
import 'package:flutter_test/flutter_test.dart';
import 'package:shortly_provider/features/auth/data/signup_provider.dart';

void main() {
  late SignupProvider provider;

  setUp(() {
    provider = SignupProvider();
  });

  group('SignupProvider Unit Tests', () {
    test('Toggle category adds/removes correctly', () {
      provider.toggleCategory('Electrician');
      expect(provider.selectedCategories.contains('Electrician'), true);

      provider.toggleCategory('Electrician');
      expect(provider.selectedCategories.contains('Electrician'), false);
    });

    test('Toggle service adds/removes correctly', () {
      provider.toggleService('Fan Installation');
      expect(provider.selectedServices.contains('Fan Installation'), true);

      provider.toggleService('Fan Installation');
      expect(provider.selectedServices.contains('Fan Installation'), false);
    });

    test('Toggle sub-service within a category', () {
      provider.toggleSubService('Electrician', 'Fan Installation');
      expect(provider.selectedSubServices['Electrician'], contains('Fan Installation'));

      provider.toggleSubService('Electrician', 'Fan Installation');
      expect(provider.selectedSubServices['Electrician']!.contains('Fan Installation'), false);
    });

    test('Toggle expansion for service section', () {
      provider.toggleExpansion('Electrician');
      expect(provider.expandedServices.contains('Electrician'), true);
      provider.toggleExpansion('Electrician');
      expect(provider.expandedServices.contains('Electrician'), false);
    });

    test('Toggle location updates selectedLocations', () {
      provider.toggleLocation('Dwarka');
      expect(provider.selectedLocations.contains('Dwarka'), true);

      provider.toggleLocation('Dwarka');
      expect(provider.selectedLocations.contains('Dwarka'), false);
    });

    test('Search filters locations case-insensitively', () {
      provider.updateSearchQuery('roh');
      expect(provider.filteredLocations, contains('Rohini'));
    });

    test('Select category sets selectedCategory', () {
      provider.selectCategory('Salon');
      expect(provider.selectedCategory, equals('Salon'));
    });

    test('Reset clears all state values', () {
      provider.toggleLocation('Dwarka');
      provider.toggleCategory('Plumber');
      provider.toggleService('Leak Fix');
      provider.selectCategory('Electrician');
      provider.toggleSubService('Electrician', 'Fan Installation');
      provider.toggleExpansion('Electrician');

      provider.reset();

      expect(provider.selectedLocations.isEmpty, true);
      expect(provider.selectedCategories.isEmpty, true);
      expect(provider.selectedServices.isEmpty, true);
      expect(provider.selectedSubServices.isEmpty, true);
      expect(provider.expandedServices.isEmpty, true);
      expect(provider.selectedCategory, null);
    });
  });
}