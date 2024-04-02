import 'package:geolocator/geolocator.dart';

Future<bool> isWithinDistance({required String gpsLocation}) async {
  Position userLocation = await Geolocator.getCurrentPosition();
  List<String> coordinates = gpsLocation.split('-');
  double distanceInMeters = await Geolocator.distanceBetween(
    double.parse(coordinates[0]),
    double.parse(coordinates[1]),
    userLocation.latitude,
    userLocation.longitude,
  );

  return distanceInMeters <= 500;
}
