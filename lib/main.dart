import 'package:RealTimeLocation/google_map_second_page.dart';
import 'package:RealTimeLocation/models/user_location.dart';
import 'package:RealTimeLocation/provider/location_services.dart';
import 'package:RealTimeLocation/provider/marker_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<UserLocation>(
          create: (context) => LocationService().locationStream,
        ),
        ChangeNotifierProvider(
          create: (_) => MarkerNotifier.init(),
        )
      ],
      child: Consumer<UserLocation>(builder: (context, userLocation, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Location services',
          theme: ThemeData(),
          home: userLocation != null
              ? MapPage(
                  userLocation: userLocation,
                )
              : ErrorPage(),
        );
      }),
    );
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            'Please, turn on location services',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
