// ================= UNIT TEST: ORDER DETAILS PROVIDER ====================
import 'package:flutter_test/flutter_test.dart';
import 'package:shortly_provider/features/Home/data/order_details_provider.dart';
import 'package:shortly_provider/features/Home/data/saloon_order_details_provider.dart';

void main() {
  group('OrderDetailsProvider Tests', () {
    late OrderDetailsProvider provider;

    setUp(() {
      provider = OrderDetailsProvider();
    });

    test('Initial state is correct', () {
      expect(provider.isOtpVerified, false);
      expect(provider.isLoadingOtp, false);
      expect(provider.isReceiptCreated, false);
      expect(provider.isLoadingReceipt, false);
      expect(provider.providerName, isNotEmpty);
    });

    test('verifyOtp changes state properly', () async {
      await provider.verifyOtp('1234');
      expect(provider.isOtpVerified, true);
      expect(provider.isLoadingOtp, false);
    });

    test('createReceipt changes receipt state', () async {
      await provider.verifyOtp('1234');
      await provider.createReceipt();
      expect(provider.isReceiptCreated, true);
      expect(provider.isLoadingReceipt, false);
    });

    test('updateProviderDetails updates values', () {
      provider.updateProviderDetails('Ravi', '9999999999', '6:00 PM');
      expect(provider.providerName, 'Ravi');
      expect(provider.providerPhone, '9999999999');
      expect(provider.providerTime, '6:00 PM');
    });
  });

  group('SaloonOrderDetailsProvider Tests', () {
    late SaloonOrderDetailsProvider saloonProvider;

    setUp(() {
      saloonProvider = SaloonOrderDetailsProvider();
    });

    test('Initial state is correct', () {
      expect(saloonProvider.isOtpVerified, false);
      expect(saloonProvider.isLoadingOtp, false);
      expect(saloonProvider.isReceiptCreated, false);
      expect(saloonProvider.isLoadingReceipt, false);
    });

    test('verifyOtp works as expected', () async {
      await saloonProvider.verifyOtp('5678');
      expect(saloonProvider.isOtpVerified, true);
      expect(saloonProvider.isLoadingOtp, false);
    });

    test('createReceipt sets receipt flag correctly', () async {
      await saloonProvider.verifyOtp('5678');
      await saloonProvider.createReceipt();
      expect(saloonProvider.isReceiptCreated, true);
      expect(saloonProvider.isLoadingReceipt, false);
    });
  });
}
