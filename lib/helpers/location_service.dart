import 'package:eit/helpers/toast.dart';
import 'package:location/location.dart';

class LocationService {
  final Location location = Location();

  Future<bool> checkPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    try {
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return false;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return false;
        }
      }

      return true;
    } catch (e) {
      AppToasts.errorToast(e.toString());
      return false;
    }
  }

  Future<LocationData?> getLocationData() async {
    if (await checkPermission()) {
      try {
        return await location.getLocation();
      } catch (e) {
        await location.requestPermission();
        return null;
      }
    } else {
      return null;
    }
  }
}
