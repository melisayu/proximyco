import '../models/models.dart';
import '../repositories/repositories.dart';

class ProximycoService {
  final IUserRepository _userRepo;

  ProximycoService({required IUserRepository userRepo}) : _userRepo = userRepo;

  Future<User?> getCurrentUser() => _userRepo.getCurrentUser();

  Future<User> registerUser(
    String nickname,
    String postalCode,
    double lat,
    double lon,
  ) {
    return _userRepo.createUser(nickname, postalCode);
  }

  Future<void> logout() async {
    await _userRepo.clearUser();
  }
}
