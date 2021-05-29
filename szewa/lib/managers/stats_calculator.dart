import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:szewa/models/run_model.dart';
import 'package:intl/intl.dart';


class StatsCalculator {
  int timePassed;
  double distance;
  double avgVelocity;
  double calories;
  LatLng prevPosition;

  StatsCalculator() {
    timePassed = 0;
    distance = 0;
    avgVelocity = 0;
    calories = 0;
    prevPosition = null;

  }

  updatePosition(LatLng newPosition) {
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
    timePassed = 0;
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

  ActivitySummary createData(List<RunModel> data, DateTime dateFrom, DateTime dateTo, bool onlyActivities) {
    List<TimeDistanceSeries> seriesData = [];
    int sumDuration = 0;
    int sumCalories = 0;
    double sumDistance = 0;
    int numberOfActivities = 0;
    int denominator = 0;
    if (DateTime(dateFrom.year, dateFrom.month, dateFrom.day) != DateTime(dateTo.year, dateTo.month, dateTo.day)) {
      for (var i = 0; i <= dateTo.difference(dateFrom).inDays; i++) {
        seriesData.add(TimeDistanceSeries(dateFrom.add(Duration(days: i)), 0.0, 0, 0));
      }
      if (!onlyActivities) denominator = seriesData.length;
    }
    for (final item in data) {
      if (dateFrom.millisecondsSinceEpoch <= item.dateTime && item.dateTime < dateTo.add(Duration(days : 1)).millisecondsSinceEpoch) {
        // summary part
        sumDuration += item.duration;
        sumCalories += item.calories;
        sumDistance += item.distance;
        numberOfActivities += 1;
        if (DateTime(dateFrom.year, dateFrom.month, dateFrom.day) != DateTime(dateTo.year, dateTo.month, dateTo.day)) {
          int index = seriesData.indexWhere((element) => DateFormat.yMMMd().format(element.time) == DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(item.dateTime)));
          double distance = seriesData[index].distance + double.parse((item.distance).toStringAsFixed(2));
          int calories = seriesData[index].calories + item.calories;
          int duration = seriesData[index].duration + item.duration;
          seriesData.removeAt(index);
          seriesData.add(
              TimeDistanceSeries(
                DateTime(DateTime.fromMillisecondsSinceEpoch(item.dateTime).year, DateTime.fromMillisecondsSinceEpoch(item.dateTime).month, DateTime.fromMillisecondsSinceEpoch(item.dateTime).day),
                distance,
                calories,
                duration,
              ));
        } else {
          seriesData.add(
              TimeDistanceSeries(
                DateTime.fromMillisecondsSinceEpoch(item.dateTime),
                item.distance,
                item.calories,
                item.duration,
              ));
        }
      }
    }
    if (onlyActivities) denominator = numberOfActivities;
    if (denominator > 0) {
      sumDuration = (sumDuration).round();
      sumCalories = (sumCalories).round();
    }
    return
      ActivitySummary(sumDuration,
          sumCalories,
          sumDistance,
          denominator > 0 ? sumDistance/denominator : sumDistance,
          denominator > 0 ? (sumDuration/denominator).round() : sumDuration,
          numberOfActivities,
          [
      charts.Series<TimeDistanceSeries, DateTime>(
        id: 'distance',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFF00334E)),
        domainFn: (TimeDistanceSeries activity, _) => activity.time,
        measureFn: (TimeDistanceSeries activity, _) => activity.distance / 1000,
        data: seriesData,
      ),
    ]);
  }

}

class TimeDistanceSeries {
  final DateTime time;
  final double distance;
  final int calories;
  final int duration;
  TimeDistanceSeries(this.time, this.distance, this.calories, this.duration);
}

class ActivitySummary {
  final int sumDuration;
  final int sumCalories;
  final double sumDistance;
  final double avgDistance;
  final int avgDuration;
  final int numberOfActivities;

  final List<charts.Series<TimeDistanceSeries, DateTime>> activitySeries;

  ActivitySummary(this.sumDuration, this.sumCalories, this.sumDistance, this.avgDistance, this.avgDuration, this.numberOfActivities, this.activitySeries);
}