import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/parking_zone.dart';

class ParkingSpaceComponent extends StatelessWidget {
  ParkingZone parking;
  Function()? onTap;

  ParkingSpaceComponent({super.key,required this.parking,this.onTap});

  @override
  Widget build(BuildContext context) {
    double percentage = parking.quantity! / parking.capacity!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 1,color: Colors.grey[300]!)
            ),
          color: (percentage<=0.5)? Colors.green[400] : (percentage<=0.8) ? Colors.yellow[400] : (percentage<=0.99)? Colors.red[400]! : Colors.grey,
        ),
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
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
                Text(parking.quantity!=null ? "${parking.quantity.toString()} slot" : "123 slot",style: TextStyle(fontSize: 16),),
                Text("${parking.frequency??1} xe/phút",style: TextStyle(fontSize: 16),)
              ],
            ),

          ],
        ),
      ),
    );
  }
}
