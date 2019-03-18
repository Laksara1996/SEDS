import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.green
      ),
      home: MyHomePage(title: 'Spotter'),
    );

  }
}

class MyHomePage extends StatefulWidget{
  MyHomePage ({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
String value = "";
class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  int _currentIndex = 0;

  List <Widget> _tabsList = [
    Stack(
      children: <Widget>[
        Container(
          child: MapSample(),
        ),
        Container(
            child: TextFormField(
              decoration: new InputDecoration(
                labelText: "Enter Location",
                fillColor: Colors.red,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                ),
              ),
            ),

        )

      ],
    ),
    Container(
      child: MapSample()
    ),
    Container(
      child: MapSample()
    )
  ];
  TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync:this,length: _tabsList.length);
  }

  @override
  void dispose(){
    _tabController.dispose();
        super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: TabBarView(
        controller: _tabController,
        children: _tabsList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (currentIndex){
            _currentIndex = currentIndex;
            _tabController.animateTo(_currentIndex);
        },

        items: [
          BottomNavigationBarItem(
              title: Text("Fish"),
              icon: Icon(Icons.control_point)
          ),
          BottomNavigationBarItem(
              title: Text("Climate"),
              icon: Icon(Icons.cloud_queue)
          )
        ],
      ),
    );
  }

}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 5.4746,
  );

  static final CameraPosition _kLake = CameraPosition(

      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('My Location'),
        icon: Icon(Icons.location_searching),
      ),
    );
  }

  Future<void> _goToTheLake() async {


    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}

