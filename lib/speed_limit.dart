import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SwipeBounceApp extends StatefulWidget {
  @override
  _SwipeBounceAppState createState() => _SwipeBounceAppState();
}

class _SwipeBounceAppState extends State<SwipeBounceApp> {
  
  final Dio _dio = Dio();
  final double speedLimit = 3;
  double _containerX = 0;
  double _containerY = 0;
  double _dx = 3;
  double _dy = 3;
  bool stopBouncing = false;
  String imageUrl='https://picsum.photos/200/200';
  
  @override
  void initState() {
    super.initState();
    loadRandomImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fidibo"),
        actions: <Widget>[
          IconButton(
            icon: stopBouncing ? const Icon(Icons.play_arrow): const Icon(Icons.pause),
            tooltip: 'pause',
            onPressed: () {
              stop();
            },
          ), //IconButton
          IconButton(
            icon: const Icon(Icons.clear),
            tooltip: 'reset',
            onPressed: () {
              reset();
            },
          ), //IconButton
        ], //<Widg
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _dx = details.delta.dx.clamp(-speedLimit, speedLimit);
            _dy = details.delta.dy.clamp(-speedLimit, speedLimit);
          });
        },
        onPanEnd: (details) {
          animateMovement();
        },
        child: Stack(
          children: <Widget>[
            Positioned(
              left: _containerX,
              top: _containerY,
              child: GestureDetector(
                onTap: () {
                  loadRandomImage();
                },
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(imageUrl), fit: BoxFit.cover),
                        color: Colors.blue,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 3,
                            blurStyle: BlurStyle.outer,
                            color: Colors.grey,
                            offset:Offset(1,1),
                            spreadRadius: 2
                          )
                        ]
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loadRandomImage() async {
    try{
      // make a GET request to load a random image from the internet
    var response = await _dio.get("https://picsum.photos/200/200?random");
    setState(() {
      imageUrl = response.realUri.toString();
    });
    }catch(e){
      throw Exception();
    }
  }

  void stop(){
    setState(() {
      stopBouncing = !stopBouncing;
    });
  }
  
  void reset(){
    if(!stopBouncing){
      stop();
    }
     setState(() {
      _containerX = 0;
      _containerY = 0;
      _dx = 3;
      _dy = 3;
     });
  }
  
  void animateMovement() {
    if(!stopBouncing){
    _containerX += _dx;
    _containerY += _dy;

    if (_containerX > MediaQuery.of(context).size.width - 200) {
      _dx = -_dx.clamp(-speedLimit, speedLimit);
      _containerX = MediaQuery.of(context).size.width - 200;
    } else if (_containerX < 0) {
      _dx = -_dx.clamp(-speedLimit, speedLimit);
      _containerX = 0;
    }
    if (_containerY > MediaQuery.of(context).size.height - 280) {
      _dy = -_dy.clamp(-speedLimit, speedLimit);
      _containerY = MediaQuery.of(context).size.height - 280;
    } else if (_containerY < 0) {
      _dy = -_dy.clamp(-speedLimit, speedLimit);
      _containerY = 0;
    }

    
    Future.delayed(const Duration(milliseconds: 16), () {
      setState(() {});
      animateMovement();
    });
    }
  }
}