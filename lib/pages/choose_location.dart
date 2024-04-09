import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:latlong2/latlong.dart';

class Choose_Location extends StatefulWidget {
  const Choose_Location({super.key});

  @override
  State<Choose_Location> createState() => _Choose_LocationState();
}

class _Choose_LocationState extends State<Choose_Location> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Choose Location'),
        ),
        body: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    color: Colors.purple[100],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: (){
                          print('Block 1 pressed');
                          LatLng result = LatLng(1.333445999762877, 103.7771);
                          Navigator.pop(context, result);
                        },
                        child: Text(
                          'Block 1',
                          style: TextStyle(
                              fontSize: 20.0
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    color: Colors.purple[100],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: (){
                          print('Block 4 pressed');
                          LatLng result = LatLng(1.33381, 103.776150);
                          Navigator.pop(context, result);
                        },
                        child: Text(
                          'Block 4',
                          style: TextStyle(
                              fontSize: 20.0
                          ),),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    color: Colors.purple[100],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: (){
                          print('Block 53 pressed');
                          LatLng result = LatLng(1.33153, 103.77485);
                          Navigator.pop(context, result);
                        },
                        child: Text(
                          'Block 53',
                          style: TextStyle(
                              fontSize: 20.0
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    color: Colors.purple[100],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: (){
                          print('Block 51 pressed');
                          LatLng result = LatLng(1.33211, 103.77428);
                          Navigator.pop(context, result);
                        },
                        child: Text('Block 51',
                          style: TextStyle(
                              fontSize: 20.0
                          ),),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    color: Colors.purple[100],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: (){
                          print('Block 82 pressed',);
                          LatLng result = LatLng(1.3302722322008604, 103.77502276471648);
                          Navigator.pop(context, result);
                        },
                        child: Text('Block 82',
                          style: TextStyle(
                              fontSize: 20.0
                          ),),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    color: Colors.purple[100],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: (){
                          print('Block 18 pressed');
                          LatLng result = LatLng(1.3352733558321161, 103.77600737004525);
                          Navigator.pop(context, result);
                        },
                        child: Text('Block 18',
                          style: TextStyle(
                              fontSize: 20.0
                          ),),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    color: Colors.purple[100],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: (){
                          print('Block 8 pressed',);
                          LatLng result = LatLng(1.3346891692765857, 103.77644014379062);
                          Navigator.pop(context, result);
                        },
                        child: Text('Block 8',
                          style: TextStyle(
                              fontSize: 20.0
                          ),),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    color: Colors.purple[100],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: (){
                          print('Block 18 pressed');
                          LatLng result = LatLng(1.3352733558321161, 103.77600737004525);
                          Navigator.pop(context, result);
                        },
                        child: Text('Block 18',
                          style: TextStyle(
                              fontSize: 20.0
                          ),),
                      ),
                    ),
                  ),
                ),
              ],
            ),


          ],
        )


    );
  }
}

