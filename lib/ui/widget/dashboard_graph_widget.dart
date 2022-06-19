import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'indicator.dart';

class DashboardGraphWidget extends StatefulWidget {
  const DashboardGraphWidget({Key? key}) : super(key: key);

  @override
  State<DashboardGraphWidget> createState() => _DashboardGraphWidgetState();
}

class _DashboardGraphWidgetState extends State<DashboardGraphWidget> {
  final CollectionReference _pumpItem =
      FirebaseFirestore.instance.collection('water sprinkler');

  final databaseReference = FirebaseDatabase.instance.reference();

  int touchedIndex = -1;
  String humandityLabel = '0';
  String moistureLabel = '0';
  String temperatureLabel = '0';

  double humandityCount = 0;
  double moistureCount = 0;
  double temperatureCount = 0;

  bool isPumpActive = false;

  Future<void> readData() async {
    Future.delayed(const Duration(seconds: 5), () async {
      databaseReference.once().then((DataSnapshot snapshot) {
        print('Data : ${snapshot.value['data']['humidity']}');
        print('Data : ${snapshot.value['data']['moist']}');
        print('Data : ${snapshot.value['data']['temperature']}');
        if (mounted) {
          setState(() {
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
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
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
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Text('humidity : '),
                                    Text(humandityLabel),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Text('moisture : '),
                                    Text(moistureLabel),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Text('temperature : '),
                                    Text(temperatureLabel),
                                  ],
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
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: AspectRatio(
              aspectRatio: 1.3,
              child: Card(
                //color: Colors.white,
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      height: 18,
                    ),
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: PieChart(
                          PieChartData(
                              pieTouchData: PieTouchData(touchCallback:
                                  (FlTouchEvent event, pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex = pieTouchResponse
                                      .touchedSection!.touchedSectionIndex;
                                });
                              }),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              sectionsSpace: 0,
                              centerSpaceRadius: 40,
                              sections: showingSections()),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        Indicator(
                          color: Color(0xff0293ee),
                          text: 'Humidity',
                          textColor: Colors.white,
                          isSquare: true,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Indicator(
                          color: Color(0xfff8b250),
                          text: 'Moisture',
                          textColor: Colors.white,
                          isSquare: true,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Indicator(
                          color: Color(0xff845bef),
                          text: 'temperature',
                          textColor: Colors.white,
                          isSquare: true,
                        ),
                        SizedBox(
                          height: 18,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 28,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: humandityCount,
            title: humandityLabel,
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: moistureCount,
            title: moistureLabel,
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: temperatureCount,
            title: temperatureLabel,
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );

        default:
          throw Error();
      }
    });
  }
}
