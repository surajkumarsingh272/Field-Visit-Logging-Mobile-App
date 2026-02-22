class VisitModel {
  final String id;
  final String farmerName;
  final String village;
  final String cropType;
  final String? notes;
  final String imagePath;
  final DateTime visitDate;
  final double latitude;
  final double longitude;
  bool isSynced;

  VisitModel({
    required this.id,
    required this.farmerName,
    required this.village,
    required this.cropType,
    this.notes,
    required this.imagePath,
    required this.visitDate,
    required this.latitude,
    required this.longitude,
    this.isSynced = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'farmerName': farmerName,
    'village': village,
    'cropType': cropType,
    'notes': notes,
    'imagePath': imagePath,
    'visitDate': visitDate.toIso8601String(),
    'latitude': latitude,
    'longitude': longitude,
    'isSynced': isSynced ? 1 : 0,
  };

  factory VisitModel.fromJson(Map<String, dynamic> json) => VisitModel(
    id: json['id'],
    farmerName: json['farmerName'] ?? json['farmer_name'] ?? '',
    village: json['village'] ?? '',
    cropType: json['cropType'] ?? json['crop_type'] ?? '',
    notes: json['notes'],
    imagePath: json['imagePath'] ?? json['image_path'] ?? '',
    visitDate: DateTime.parse(json['visitDate'] ?? json['visit_date']),
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    isSynced: json['isSynced'] == 1,
  );

  VisitModel copyWith({
    String? id,
    String? farmerName,
    String? village,
    String? cropType,
    String? notes,
    String? imagePath,
    DateTime? visitDate,
    double? latitude,
    double? longitude,
    bool? isSynced,
  }) {
    return VisitModel(
      id: id ?? this.id,
      farmerName: farmerName ?? this.farmerName,
      village: village ?? this.village,
      cropType: cropType ?? this.cropType,
      notes: notes ?? this.notes,
      imagePath: imagePath ?? this.imagePath,
      visitDate: visitDate ?? this.visitDate,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}