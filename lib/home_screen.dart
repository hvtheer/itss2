import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:itss2nhomsonduc/components/home_screen_appbar.dart';
import 'package:itss2nhomsonduc/components/parking_space_component.dart';
import 'package:itss2nhomsonduc/models/parking_zone.dart';

class HomeScreen extends StatefulWidget {
  final String? name;
  HomeScreen({super.key, this.name});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _timer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        BKParkings.forEach((parking) {
          parking.size = parking.size! + _random.nextInt(11) - 5;
          if(parking.size! > 180)parking.size = 185;
        });
      });
    });
  }

  List<Widget> _buildListParkingZone() {
    return BKParkings.map((parking) => ParkingSpaceComponent(parkingZone: parking,onTap:()=>_showParkingModal(parking),)).toList();
  }

  void _showParkingModal(ParkingZone parking) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Text("Điểm đến bạn chọn : ${parking.name??""}",style: TextStyle(fontSize: 22),),
              if(parking.size! > 180)Text("Điểm đến bạn chọn đã hết chỗ",style: TextStyle(fontSize: 19,color: Colors.red),)
            ],
          ),
          content: Container(
            height: 50,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(parking.name??"Nhà xe D3-5",style: TextStyle(fontSize: 16),),
                    Text("Lưu lượng xe",style: TextStyle(fontSize: 16),)
                  ],
                ),
                SizedBox(width: MediaQuery.of(context).size.width*0.2),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(parking.size!=null ? "${parking.size.toString()} slot" : "123 slot",style: TextStyle(fontSize: 16),),
                    Text("${parking.traffic??1} xe/phút",style: TextStyle(fontSize: 16),)
                  ],
                ),

              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close',style: TextStyle(fontSize: 19),),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeScreenAppbar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: _buildListParkingZone(),
          ),
        ),
      ),
    );
  }
}
