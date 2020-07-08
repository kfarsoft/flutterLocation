class UserLocation {
  final double latitude;
  final double longitude;
  UserLocation({this.latitude, this.longitude});
  @override
  String toString() {
    return 'lat:$latitude:long:$longitude';
  }
}
