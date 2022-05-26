import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:medical_assistant_002/screens/paramedic_screens/map/DirectionsRepositry.dart';
import 'package:medical_assistant_002/theme.dart';
import '../../../../models/directions_model.dart';

class LocationTracking extends StatefulWidget {
  const LocationTracking({Key? key}) : super(key: key);

  @override
  _LocationTrackingState createState() => _LocationTrackingState();
}

class _LocationTrackingState extends State<LocationTracking> {
  LatLng sourceLocation = LatLng(28.432864, 77.002563);
  LatLng destinationLatlng = LatLng(31.474185055286984, 34.398176999393876);

  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _marker = Set<Marker>();

  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;

  late StreamSubscription<LocationData> subscription;

  LocationData? currentLocation;
  late LocationData destinationLocation;
  late Location location;

  var distanceBetween=0.0;
  Directions? _info;
String address='';
  @override
  void initState() {
    super.initState();
    location = Location();
    polylinePoints = PolylinePoints();

    subscription = location.onLocationChanged.listen((clocation) {
      currentLocation = clocation;

      updatePinsOnMap();
    });

    setInitialLocation();
  }

  void setInitialLocation() async {
    await location.getLocation().then((value) {
      currentLocation = value;
      setState(() {});
    });

    destinationLocation = LocationData.fromMap({
      "latitude": destinationLatlng.latitude,
      "longitude": destinationLatlng.longitude,
    });
  }

  void showLocationPins() {
    var sourceposition = LatLng(
        currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0);

    var destinationPosition =
    LatLng(destinationLatlng.latitude, destinationLatlng.longitude);

    _marker.add(Marker(
      markerId: MarkerId('sourcePosition'),
      position: sourceposition,
    ));

    _marker.add(
      Marker(
        markerId: MarkerId('destinationPosition'),
        position: destinationPosition,
      ),
    );


  }

  void setPolyline(
      {required double startlatitude,
        required double startlongitude,
        required double endlatitude,
        required double endlongitude}) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyAdsviSFAfa-kQhpnoioUItpeuDYZEhJqY',
      // '',
      PointLatLng(startlatitude, startlongitude),
      PointLatLng(endlatitude, endlongitude),
    );
    print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx${result.status}');
    if (result.status == 'OK') {
      result.points.forEach((point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {
        _polylines.add(Polyline(
            polylineId: const PolylineId('polyline'),
            width: 5,
            color: blueClr,
            points: polylineCoordinates));
        distanceBetween=  Geolocator.distanceBetween(currentLocation?.latitude??00, currentLocation?.longitude??00, destinationLatlng.latitude, destinationLatlng.longitude)/1000;

      });
    }
  }

  void updatePinsOnMap() async {
    CameraPosition cameraPosition = CameraPosition(
      zoom: 20,
      tilt: 80,
      bearing: 30,
      target: LatLng(
          currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0),
    );

    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    var sourcePosition = LatLng(
        currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0);

    setState(() {
      _marker.removeWhere((marker) => marker.mapsId.value == 'sourcePosition');

      _marker.add(Marker(
        markerId: MarkerId('sourcePosition'),
        position: sourcePosition,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
      zoom: 20,
      tilt: 80,
      bearing: 30,
      target: currentLocation != null
          ? LatLng(currentLocation!.latitude ?? 0.0,
          currentLocation!.longitude ?? 0.0)
          : LatLng(0.0, 0.0),
    );

    return currentLocation == null
        ? Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    )
        : SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              myLocationButtonEnabled: true,
              compassEnabled: true,
              markers: _marker,
              polylines: _polylines,
              mapType: MapType.normal,
              initialCameraPosition: initialCameraPosition,
              onMapCreated: (GoogleMapController controller) async{
                _controller.complete(controller);
                showLocationPins();
                setPolyline(
                  startlatitude: currentLocation?.latitude??00,
                  startlongitude: currentLocation?.longitude??00,
                  endlatitude: destinationLatlng.latitude,
                  endlongitude: destinationLatlng.longitude,
                );
                final directions=await DirectionsRepository().getDirections(origin: LatLng(currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0), destination: LatLng(destinationLatlng.latitude, destinationLatlng.longitude));
                setState(() {
                  print('ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss$directions');
                  _info = directions;
                });


              },
            ),
            _info!=null?
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Align(
                alignment: Alignment.topCenter,
                child: Positioned(
                  top: 20.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: greenClr,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        )
                      ],
                    ),
                    child: Text(
                      '${_info!.totalDistance}, ${_info!.totalDuration}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ):SizedBox()
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}