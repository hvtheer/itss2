import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/parking_zone.dart';

class ParkingSpaceComponent extends StatelessWidget {
  ParkingZone parking;
  Function()? onTap;

  ParkingSpaceComponent({super.key, required this.parking, this.onTap});

  @override
  Widget build(BuildContext context) {
    double percentage = parking.quantity! / parking.capacity!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Colors.grey[300]!)),
          color: (percentage <= 0.5)
              ? Colors.green[400]
              : (percentage <= 0.8)
                  ? Colors.yellow[400]
                  : (percentage <= 0.99)
                      ? Colors.red[400]!
                      : Colors.grey,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  parking.name ?? "Nhà xe D3-5",
                  style: const TextStyle(fontSize: 16),
                ),
                const Text(
                  "Lưu lượng xe",
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.2),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  parking.quantity != null
                      ? (parking.quantity! >= parking.capacity!
                          ? "Hết chỗ"
                          : "còn ${(parking.capacity! - parking.quantity!).toString()} chỗ")
                      : "12 chỗ",
                  style: const TextStyle(fontSize: 16),
                ),
                Row(
                  children: [
                    Text(
                      "${parking.frequency ?? 1} xe/phút",
                      style: const TextStyle(fontSize: 16),
                    ),
                    if (parking.frequency != null && parking.frequency! >= 15)
                      const Icon(
                        Icons.warning,
                        color: Colors.orange,
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
