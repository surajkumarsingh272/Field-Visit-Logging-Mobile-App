import 'package:dio/dio.dart';
import '../data/models/visit_model.dart';

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://visitors.edugaondev.com',
      connectTimeout: const Duration(seconds: 40),
      receiveTimeout: const Duration(seconds: 40),
    ),
  );

  Future<bool> uploadVisit(VisitModel visit) async {
    try {
      final formData = FormData.fromMap({
        'farmerName': visit.farmerName,
        'village': visit.village,
        'cropType': visit.cropType,
        'notes': visit.notes ?? '',
        'latitude': visit.latitude.toString(),
        'longitude': visit.longitude.toString(),
        'visitDate': visit.visitDate.toIso8601String(),
        'image': await MultipartFile.fromFile(
          visit.imagePath,
          filename: visit.imagePath.split('/').last,
        ),
      });

      final response = await _dio.post('/visits', data: formData);
      return response.statusCode == 200 || response.statusCode == 201;

    } on DioException catch (e) {
      throw ApiException(_dioErrorMessage(e));
    } catch (e) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  Future<List<Map<String, dynamic>>> getVisits() async {
    try {
      final response = await _dio.get('/visits');
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      }
      return [];
    } on DioException catch (e) {
      throw ApiException(_dioErrorMessage(e));
    } catch (e) {
      throw ApiException('Failed to fetch visits.');
    }
  }

  String _dioErrorMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please check your internet speed.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Visit saved offline.';
      case DioExceptionType.badResponse:
        return 'Server error (${e.response?.statusCode}). Please try again later.';
      default:
        return 'Network error. Please try again.';
    }
  }
}