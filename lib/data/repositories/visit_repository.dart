import 'package:connectivity_plus/connectivity_plus.dart';
import '../../services/api_service.dart';
import '../data_sources/sqflite_helper.dart';
import '../models/visit_model.dart';

class VisitRepository {
  final SqfliteHelper _dbHelper = SqfliteHelper();
  final ApiService _apiService = ApiService();

  Future<String?> addVisit(VisitModel visit) async {
    await _dbHelper.insertVisit(visit);

    final connectivity = await Connectivity().checkConnectivity();
    final hasInternet = !connectivity.contains(ConnectivityResult.none);

    if (hasInternet) {
      try {
        final success = await _apiService.uploadVisit(visit);
        if (success) {
          visit.isSynced = true;
          await _dbHelper.updateVisit(visit);
        }
      } on ApiException catch (e) {
        return e.message;
      }
    }
    return null;
  }

  Future<List<VisitModel>> getAllVisits() async {
    final localVisits = await _dbHelper.getVisits();
    if (localVisits.isNotEmpty) return localVisits;

    try {
      final remoteData = await _apiService.getVisits();
      for (final json in remoteData) {
        final visit = VisitModel.fromJson(json);
        visit.isSynced = true;
        await _dbHelper.insertVisit(visit);
      }
    } on ApiException {
      return [];
    }

    return await _dbHelper.getVisits();
  }

  Future<void> updateVisit(VisitModel visit) async {
    await _dbHelper.updateVisit(visit);
  }

  Future<void> syncPendingVisits() async {
    final pendingVisits = await _dbHelper.getPendingVisits();

    for (final visit in pendingVisits) {
      try {
        final success = await _apiService.uploadVisit(visit);
        if (success) {
          visit.isSynced = true;
          await _dbHelper.updateVisit(visit);
        }
      } on ApiException {
        continue;
      }
    }
  }
}