import 'package:flutter_test/flutter_test.dart';
import 'package:proximyco/models/models.dart';
import 'package:proximyco/providers/app_state.dart';
import 'package:proximyco/repositories/repositories.dart';
import 'package:proximyco/services/proximyco_service.dart';

class MockUserRepository implements IUserRepository {
  User? _user;
  bool shouldThrowError = false;

  @override
  Future<User?> getCurrentUser() async {
    if (shouldThrowError) throw Exception('Database error');
    return _user;
  }

  @override
  Future<User> createUser(String nickname, String postalCode) async {
    if (shouldThrowError) throw Exception('Creation failed');
    _user = User(
      id: 'test-id',
      nickname: nickname,
      postalCode: postalCode,
      rootMinutes: 120,
    );
    return _user!;
  }

  @override
  Future<void> updateUser(User user) async {
    if (shouldThrowError) throw Exception('Update failed');
    _user = user;
  }

  @override
  Future<void> clearUser() async {
    _user = null;
  }
}

void main() {
  late AppState appState;
  late MockUserRepository userRepo;
  late ProximycoService service;

  setUp(() {
    userRepo = MockUserRepository();
    service = ProximycoService(userRepo: userRepo);
    appState = AppState(service);
  });

  group('AppState Initialization Tests', () {
    test('initial state is correct', () {
      expect(appState.currentUser, isNull);
      expect(appState.isLoading, false);
      expect(appState.error, isNull);
    });

    test('initialize loads current user if exists', () async {
      userRepo._user = User(
        id: 'test-id',
        nickname: 'TestUser',
        postalCode: '1234 AB',
        rootMinutes: 120,
      );

      await appState.initialize();

      expect(appState.currentUser, isNotNull);
      expect(appState.currentUser!.nickname, 'TestUser');
      expect(appState.isLoading, false);
    });

    test('initialize sets loading state', () async {
      bool wasLoading = false;
      appState.addListener(() {
        if (appState.isLoading) wasLoading = true;
      });

      await appState.initialize();

      expect(wasLoading, true);
      expect(appState.isLoading, false);
    });

    test('initialize handles errors gracefully', () async {
      userRepo.shouldThrowError = true;

      await appState.initialize();

      expect(appState.error, isNotNull);
      expect(appState.error, contains('Database error'));
      expect(appState.isLoading, false);
    });
  });

  group('State Consistency Tests', () {
    test('isLoggedIn reflects user state', () async {
      expect(appState.isLoggedIn, false);

      await appState.registerUser('TestUser', '1234 AB');
      expect(appState.isLoggedIn, true);

      await appState.logout();
      expect(appState.isLoggedIn, false);
    });

    test('loading state returns to false after operations', () async {
      await appState.registerUser('TestUser', '1234 AB');
      expect(appState.isLoading, false);
    });
  });
}
