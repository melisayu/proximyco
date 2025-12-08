import 'package:flutter_test/flutter_test.dart';
import 'package:proximyco/models/models.dart';

void main() {
  group('User Model Tests', () {
    test('should create user with correct properties', () {
      final user = User(
        id: 'test-id',
        nickname: 'TestUser',
        postalCode: '1234 AB',
        rootMinutes: 120,
      );

      expect(user.id, 'test-id');
      expect(user.nickname, 'TestUser');
      expect(user.postalCode, '1234 AB');
      expect(user.rootMinutes, 120);
    });

    test('should serialize to JSON correctly', () {
      final user = User(
        id: 'test-id',
        nickname: 'TestUser',
        postalCode: '1234 AB',
        rootMinutes: 120,
      );

      final json = user.toJson();

      expect(json['id'], 'test-id');
      expect(json['nickname'], 'TestUser');
      expect(json['postalCode'], '1234 AB');
      expect(json['rootMinutes'], 120);
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'id': 'test-id',
        'nickname': 'TestUser',
        'postalCode': '1234 AB',
        'rootMinutes': 120,
      };

      final user = User.fromJson(json);

      expect(user.id, 'test-id');
      expect(user.nickname, 'TestUser');
      expect(user.postalCode, '1234 AB');
      expect(user.rootMinutes, 120);
    });

    test('should create copy with updated properties', () {
      final user = User(
        id: 'test-id',
        nickname: 'TestUser',
        postalCode: '1234 AB',
        rootMinutes: 120,
      );

      final updatedUser = user.copyWith(rootMinutes: 150, nickname: 'NewName');

      expect(updatedUser.rootMinutes, 150);
      expect(updatedUser.nickname, 'NewName');
      expect(updatedUser.id, user.id);
      expect(updatedUser.postalCode, user.postalCode);
    });

    test('should maintain immutability in copyWith', () {
      final user = User(
        id: 'test-id',
        nickname: 'TestUser',
        postalCode: '1234 AB',
        rootMinutes: 120,
      );

      final updatedUser = user.copyWith(rootMinutes: 150);

      expect(user.rootMinutes, 120);
      expect(updatedUser.rootMinutes, 150);
    });
  });
}
