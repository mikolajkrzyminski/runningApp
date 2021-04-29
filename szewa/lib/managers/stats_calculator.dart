import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

class StatsCalculator {
  int timePassed;
  double distance;
  double avgVelocity;
  double calories;
  LatLng prevPosition;

  StatsCalculator() {
    distance = 0;
    avgVelocity = 0;
    calories = 0;
    prevPosition = null;
  }

  updatePosition(LatLng newPosition, int timePassed) {
    if(null != prevPosition) {
      double newDistance = Geolocator.distanceBetween(prevPosition.latitude, prevPosition.longitude, newPosition.latitude, newPosition.longitude);
      distance += newDistance;
      if(0 != distance && 0 != timePassed && !timePassed.isNaN) {
        avgVelocity = distance / timePassed;
        calories += newDistance * 100/1609.344;
      }
    }
    prevPosition = newPosition;
  }

  clearStats() {
    distance = 0;
    avgVelocity = 0;
    calories = 0;
    prevPosition = null;
  }
}

