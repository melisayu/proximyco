import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:proximyco/models/models.dart';
import 'package:proximyco/providers/app_state.dart';
import 'package:proximyco/repositories/repositories.dart';
import 'package:proximyco/screens/profile_screen.dart';
import 'package:proximyco/services/proximyco_service.dart';

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
    child: MaterialApp(home: screen),
  );
}

void main() {
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
