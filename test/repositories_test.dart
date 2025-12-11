import 'package:flutter_test/flutter_test.dart';
import 'package:proximyco/repositories/repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('InMemoryUserRepository Tests', () {
    late SharedPreferences prefs;
    late InMemoryUserRepository userRepo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      userRepo = InMemoryUserRepository(prefs);
    });

    test('getCurrentUser returns null when no user exists', () async {
      final user = await userRepo.getCurrentUser();
      expect(user, isNull);
    });

    test('createUser creates and stores user', () async {
      final user = await userRepo.createUser('TestUser', '1234 AB');

      expect(user.nickname, 'TestUser');
      expect(user.postalCode, '1234 AB');
      expect(user.rootMinutes, 120);
    });

    test('createUser generates unique ID', () async {
      final user1 = await userRepo.createUser('User1', '1234 AB');
      await userRepo.clearUser();
      final user2 = await userRepo.createUser('User2', '5678 CD');

      expect(user1.id, isNot(equals(user2.id)));
    });

    test('getCurrentUser retrieves stored user', () async {
      await userRepo.createUser('TestUser', '1234 AB');

      final user = await userRepo.getCurrentUser();

      expect(user, isNotNull);
      expect(user!.nickname, 'TestUser');
    });

    test('updateUser modifies existing user', () async {
      final user = await userRepo.createUser('TestUser', '1234 AB');
      final updatedUser = user.copyWith(rootMinutes: 150);

      await userRepo.updateUser(updatedUser);

      final retrieved = await userRepo.getCurrentUser();
      expect(retrieved!.rootMinutes, 150);
    });

    test('updateUser persists all fields correctly', () async {
      final user = await userRepo.createUser('TestUser', '1234 AB');
      final updatedUser = user.copyWith(
        nickname: 'NewName',
        postalCode: '5678 CD',
        rootMinutes: 90,
      );

      await userRepo.updateUser(updatedUser);

      final retrieved = await userRepo.getCurrentUser();
      expect(retrieved!.nickname, 'NewName');
      expect(retrieved.postalCode, '5678 CD');
      expect(retrieved.rootMinutes, 90);
    });

    test('clearUser removes user from storage', () async {
      await userRepo.createUser('TestUser', '1234 AB');

      await userRepo.clearUser();

      final user = await userRepo.getCurrentUser();
      expect(user, isNull);
    });

    test('user data persists across repository instances', () async {
      await userRepo.createUser('TestUser', '1234 AB');

      final newRepo = InMemoryUserRepository(prefs);
      final user = await newRepo.getCurrentUser();

      expect(user, isNotNull);
      expect(user!.nickname, 'TestUser');
    });

    test('handles corrupted JSON gracefully', () async {
      await prefs.setString('current_user', 'invalid json');

      expect(() => userRepo.getCurrentUser(), throwsException);
    });
  });
}
