
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:mini_project_five/pages/loading.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;

import 'package:sliding_up_panel/sliding_up_panel.dart';


class Map_Page extends StatefulWidget {
  const Map_Page({super.key});

  @override
  State<Map_Page> createState() => _Map_PageState();
}

class _Map_PageState extends State<Map_Page> {

  LatLng? _currentP = null;
  List<LatLng> routepoints = [];
  LatLng? _destination;
  Timer? _timer;
  double _heading = 0.0;
double arcStartAngle = 0.0;
double arcSweepAngle = 360.0;

final ScrollController controller = ScrollController();



  @override
  void initState() {
    super.initState();
    getLocation();
    _timer = Timer.periodic(Duration(seconds: 2), (Timer t) => getLocation());
    _initCompass();
    _fetchRoutePeriodically();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _currentP == null ? Loading()
        :Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(_currentP!.latitude, _currentP!.longitude),
                initialZoom: 18,
                initialRotation: _heading,
                interactionOptions:
                const InteractionOptions(flags:  ~InteractiveFlag.doubleTapZoom),
              ),
              nonRotatedChildren: [
                SimpleAttributionWidget(
                    source: Text('OpenStreetMap contributors')
                )
              ]
              , children:[
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              ),
              PolylineLayer(
                  polylineCulling: false,
                  polylines: [
                    Polyline(points: routepoints, color: Colors.blue, strokeWidth: 9)
                  ]),
              MarkerLayer(markers: [
                Marker(
                  point: LatLng(_currentP!.latitude, _currentP!.longitude),
                  child: GestureDetector(
                    onTap: (){
                      //Do things
                    },
                    child: Icon(
                      Icons.location_history,
                      size: 40,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                if (_destination != null)
                  Marker(
                      point: LatLng(_destination!.latitude, _destination!.longitude),
                      child: GestureDetector(
                        onTap: (){
                          //Do things
                        },
                        child: Icon(
                          Icons.location_pin,
                          size: 40,
                          color: Colors.redAccent,
                        ),
                      )
                  ),

              ]),
              Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 0.0 , 5.0, 100.0),
                child: CircularMenu(
                  alignment: Alignment.bottomRight,
                  radius: 80.0,
                  toggleButtonColor: Colors.cyan,
                  curve: Curves.easeInOut,
                  items:[
                    CircularMenuItem(
                      color: Colors.yellow[300],
                      iconSize: 30.0,
                      margin: 10.0,
                      padding: 10.0,
                      onTap: () async {
                        final result = await Navigator.pushNamed(
                            context, '/choose_location');

                        if (result != null && result is LatLng) {
                          setState(() {
                            _destination = result;
                            print(result);
                          });
                          fetchRoute(_currentP!, _destination!);
                        };
                      },
                      icon: Icons.directions,
                    ),
                    CircularMenuItem(
                      iconSize: 30.0,
                      margin: 10.0,
                      padding: 10.0,
                      color: Colors.green[300],
                      onTap: (){
                        Navigator.pushNamed(
                            context, '/information');
                      },
                      icon: Icons.info_rounded,
                    ),
                    CircularMenuItem(
                      color: Colors.pink[300],
                      iconSize: 30.0,
                      margin: 10.0,
                      padding: 10.0,
                      onTap: (){
                        Navigator.pushNamed(
                            context, '/settings');
                      },
                      icon: Icons.settings,
                    ),
                  ],
                ),
              ),
              _buildCompass(),
              SlidingUpPanel(
                panelBuilder: (controller){
                  return SingleChildScrollView(
                      controller: controller,
                      child: Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 15.0),
                                Center(
                                    child: Text('NP Navigation',
                                      style: TextStyle(
                                          fontSize: 40.0,
                                          fontFamily: 'PlayFair'
                                      ),)),
                                SizedBox(height: 30.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow[300] ?? Colors.yellow)),
                                      onPressed:  () async {
                                        final result = await Navigator.pushNamed(
                                            context, '/choose_location');

                                        if (result != null && result is LatLng) {
                                          setState(() {
                                            _destination = result;
                                            print(result);
                                          });
                                          fetchRoute(_currentP!, _destination!);
                                        };
                                      },
                                      child: Icon(Icons.directions,
                                        color: Colors.white,),
                                    ),
                                    SizedBox(width: 15.0),
                                    ElevatedButton(
                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green[300] ?? Colors.green)),
                                      onPressed: (){
                                        Navigator.pushNamed(
                                            context, '/information');
                                      },
                                      child: Icon(Icons.info_rounded,
                                        color: Colors.white,),
                                    ),
                                    SizedBox(width: 15.0),
                                    ElevatedButton(
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.pink[300] ?? Colors.pink)),
                                        onPressed: (){
                                          Navigator.pushNamed(
                                              context, '/settings');
                                        },
                                        child: Icon(Icons.settings,
                                          color: Colors.white,)),
                                    SizedBox(width: 15.0),
                                    ElevatedButton(
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blue[300] ?? Colors.blue)),
                                        onPressed: (){},
                                        child: Icon(Icons.more_horiz,
                                            color: Colors.white))
                                  ],
                                ),
                                SizedBox(height: 30.0),
                                Text('Images',
                                  style: TextStyle(
                                      fontSize: 25
                                  ),),
                                SizedBox(height: 30.0),
                                Row(
                                  children: [
                                    Expanded(child: Image.asset('images/campus.jpg')),
                                    SizedBox(width: 10.0),
                                    Expanded(child: Image.asset('images/Ngee-Ann-5.jpg')),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                Text('About Us',
                                style: TextStyle(
                                  fontSize: 25
                                ),),
                                SizedBox(height: 10.0,),
                                Text("Ngee Ann Polytechnic(NP) offers 36 full-time diploma courses and five common entry programmes through nine academic schools and has a full-time student population of more than 13,000. Our alumni community of over 17,000 is ever growing, with many making a difference across a broad spectrum of industries both locally and overseas. We also support Continuing Education and Training (CET) through NP's CET Academy, which offers a wide range of part-time programmes and short courses. We work closely with esteemed industry partners to curate programmes focusing on emerging skills, develop talent pipeline for the industries, and help adult learners stay agile in today's ever-evolving global economy."),
                                SizedBox(height: 30.0),
                              ],
                            ),
                          )
                      )
                  );
                } ,
              //   panel: Center(
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         SizedBox(height:15.0),
              //         Center(
              //             child: Text('NP Navigation',
              //             style: TextStyle(
              //               fontSize: 40.0,
              //               fontFamily: 'PlayFair'
              //               ,
              //             ),)),
              //         SizedBox(height: 30.0),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //             ElevatedButton(
              //               style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow[300] ?? Colors.yellow)),
              //                 onPressed:  () async {
              //                   final result = await Navigator.pushNamed(
              //                       context, '/choose_location');
              //
              //                   if (result != null && result is LatLng) {
              //                     setState(() {
              //                       _destination = result;
              //                       print(result);
              //                     });
              //                     fetchRoute(_currentP!, _destination!);
              //                   };
              //                 },
              //                 child: Icon(Icons.directions,
              //                 color: Colors.white,),
              //                 ),
              //             SizedBox(width: 30.0),
              //             ElevatedButton(
              //               style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green[300] ?? Colors.green)),
              //                 onPressed: (){
              //                   Navigator.pushNamed(
              //                       context, '/information');
              //                 },
              //                 child: Icon(Icons.info_rounded,
              //                 color: Colors.white,),
              //             ),
              //                 SizedBox(width: 30.0),
              //             ElevatedButton(
              //               style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.pink[300] ?? Colors.pink)),
              //                 onPressed: (){
              //                   Navigator.pushNamed(
              //                       context, '/settings');
              //                 },
              //                 child: Icon(Icons.settings,
              //                 color: Colors.white,)),
              //                 SizedBox(width: 30.0),
              //                 ElevatedButton(
              //                     style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blue[300] ?? Colors.blue)),
              //                     onPressed: (){},
              //                     child: Icon(Icons.more_horiz,
              //                     color: Colors.white))
              //           ],
              //         ),
              //         SizedBox(height: 30.0),
              //         Row(
              //           children: [
              //             SizedBox(width: 10.0),
              //             Text('Images',
              //             style: TextStyle(
              //               fontSize: 25
              //             ),),
              //           ],
              //         ),
              //         SizedBox(height: 30.0),
              //         Row(
              //           children: [
              //             SizedBox(width: 10.0),
              //             Expanded(child: Image.asset('images/campus.jpg')),
              //             SizedBox(width: 10.0),
              //             Expanded(child: Image.asset('images/Ngee-Ann-5.jpg')),
              //           ],
              //         ),
              //         Text('Testing'),
              //         Text('Testing'),
              //         Text('Testing'),
              //         Text('Testing'),
              //         Text('Testing'),
              //         Text('Testing'),
              //         Text('Testing'),
              //         Text('Testing'),
              //       ],
              //     )
              //   ),
              //
              // ),
              )],
            ),
          ],
        ),



    );
  }

  void getLocation() async {

    //request permission to get user's location
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    print('Location collected');

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentP = LatLng(position.latitude, position.longitude);
    });
  }

  void fetchRoute(LatLng start, LatLng destination) async {
    var url = Uri.parse('http://router.project-osrm.org/route/v1/foot/${start.longitude},${start.latitude};${destination.longitude},${destination.latitude}?overview=simplified&steps=true');
    var response = await http.get(url);

    //check if successful response
    if (response.statusCode == 200) {
      setState(() {
        routepoints.clear(); //clear previous route
        routepoints.add(start);
        var data = jsonDecode(response.body);

        if (data['routes'] != null &&
            data['routes'].isNotEmpty &&
            data['routes'][0]['geometry'] != null) {
          // Extract the encoded polyline
          String encodedPolyline = data['routes'][0]['geometry'];

          // Decode the polyline to create a list of LatLng points
          List<LatLng> decodedCoordinates = PolylinePoints()
              .decodePolyline(encodedPolyline)
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();

          // Update the routepoints with the new coordinates
          routepoints.addAll(decodedCoordinates);
      }});
    } else {
      print('Failed to fetch route');
      print(url);
    }
  }

  void _initCompass()
  {
    FlutterCompass.events?.listen((CompassEvent event) {
      setState(() {
        _heading = event.heading ?? 0.0;
      }
      );
    });
  }

  void _fetchRoutePeriodically() {
    _timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      if (_currentP != null && _destination != null) {
        fetchRoute(_currentP!, _destination!);
      }
    });
  }

  Widget _buildCompass() {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error reading heading: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // Check if the data is null or heading is null
        if (snapshot.data == null || snapshot.data!.heading == null) {
          return Center(
            child: Text("Device does not have sensors or sensor data is null!"),
          );
        }

        double direction = snapshot.data!.heading!;

        // Instead of displaying an image, you can display the direction as text


        return MarkerLayer(
          markers: [
            Marker(
                point: _currentP!,
                child: CustomPaint(
                  size: Size(200, 200),
                  painter: CompassPainter(
                    direction: _heading,
                    arcStartAngle: 0, // Adjust as needed
                    arcSweepAngle: 360,
                  )
            ),
            )],
        );
      },
    );
  }

}


  class CompassPainter extends CustomPainter {
  final double direction;
  final double arcStartAngle;
  final double arcSweepAngle;

  CompassPainter({
  required this.direction,
  required this.arcStartAngle,
  required this.arcSweepAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
  final centerX = size.width / 2;
  final centerY = size.height / 2;
  final radius = size.width / 2;

  // Draw the blue arc indicating the direction
  Paint paint = Paint()
  ..color = Colors.blue.withOpacity(0.3)
  ..strokeWidth = 20
  ..style = PaintingStyle.stroke
  ..strokeCap = StrokeCap.round;

  canvas.drawArc(
  Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
  _toRadians(arcStartAngle),
  _toRadians(arcSweepAngle),
  false,
  paint,
  );

  // Draw the arrow indicating the exact direction
  Paint arrowPaint = Paint()
  ..color = Colors.blue
  ..strokeWidth = 2
  ..style = PaintingStyle.fill;

  double arrowLength = radius * 1.5;
  double arrowAngle = _toRadians(direction);
  Offset arrowBase = Offset(
  centerX + arrowLength * math.cos(arrowAngle),
  centerY + arrowLength * math.sin(arrowAngle),
  );

  double arrowTipLength = radius * 0.1;
  double arrowTipAngle = _toRadians(direction - 180);
  Offset arrowTip = Offset(
  centerX + arrowTipLength * math.cos(arrowTipAngle),
  centerY + arrowTipLength * math.sin(arrowTipAngle),
  );

  double arrowWidth = 10;
  canvas.drawLine(arrowBase, arrowTip, arrowPaint);
  canvas.drawCircle(arrowTip, arrowWidth / 2, arrowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
  return true;
  }

  double _toRadians(double degrees) {
  return degrees * math.pi / 180;
  }
  }





