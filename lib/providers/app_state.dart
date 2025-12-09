import 'package:flutter/foundation.dart';

import '../models/models.dart';
import '../services/proximyco_service.dart';

class AppState extends ChangeNotifier {
  final ProximycoService _proximycoService;

  AppState(this._proximycoService);

  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> initialize() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _proximycoService.getCurrentUser();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await _proximycoService.logout();
      _currentUser = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
