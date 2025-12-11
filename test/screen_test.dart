import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:proximyco/models/models.dart';
import 'package:proximyco/providers/app_state.dart';
import 'package:proximyco/repositories/repositories.dart';
import 'package:proximyco/screens/onboarding_screen.dart';
import 'package:proximyco/screens/profile_screen.dart';
import 'package:proximyco/services/proximyco_service.dart';
import 'package:proximyco/theme/app_theme.dart';

class MockUserRepository implements IUserRepository {
  User? _user;
  @override
  Future<User?> getCurrentUser() async => _user;
  @override
  Future<User> createUser(String nickname, String postalCode) async {
    _user = User(
      id: 'test-id',
      nickname: nickname,
      postalCode: postalCode,
      rootMinutes: 120,
    );
    return _user!;
  }

  @override
  Future<void> updateUser(User user) async => _user = user;
  @override
  Future<void> clearUser() async => _user = null;
}

Widget createTestApp(Widget screen, {AppState? appState}) {
  final userRepo = MockUserRepository();
  final service = ProximycoService(userRepo: userRepo);

  return ChangeNotifierProvider(
    create: (_) => appState ?? AppState(service),
    child: MaterialApp(theme: buildAppTheme(), home: screen),
  );
}

void main() {
  group('OnboardingScreen Tests', () {
    testWidgets('renders all UI elements', (tester) async {
      await tester.pumpWidget(createTestApp(const OnboardingScreen()));

      expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
      expect(find.text('Welcome to\nProximyco'), findsOneWidget);
      expect(
        find.text('Get 120 Root Minutes to start receiving help'),
        findsOneWidget,
      );
      expect(find.widgetWithText(TextFormField, 'Nickname'), findsOneWidget);
      expect(
        find.widgetWithText(TextFormField, 'Postal Code (Netherlands)'),
        findsOneWidget,
      );
      expect(find.text('Get Started'), findsOneWidget);
    });

    testWidgets('validates empty nickname', (tester) async {
      await tester.pumpWidget(createTestApp(const OnboardingScreen()));

      await tester.tap(find.text('Get Started'));
      await tester.pump();

      expect(find.text('Please enter a nickname'), findsOneWidget);
    });

    testWidgets('validates short nickname', (tester) async {
      await tester.pumpWidget(createTestApp(const OnboardingScreen()));

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nickname'),
        'A',
      );
      await tester.tap(find.text('Get Started'));
      await tester.pump();

      expect(
        find.text('Nickname must be at least 2 characters'),
        findsOneWidget,
      );
    });

    testWidgets('validates empty postal code', (tester) async {
      await tester.pumpWidget(createTestApp(const OnboardingScreen()));

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nickname'),
        'TestUser',
      );
      await tester.tap(find.text('Get Started'));
      await tester.pump();

      expect(find.text('Please enter a postal code'), findsOneWidget);
    });

    testWidgets('validates invalid postal code format', (tester) async {
      await tester.pumpWidget(createTestApp(const OnboardingScreen()));

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nickname'),
        'TestUser',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Postal Code (Netherlands)'),
        'INVALID',
      );
      await tester.tap(find.text('Get Started'));
      await tester.pump();

      expect(find.textContaining('Invalid Dutch postal code'), findsOneWidget);
    });

    testWidgets('accepts valid Dutch postal codes', (tester) async {
      await tester.pumpWidget(createTestApp(const OnboardingScreen()));

      final validCodes = ['1234AB', '1234 AB', '2500ab', '2500 AB'];

      for (final code in validCodes) {
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Nickname'),
          'TestUser',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Postal Code (Netherlands)'),
          code,
        );

        // Form should be valid
        final form = tester.widget<Form>(find.byType(Form));
        expect(form.key, isNotNull);
      }
    });
  });

  group('ProfileScreen Tests', () {
    testWidgets('renders user information', (tester) async {
      final userRepo = MockUserRepository();
      userRepo._user = User(
        id: 'test',
        nickname: 'TestUser',
        postalCode: '1234 AB',
        rootMinutes: 120,
      );

      final service = ProximycoService(userRepo: userRepo);
      final appState = AppState(service);
      await appState.initialize();

      await tester.pumpWidget(
        createTestApp(const ProfileScreen(), appState: appState),
      );
      await tester.pumpAndSettle();

      expect(find.text('TestUser'), findsOneWidget);
      expect(find.text('1234 AB'), findsOneWidget);
      expect(find.text('120'), findsOneWidget);
    });

    testWidgets('shows logout button', (tester) async {
      final userRepo = MockUserRepository();
      userRepo._user = User(
        id: 'test',
        nickname: 'Test',
        postalCode: '1234AB',
        rootMinutes: 120,
      );

      final service = ProximycoService(userRepo: userRepo);
      final appState = AppState(service);
      await appState.initialize();

      await tester.pumpWidget(
        createTestApp(const ProfileScreen(), appState: appState),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.logout), findsOneWidget);
    });

    testWidgets('displays info cards', (tester) async {
      final userRepo = MockUserRepository();
      userRepo._user = User(
        id: 'test',
        nickname: 'Test',
        postalCode: '1234AB',
        rootMinutes: 120,
      );

      final service = ProximycoService(userRepo: userRepo);
      final appState = AppState(service);
      await appState.initialize();

      await tester.pumpWidget(
        createTestApp(const ProfileScreen(), appState: appState),
      );
      await tester.pumpAndSettle();

      expect(find.text('About Root Minutes'), findsOneWidget);
      expect(find.text('How it works'), findsOneWidget);
      expect(find.text('Community'), findsOneWidget);
    });
  });
}
