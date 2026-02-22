import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../data/repositories/visit_repository.dart';

class SyncService {
  final VisitRepository _repository = VisitRepository();

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isSyncing = false;

  void startListening() {
    _connectivitySubscription?.cancel();

    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_onConnectivityChanged);
  }

  Future<void> _onConnectivityChanged(
      List<ConnectivityResult> results) async {
    final hasInternet = results.isNotEmpty &&
        !results.contains(ConnectivityResult.none);

    if (hasInternet) {
      await _syncNow();
    }
  }

  Future<void> _syncNow() async {
    if (_isSyncing) return;
    _isSyncing = true;
    try {
      await _repository.syncPendingVisits();
    } catch (e) {
      throw Exception("Error $e");
    } finally {
      _isSyncing = false;
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }
}