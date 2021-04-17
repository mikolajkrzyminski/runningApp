
import 'package:flutter/material.dart';
import 'package:szewa/managers/run_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

class TrainingPage extends StatefulWidget {
  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> implements RunObserver {

  RunManager _runManager;
  MapController _mapController;
  List<LatLng> _runPositions;

  @override
  void initState() {
    super.initState();
    _runManager = RunManager(this);
    _runPositions = [];
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Flexible(
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      center: LatLng(0, 0),
                      zoom: 16,
                    ),
                    layers: [
                      TileLayerOptions(
                          urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: ['a', 'b', 'c']),
                      PolylineLayerOptions(
                        polylines: [
                          Polyline(
                              points: _runPositions,
                              strokeWidth: 4.0,
                              color: Colors.purple),
                        ],
                      ),

                    ],
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueGrey,
                ),
                child: _runManager.getIsRunning() ?
                Text("STOP", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),) :
                Text("START", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),),
                onPressed: () {
                  setState(() {
                    if(!_runManager.getIsRunning()) _runPositions.clear();
                    _runManager.changeState();
                  });
                },
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 2,
                      offset: Offset(0, 0),
                    ),
                  ]
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onRunChanged(Position position) {
    if(null != position) {
      setState(() {
        LatLng lastItem = LatLng(position.latitude, position.longitude);
        _runPositions.add(lastItem);
        _mapController.move(lastItem, 16);
      });
    }
  }
}
