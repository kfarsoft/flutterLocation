import 'package:RealTimeLocation/models/map_bottom_info.dart';
import 'package:RealTimeLocation/models/user_location.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MapBottomWidget extends StatefulWidget {
  final double userPosition;
  final MapInfo pinSelected;
  // UserLocation userLocation;

  MapBottomWidget({this.userPosition, this.pinSelected});

  @override
  State<StatefulWidget> createState() => MapBottomWidgetState();
}

class MapBottomWidgetState extends State<MapBottomWidget> {
  @override
  Widget build(BuildContext context) {
    var userLocation = Provider.of<UserLocation>(context);
    return AnimatedPositioned(
      bottom: widget.userPosition,
      right: 0,
      left: 0,
      duration: Duration(milliseconds: 200),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.all(20),
          height: 70,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(50)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    blurRadius: 20,
                    offset: Offset.zero,
                    color: Colors.grey.withOpacity(0.5))
              ]),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: widget.pinSelected.pinPath != ""
                      ? getBottomInfo(
                          widget.pinSelected.location.latitude.toString(),
                          widget.pinSelected.location.longitude.toString())
                      : getBottomInfo(userLocation.latitude.toString(),
                          userLocation.longitude.toString()),
                ),
              ),
              widget.pinSelected.pinPath != ""
                  ? Padding(
                      padding: EdgeInsets.all(15),
                      child: Image.asset(widget.pinSelected.pinPath,
                          width: 50, height: 50),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getBottomInfo(String latitude, String longitude) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(widget.pinSelected.locationName,
            style: TextStyle(color: widget.pinSelected.labelColor)),
        Text('Latitude: $latitude',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        Text('Longitude: $longitude',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
