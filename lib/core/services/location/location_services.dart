import 'package:geolocator/geolocator.dart';

abstract class LocationService {
  Future<Position?> getCurrentLocation();
  Future<bool> checkPermission();
}

class LocationServiceImpl implements LocationService {
  @override
  Future<bool> checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    if (permission == LocationPermission.deniedForever) return false;

    return true;
  }

  @override
  Future<Position?> getCurrentLocation() async {
    final hasPermission = await checkPermission();
    if (hasPermission) {
      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    }
    return null;
  }
}