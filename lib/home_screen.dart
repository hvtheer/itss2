import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itss2nhomsonduc/components/home_screen_appbar.dart';
import 'package:itss2nhomsonduc/components/parking_space_component.dart';
import 'package:itss2nhomsonduc/models/parking_zone.dart';
import 'package:itss2nhomsonduc/network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_screen.g.dart';

const greenColor = Colors.green;
const yellowColor = Colors.yellow;
const redColor = Colors.red;
const grayColor = Colors.grey;

@riverpod
Future<List<ParkingZone>> getParkingZone(ref) async {
  final dio = ref.watch(dioProvider);
  Response response = await dio.get('parking-lots');
  if (response.statusCode == 200) {
    final result = response.data as List;
    return result
        .map((e) => ParkingZone(
            id: e['id'],
            name: e['name'],
            capacity: e['capacity'],
            quantity: e['quantity'],
            frequency: e['frequency']))
        .toList();
  } else {
    throw Exception();
  }
}

class ParkingZoneNotifier extends StateNotifier<AsyncValue<List<ParkingZone>>> {
  ParkingZoneNotifier(this.ref) : super(const AsyncValue.loading()) {
    _startTimer();
  }

  final Ref ref;
  late Timer _timer;

  Future<void> _fetchParkingZones() async {
    try {
      final parkingZones = await ref.read(getParkingZoneProvider.future);
      state = AsyncValue.data(parkingZones);
    } catch (e) {
      print(e);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchParkingZones();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

final parkingZoneProvider =
    StateNotifierProvider<ParkingZoneNotifier, AsyncValue<List<ParkingZone>>>(
        (ref) {
  return ParkingZoneNotifier(ref);
});

class HomeScreen extends ConsumerStatefulWidget {
  final String? name;
  const HomeScreen({super.key, this.name});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(parkingZoneProvider.notifier)._fetchParkingZones();
  }

  List<Widget> _buildListParkingZone(List<ParkingZone> listParkingZone) {
    return listParkingZone
        .map((parking) => ParkingSpaceComponent(
            parking: parking, onTap: () => _showParkingModal(parking)))
        .toList();
  }

  void _showParkingModal(ParkingZone parking) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Text("Điểm đến bạn chọn : ${parking.name ?? ""}",
                  style: const TextStyle(fontSize: 22)),
              if (parking.quantity! >= parking.capacity!)
                const Text("Điểm đến bạn chọn đã hết chỗ",
                    style: TextStyle(fontSize: 19, color: Colors.red)),
            ],
          ),
          content: SizedBox(
            height: 50,
            child: Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Còn", style: TextStyle(fontSize: 17)),
                    Text("Lưu lượng xe", style: TextStyle(fontSize: 17)),
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
                              : "${(parking.capacity! - parking.quantity!).toString()} chỗ")
                          : "12 chỗ",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Text(
                          "${parking.frequency ?? 1} xe/phút",
                          style: const TextStyle(fontSize: 16),
                        ),
                        if (parking.frequency != null &&
                            parking.frequency! >= 15)
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
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close', style: TextStyle(fontSize: 19)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final parkinglots = ref.watch(parkingZoneProvider);

    return Scaffold(
      appBar: HomeScreenAppbar(),
      body: parkinglots.when(
        data: (listParkzone) {
          return Container(
            child: SingleChildScrollView(
              child: Column(children: [
                Column(children: _buildListParkingZone(listParkzone)),
                const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ColorIdentifier(
                          color: greenColor, status: "Còn nhiều chỗ"),
                      ColorIdentifier(color: yellowColor, status: "Còn ít chỗ"),
                    ]),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ColorIdentifier(color: redColor, status: "Gần đầy"),
                    ColorIdentifier(color: grayColor, status: "Đã đầy"),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [IconIdentifier()],
                )
              ]),
            ),
          );
        },
        error: (error, _) {
          print(error.toString());
          return Container();
        },
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class ColorIdentifier extends StatelessWidget {
  final String? status;
  final Color? color;
  const ColorIdentifier({this.status, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              color: color?.withOpacity(0.8),
            ),
            const SizedBox(width: 20.0),
            Expanded(child: Text(status!))
          ],
        ),
      ),
    );
  }
}

class IconIdentifier extends StatelessWidget {
  const IconIdentifier({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 150.0,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(
              height: 30,
              width: 30,
              child: Icon(
                Icons.warning,
                color: Colors.orange,
              ),
            ),
            SizedBox(width: 20.0),
            Expanded(child: Text("Đang tắc"))
          ],
        ),
      ),
    );
  }
}
