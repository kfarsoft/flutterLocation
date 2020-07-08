import 'package:RealTimeLocation/models/map_bottom_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const DESTCOORD = LatLng(-31.4224398, -64.2045706);

class MarkerNotifier with ChangeNotifier {
  Set<Marker> _markers = Set<Marker>();
  BitmapDescriptor _sourceIcon;
  BitmapDescriptor _destinationIcon;
  double _pinPosition = -100;
  LatLng _destCoord = DESTCOORD;
  //Polyline data------------------------------------------------------
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> _polylineCoordinates = [];
  PolylinePoints _polylinePoints = PolylinePoints();
  String _googleAPIKey = 'AIzaSyAA7N3lgEQsVvJtQyHlnQedZGI1CGOfikc';
  //Polyline data------------------------------------------------------
  MapInfo _pinSelected = MapInfo(
      pinPath: '',
      location: LatLng(0, 0),
      locationName: '',
      labelColor: Colors.grey);

  MapInfo _sourcePinInfo = MapInfo(
      locationName: "Start Location",
      location: LatLng(0, 0),
      pinPath: "assets/driving_pin.png",
      labelColor: Colors.blueAccent);

  MapInfo _destinationPinInfo = MapInfo(
      locationName: "End Location",
      location: DESTCOORD,
      pinPath: "assets/destination_pin.png",
      labelColor: Colors.purple);

  MarkerNotifier.init() {
    getMarkers();
  }

  Future setSourceAndDestinationIcons() async {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.0), 'assets/driving_pin.png')
        .then((onValue) {
      _sourceIcon = onValue;
      notifyListeners();
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.0),
            'assets/destination_pin.png')
        .then((onValue) {
      _destinationIcon = onValue;
      notifyListeners();
    });
  }

  Future setPolylines() async {
    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
        _googleAPIKey,
        PointLatLng(_sourcePinInfo.location.latitude,
            _sourcePinInfo.location.longitude),
        PointLatLng(_destCoord.latitude, _destCoord.longitude),
        travelMode: TravelMode.driving,
        wayPoints: [
          // PolylineWayPoint(
          //     location: "Valle Escondido el Balcon,, Córdoba, Argentina")
        ]);

    if (result.points.isNotEmpty) {
      _polylineCoordinates.clear();
      result.points.forEach((PointLatLng point) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      _polylines.add(Polyline(
          width: 2, // set the width of the polylines
          polylineId: PolylineId("poly"),
          color: Color.fromARGB(255, 40, 122, 198),
          points: _polylineCoordinates));
      notifyListeners();
    }
  }

  getMarkers() async {
    var sourcePosition = LatLng(0, 0);
    var destPosition = LatLng(_destCoord.latitude, _destCoord.longitude);

    await setSourceAndDestinationIcons();

    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: sourcePosition,
        onTap: () {
          _pinSelected = _sourcePinInfo;
          _pinPosition = 0;
          notifyListeners();
        },
        icon: _sourceIcon));

    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        onTap: () {
          _pinSelected = _destinationPinInfo;
          _pinPosition = 0;
          notifyListeners();
        },
        icon: _destinationIcon));
  }

//Pin info selected---------------------------------------
  MapInfo get getPinSelected => _pinSelected;

  set updatePinSelected(MapInfo pinSelected) {
    _pinSelected = pinSelected;
    notifyListeners();
  }

//marker info---------------------------------------
  Set<Marker> get getMapMarkers => _markers;

  set updateMarkers(Set<Marker> markers) {
    _markers = markers;
    notifyListeners();
  }

//Polyline info---------------------------------------
  Set<Polyline> get getPolylines => _polylines;

  set updatePolilynes(Set<Polyline> polilynes) {
    _polylines = polilynes;
    notifyListeners();
  }

//Destination coord---------------------------------------
  LatLng get getDestCoord => _destCoord;

  set updateDestCoord(LatLng destCoord) {
    _destCoord = destCoord;
    notifyListeners();
  }

//Pin position double---------------------------------------
  double get getPinPosition => _pinPosition;

  set updatePinPosition(double pinPos) {
    _pinPosition = pinPos;
    notifyListeners();
  }

//Source Pin info---------------------------------------
  MapInfo get getSourcePinInfo => _sourcePinInfo;

  set updateSourceInfo(MapInfo sourceInfo) {
    _sourcePinInfo = sourceInfo;
    notifyListeners();
  }

//Destination Pin info---------------------------------------
  MapInfo get getDestinationPinInfo => _destinationPinInfo;

  set updateDestinationInfo(MapInfo destInfo) {
    _destinationPinInfo = destInfo;
    notifyListeners();
  }

//Source icon---------------------------------------
  BitmapDescriptor get getSourceIcon => _sourceIcon;

  set updateSourceIcon(BitmapDescriptor sourceIcon) {
    _sourceIcon = sourceIcon;
    notifyListeners();
  }

//Destination icon---------------------------------------
  BitmapDescriptor get getDestinationIcon => _destinationIcon;

  set updateDestinationIcon(BitmapDescriptor destIcon) {
    _destinationIcon = destIcon;
    notifyListeners();
  }
}
