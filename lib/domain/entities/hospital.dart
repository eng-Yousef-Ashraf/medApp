import 'package:equatable/equatable.dart';

class Hospital extends Equatable {
  final String id;
  final String name;
  final String address;
  final String phone;
  final double latitude;
  final double longitude;
  final bool emergencyAvailable;
  final String distance;
  final double rating;
  final bool is24Hours;

  const Hospital({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.emergencyAvailable,
    required this.distance,
    required this.rating,
    required this.is24Hours,
  });

  @override
  List<Object?> get props => [id];
}
