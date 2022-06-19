import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';

class PumpControllerWidget extends StatefulWidget {
  const PumpControllerWidget({Key? key}) : super(key: key);

  @override
  State<PumpControllerWidget> createState() => _PumpControllerWidgetState();
}

class _PumpControllerWidgetState extends State<PumpControllerWidget> {
  final CollectionReference _pumpItem =
      FirebaseFirestore.instance.collection('water sprinkler');
  // regis 3th patry dbrt
  final databaseReference = FirebaseDatabase.instance.reference();

  String humandityLabel = '0';
  String moistureLabel = '0';
  String temperatureLabel = '0';
  String statusPumpLabel = '';

  double? humandityCount;
  double? moistureCount;
  double? temperatureCount;
  bool isButtonSelected = false;
  bool isLoading = false;

  // 1st status pump
  bool isPumpActive = false;

  Future<void> _updatePumpStatus() async {
    //update pump
    if (isPumpActive == true) {
      isLoading = false;
      await databaseReference.child('data').update({'pump': false});
      isLoading = true;
    } else {
      isLoading = false;
      await databaseReference.child('data').update({'pump': true});
      isLoading = true;
    }
  }

  Future<void> readData() async {
    Future.delayed(const Duration(seconds: 5), () async {
      // call dbrt
      databaseReference.once().then((DataSnapshot snapshot) {
        print('Data : ${snapshot.value['data']['humidity']}');
        print('Data : ${snapshot.value['data']['moist']}');
        print('Data : ${snapshot.value['data']['temperature']}');
        if (mounted) {
          setState(() {
            isLoading = true;
            debugPrint('tes');

            humandityLabel = snapshot.value['data']['humidity'].toString();
            moistureLabel = snapshot.value['data']['moist'].toString();
            temperatureLabel = snapshot.value['data']['temperature'].toString();

            // to graph
            humandityCount =
                (snapshot.value['data']['humidity'] as num).toDouble();
            moistureCount = (snapshot.value['data']['moist'] as num).toDouble();
            // moistureCount = snapshot.value['data']['moist'];
            temperatureCount = snapshot.value['data']['temperature'];
            debugPrint('$humandityCount - $temperatureCount');
            //temperatureCount = snapshot.value['data']['temperature'];
            isPumpActive = snapshot.value['data']['pump'];
            if (isPumpActive == true) {
              statusPumpLabel = 'Matikan Pump';
            } else {
              statusPumpLabel = 'Nyalakan Pump';
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 210,
            child: FutureBuilder(
              future: readData(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Card(
                        margin: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Column(children: [
                                    const Text('Devices Status'),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      isPumpActive == true
                                          ? 'Pump sedang aktif'
                                          : 'Pump tidak aktif',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ));
                  },
                );
              },
            ),
          ),
          SizedBox(
            child: isLoading == true
                ? AnimatedButton(
                    onPress: () {
                      _updatePumpStatus();
                    },
                    height: 50,
                    width: 200,
                    text: statusPumpLabel,
                    isReverse: true,
                    selectedTextColor: Colors.white,
                    transitionType: TransitionType.LEFT_TO_RIGHT,
                    textStyle: const TextStyle(color: Colors.white),
                    backgroundColor: isPumpActive == true
                        ? Colors.red
                        : const Color.fromARGB(255, 37, 128, 40),
                    selectedBackgroundColor: Colors.transparent,
                    borderColor: Colors.white,
                    borderWidth: 1,
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
