import 'package:geolocator/geolocator.dart';

abstract class LocationService {
  Future<Position?> getCurrentLocation();
  Future<Position?> getLastKnownLocation();
  Future<bool> checkPermission();
}

class LocationServiceImpl implements LocationService {
  @override
  Future<bool> checkPermission() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return false;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return false;
      }

      if (permission == LocationPermission.deniedForever) return false;

      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<Position?> getCurrentLocation() async {
    try {
      final hasPermission = await checkPermission();
      if (!hasPermission) return null;

      // 1. Try to get current position with 5-second timeout (medium accuracy works best on emulators and devices)
      try {
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          timeLimit: const Duration(seconds: 5),
        );
      } catch (_) {
        // Fallback to last known position if current times out (e.g. emulator without mock location or indoors)
        final lastKnown = await Geolocator.getLastKnownPosition();
        if (lastKnown != null) return lastKnown;

        // Try low accuracy as a final fallback with short timeout
        try {
          return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low,
            timeLimit: const Duration(seconds: 4),
          );
        } catch (_) {
          return null;
        }
      }
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Position?> getLastKnownLocation() async {
    try {
      final hasPermission = await checkPermission();
      if (hasPermission) {
        return await Geolocator.getLastKnownPosition();
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}