import 'package:firebase_database/firebase_database.dart';

class Pump {
  final String? key;
  String? humidity;
  bool? pump;
  String? moisture;
  String? temperature;

  Pump({
    this.key,
    this.humidity,
    this.pump,
    this.temperature,
    this.moisture,
  });

  Pump.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key, //proses sending data ke realtime database
        humidity = snapshot.value['humidity'].toString(),
        moisture = snapshot.value['moisture'],
        temperature = snapshot.value['temperature'],
        pump = snapshot.value['pump'];

  Map<String, dynamic> toJson() => {
        'humidity': humidity,
        'moisture': moisture,
        'temperature': temperature,
        'pump': pump,
      };
}
