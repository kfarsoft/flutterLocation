import 'package:RealTimeLocation/map_bottom_widget.dart';
import 'package:RealTimeLocation/models/user_location.dart';
import 'package:RealTimeLocation/provider/marker_notifier.dart';
import 'package:RealTimeLocation/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  final UserLocation userLocation;

  const MapPage({Key key, this.userLocation}) : super(key: key);
  @override
  State<StatefulWidget> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  //Google map data------------------------------------------------------
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> marks;
  CameraPosition initialCamera;
  //Google map data------------------------------------------------------
  TextEditingController _addressController = TextEditingController();
  @override
  void initState() {
    super.initState();
    initialCamera = createCameraPosition(widget.userLocation);
  }

  @override
  Widget build(BuildContext context) {
    var marker = Provider.of<MarkerNotifier>(context);
    return Consumer<UserLocation>(builder: (context, userLocation, _) {
      updatePinOnMap(userLocation);
      return Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              myLocationEnabled: true,
              compassEnabled: true,
              tiltGesturesEnabled: false,
              markers: marker.getMapMarkers,
              polylines: marker.getPolylines,
              mapType: MapType.normal,
              initialCameraPosition: initialCamera,
              onMapCreated: onMapCreated,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 70),
              child: MapBottomWidget(
                userPosition: marker.getPinPosition,
                pinSelected: marker.getPinSelected,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () => showPopup(marker), label: Text("Input address")),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    });
  }

  showPopup(MarkerNotifier marker) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Input Address'),
            content: TextField(
              controller: _addressController,
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok'),
                onPressed: () {
                  _setDestinationLocation(marker);
                },
              ),
              FlatButton(
                child: new Text('Back'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _setDestinationLocation(MarkerNotifier marker) {
    Geolocator().placemarkFromAddress(_addressController.text).then((result) {
      var lat = result[0].position.latitude;
      var lon = result[0].position.longitude;

      //Update markers on map
      var pinPosition = LatLng(lat, lon);
      marker.getSourcePinInfo.location = pinPosition;
      _updateMarkerData(marker, pinPosition, 'destPin');
      marker.updateDestCoord = pinPosition;
      marker.setPolylines();
      _addressController.clear();
      Navigator.pop(context);
    }).catchError((error) {
      print(error);
      show('Error!', 5);
    });
  }

  CameraPosition createCameraPosition(UserLocation location) {
    var target = LatLng(location.latitude, location.longitude);
    return CameraPosition(zoom: 15, target: target);
  }

  show(String msg, time) {
    Navigator.pop(context);
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: time,
        backgroundColor: Colors.grey);
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(Utils.mapStyles);
    _controller.complete(controller);
  }

  void updatePinOnMap(UserLocation userLocation) async {
    var marker = Provider.of<MarkerNotifier>(context);
    marker.updatePinPosition = 0.0;
    LatLng oldLoc = marker.getSourcePinInfo.location;
    LatLng newLoc = LatLng(userLocation.latitude, userLocation.longitude);

    ///TODO: There are many updates of this API
    if (oldLoc != newLoc) {
      marker.setPolylines();
      print(
          '-----------------------Polylines was updated-------------------------');
    }
    marks = marker.getMapMarkers;
    CameraPosition cPos = CameraPosition(
      zoom: 15,
      // tilt: CAMERA_TILT,
      // bearing: CAMERA_BEARING,
      target: LatLng(userLocation.latitude, userLocation.longitude),
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPos));
    //Update markers on map
    var pinPosition = LatLng(userLocation.latitude, userLocation.longitude);
    marker.getSourcePinInfo.location = pinPosition;
    _updateMarkerData(marker, pinPosition, 'sourcePin');
  }

  _updateMarkerData(MarkerNotifier marker, pinPosition, pin) {
    marks.removeWhere((m) => m.markerId.value == pin);
    marks.add(Marker(
        markerId: MarkerId(pin),
        onTap: () {
          marker.updatePinSelected = pin == "sourcePin"
              ? marker.getSourcePinInfo
              : marker.getDestinationPinInfo;
          marker.updatePinPosition = 0;
        },
        position: pinPosition, // updated position
        icon: pin == "sourcePin"
            ? marker.getSourceIcon
            : marker.getDestinationIcon));
  }
}
