import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class LocationService {
  Position _currentLocation;

  var location = Location();

  StreamController<Position> _locationController =
  StreamController<Position>();

  Stream<Position> get locationStream => _locationController.stream;

  LocationService() {
    // Request permission to use location
    location.requestPermission().then((granted) {
      if (granted != null) {
        location.enableBackgroundMode(enable: true);
        // If granted listen to the onLocationChanged stream and emit over our controller
        location.onLocationChanged.listen((locationData) {
          if (locationData != null) {
            _locationController.add(Position(
              latitude: locationData.latitude,
              longitude: locationData.longitude,
              timestamp: DateTime.fromMillisecondsSinceEpoch(locationData.time.toInt()),
              altitude: locationData.altitude,
              speed: locationData.speed,
              accuracy: locationData.accuracy,
              speedAccuracy: locationData.speedAccuracy,
              heading: locationData.heading,
            ));
          }
        });
      }
    });
  }

  Future<Position> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = Position(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
        timestamp: DateTime.fromMillisecondsSinceEpoch(userLocation.time.toInt()),
        altitude: userLocation.altitude,
        speed: userLocation.speed,
      );
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }

    return _currentLocation;
  }
}