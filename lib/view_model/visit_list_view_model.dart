import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../data/models/visit_model.dart';
import '../data/repositories/visit_repository.dart';


class VisitListViewModel extends ChangeNotifier {
  final VisitRepository _repository;

  List<VisitModel> _visits = [];
  bool _isLoading = true;
  bool _isSyncing = false;
  String? _errorMessage;

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  VisitListViewModel(this._repository) {
    _initialize();
  }


  List<VisitModel> get visits => _visits;
  bool get isLoading => _isLoading;
  bool get isSyncing => _isSyncing;
  String? get errorMessage => _errorMessage;

  Future<void> _initialize() async {
    await loadVisits();
    _listenToConnectivity();
  }

  Future<void> loadVisits() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _visits = await _repository.getAllVisits();
    } catch (e) {
      _errorMessage = 'Failed to load visits. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addVisit(VisitModel visit) async {
    await _repository.addVisit(visit);
    await _reloadVisits();
  }

  Future<void> _reloadVisits() async {
    try {
      _visits = await _repository.getAllVisits();
    } catch (e) {
      throw Exception(e);
    }
    notifyListeners();
  }

  Future<void> _syncAndReload() async {
    if (_isSyncing) return;
    _isSyncing = true;
    notifyListeners();

    try {
      await _repository.syncPendingVisits();
      await _reloadVisits();
    } catch (e) {
      throw Exception("Error $e");
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  void _listenToConnectivity() {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((results) {
          final hasInternet = results.isNotEmpty &&
              !results.contains(ConnectivityResult.none);

          if (hasInternet) {
            _syncAndReload();
          }
        });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}