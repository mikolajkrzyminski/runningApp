import 'package:flutter_map/flutter_map.dart';
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

  static LatLngBounds getSquare(List<LatLng> positions) {
    double minLng = 0;
    double maxLng = 0;
    double minLat = 0;
    double maxLat = 0;
    if(null != positions && positions.length > 0) {
      minLng = positions[0].longitude;
      maxLng = positions[0].longitude;
      minLat = positions[0].latitude;
      maxLat = positions[0].latitude;
      for(LatLng position in positions) {
        if(position.longitude < minLng) minLng = position.longitude;
        if(position.longitude > maxLng) maxLng = position.longitude;
        if(position.latitude < minLat) minLat = position.latitude;
        if(position.latitude > maxLat) maxLat = position.latitude;
      }
      double lngDiff = (maxLng - minLng).abs();
      double latDiff = (maxLat - minLat).abs();
      if(lngDiff > latDiff)  {
        double diff = (lngDiff - latDiff) / 2;
        minLat -= diff;
        maxLat += diff;
      } else if(latDiff > lngDiff) {
        double diff = (latDiff - lngDiff) / 2;
        minLng -= diff;
        maxLng += diff;
      }
    }
    return LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng));
  }
}

