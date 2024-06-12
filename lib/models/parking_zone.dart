
class ParkingZone {
  int? id;
  String? name;
  int? size;
  int? traffic;

  ParkingZone({this.id, this.name, this.size, this.traffic});
}



ParkingZone D9 = ParkingZone(name: "Nhà xe D9",traffic: 2,size: 130,);
ParkingZone D68 = ParkingZone(name: "Nhà xe D6-8",traffic: 1,size: 70,);
ParkingZone B1 = ParkingZone(name: "Nhà xe B1",traffic: 2,size: 50,);
ParkingZone C7 = ParkingZone(name: "Nhà xe C7",traffic: 3,size: 150,);
ParkingZone TC = ParkingZone(name: "Nhà xe TC",traffic: 1,size: 120,);
ParkingZone D35 = ParkingZone(name: "Nhà xe D3-5",traffic: 1,size: 145,);

List<ParkingZone> BKParkings = [D9,D68,D35,B1,C7,TC];
