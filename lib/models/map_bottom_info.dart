import 'dart:ui';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapInfo {
  String pinPath;
  LatLng location;
  String locationName;
  Color labelColor;

  MapInfo({this.pinPath, this.location, this.locationName, this.labelColor});
}
