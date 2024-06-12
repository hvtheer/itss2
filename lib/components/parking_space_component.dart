import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/parking_zone.dart';

class ParkingSpaceComponent extends StatelessWidget {
  ParkingZone parkingZone;
  Function()? onTap;

  ParkingSpaceComponent({super.key,required this.parkingZone,this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 1,color: Colors.grey[300]!)
            )
        ),
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(parkingZone.name??"Nhà xe D3-5"),
                Text("Lưu lượng xe")
              ],
            ),
            SizedBox(width: MediaQuery.of(context).size.width*0.2),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(parkingZone.size!=null ? "${parkingZone.size.toString()} slot" : "123 slot"),
                Text("${parkingZone.traffic??1} xe/phút")
              ],
            ),

          ],
        ),
      ),
    );
  }
}
