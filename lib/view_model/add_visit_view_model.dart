import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import '../data/models/visit_model.dart';
import '../data/repositories/visit_repository.dart';

class AddVisitViewModel extends ChangeNotifier {
  final VisitRepository _repository;

  AddVisitViewModel(this._repository);

  bool _isSaving = false;
  String? _errorMessage;
  double? _latitude;
  double? _longitude;
  File? _capturedImageFile;
  String? _selectedCropType;

  final ImagePicker _imagePicker = ImagePicker();

  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  File? get capturedImageFile => _capturedImageFile;
  String? get selectedCropType => _selectedCropType;

  final List<String> cropOptions = [
    'Wheat', 'Rice', 'Maize', 'Sugarcane', 'Cotton',
    'Soybean', 'Groundnut', 'Pulses', 'Vegetables', 'Other',
  ];

  Future<void> capturePhoto() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      _capturedImageFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  void selectCropType(String? cropType) {
    _selectedCropType = cropType;
    notifyListeners();
  }

  Future<bool> fetchGpsLocation() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
      if (!status.isGranted) {
        _errorMessage = 'Location permission denied. Please enable it in settings.';
        notifyListeners();
        return false;
      }
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _latitude = position.latitude;
      _longitude = position.longitude;
      return true;
    } catch (e) {
      _errorMessage = 'Could not fetch location. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> saveVisit({
    required String farmerName,
    required String village,
    required String cropType,
    required String imagePath,
    String? notes,
  }) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    final locationFetched = await fetchGpsLocation();
    if (!locationFetched) {
      _isSaving = false;
      notifyListeners();
      return false;
    }

    try {
      final newVisit = VisitModel(
        id: const Uuid().v4(),
        farmerName: farmerName,
        village: village,
        cropType: cropType,
        notes: notes,
        imagePath: imagePath,
        visitDate: DateTime.now(),
        latitude: _latitude!,
        longitude: _longitude!,
      );

      final syncError = await _repository.addVisit(newVisit);
      if (syncError != null) {
        _errorMessage = syncError;
      }

      _resetState();
      return true;

    } catch (e) {
      _errorMessage = 'Failed to save visit. Please try again.';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _resetState() {
    _capturedImageFile = null;
    _selectedCropType = null;
    _latitude = null;
    _longitude = null;
  }
}