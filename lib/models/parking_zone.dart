
class ParkingZone {
  int? id;
  String? name;
  int? quantity;
  int? capacity;
  int? frequency;

  ParkingZone({this.id, this.name, this.quantity, this.frequency,this.capacity});
}



ParkingZone D9 = ParkingZone(name: "Nhà xe D9",frequency: 2,quantity: 130,);
ParkingZone D68 = ParkingZone(name: "Nhà xe D6-8",frequency: 1,quantity: 70,);
ParkingZone B1 = ParkingZone(name: "Nhà xe B1",frequency: 2,quantity: 50,);
ParkingZone C7 = ParkingZone(name: "Nhà xe C7",frequency: 3,quantity: 150,);
ParkingZone TC = ParkingZone(name: "Nhà xe TC",frequency: 1,quantity: 120,);
ParkingZone D35 = ParkingZone(name: "Nhà xe D3-5",frequency: 1,quantity: 145,);

List<ParkingZone> BKParkings = [D9,D68,D35,B1,C7,TC];
