import 'dart:math' as Math;

import 'package:vector_math/vector_math.dart';


/// addMetersInLatLng is created to add distance by meters in current Lat/Lng
/// pLatitude -: Latitude value
/// pLongitude -: Longitude value
/// pDistanceInMeters -: Accuracy value

List<double> addMetersInLatLng(
    double pLatitude, double pLongitude, int pDistanceInMeters) {
  List<double> latLngList = new List<double>();

  final double latRadian = radians(pLatitude);
  /// default value 1 degree of latitude value in KiloMeter
  final double degLatKm = 110.574235;
  /// default value 1 degree of Longitude value in KiloMeter
  final double degLongKm = 110.572833 * Math.cos(latRadian);
  final double deltaLat = (pDistanceInMeters / 1000.0) / degLatKm;
  final double deltaLong = (pDistanceInMeters / 1000.0) / degLongKm;

  double maxLat = 0.0;
  double maxLong = 0.0;

  /// this code is added to avoid miscalculation while performing addition due to negative lat/long value
  String positiveLat = pLatitude.toString();

  if (positiveLat.contains("-")) {
    pLatitude = positiveLat.contains("-")
        ? double.parse(positiveLat.replaceAll("-", ""))
        : pLatitude;
    maxLat = pLatitude + deltaLat;
    String maxLatString = "-$maxLat";
    maxLat = double.parse(maxLatString);
  } else {
    maxLat = pLatitude + deltaLat;
  }
  String positveLng = pLongitude.toString();
  if (positveLng.contains("-")) {
    pLongitude = double.parse(positveLng.replaceAll("-", ""));
    maxLong = pLongitude + deltaLong;
    String maxLongString = "-$maxLong";
    maxLong = double.parse(maxLongString);
  } else {
    maxLong = pLongitude + deltaLong;
  }

  latLngList.add(maxLat);
  latLngList.add(maxLong);
  return latLngList;
}

double convToDeg(value) {
  return value * 180 / Math.pi;
}

double convToRad(value) {
  return value * Math.pi / 180;
}
