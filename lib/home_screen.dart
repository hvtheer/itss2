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
  ParkingZoneNotifier(this.ref) : super(AsyncValue.loading()) {
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
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
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
  HomeScreen({super.key, this.name});

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
          content: Container(
            height: 50,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(parking.name ?? "Nhà xe D3-5",
                        style: const TextStyle(fontSize: 17)),
                    const Text("Lưu lượng xe", style: TextStyle(fontSize: 17)),
                  ],
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.2),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        parking.quantity != null
                            ? "${parking.quantity.toString()} slot"
                            : "123 slot",
                        style: const TextStyle(fontSize: 17)),
                    Text("${parking.frequency ?? 1} xe/phút",
                        style: const TextStyle(fontSize: 17)),
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
              child: Text('Close', style: TextStyle(fontSize: 19)),
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
              child: Column(
                children: _buildListParkingZone(listParkzone),
              ),
            ),
          );
        },
        error: (error, _) {
          print(error.toString());
          return Container();
        },
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
