import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../utils.dart';
import '../widgets/slider_widget.dart';
class TemperatureMonitorScreen extends StatefulWidget {
  const TemperatureMonitorScreen({Key? key}) : super(key: key);
  @override
  State<TemperatureMonitorScreen> createState() => _TemperatureMonitorScreenState();
}

String humidity = '0';
String temperature = '0';
String message = '' ;

DatabaseReference dbRef = FirebaseDatabase.instance.ref();
class _TemperatureMonitorScreenState extends State<TemperatureMonitorScreen> {

  @override
  void initState() {
    super.initState();
    dbRef.onValue.listen((event) {
      // Handle the data update here
      DataSnapshot snapshot = event.snapshot;
      String dbMessage = snapshot.child('Message').value.toString();
      String dbhumidity = snapshot.child('Humidity').value.toString();
      String dbtemperature = snapshot.child('Temperature').value.toString();

      // Update the UI with the new data
      setState(() {
        humidity = dbhumidity;
        temperature = dbtemperature;
        message = dbMessage;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.blue,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.login,
              color: Colors.blue,
            ),
            onPressed: () {},
          )
        ],
      ),

      body:
      SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Text(
                  'Temperature',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 26),
                ),
                Text(
                  'Living room',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Expanded(
              child: SliderWidget(),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Current humidity',
                      style: TextStyle(
                        color: Colors.grey.withAlpha(150),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '$humidity%',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Current temp.',
                      style: TextStyle(
                        color: Colors.grey.withAlpha(150),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '$temperature°C',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 35,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Automatic',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor:  MaterialStateProperty.all(
                          Colors.grey ) ,
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    showAlert();
                  },
                  child: Icon(
                    Icons.adjust,
                    color: Colors.black.withAlpha(175),
                  ),
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(double.parse(temperature) <  30? Colors
                        .grey : Colors.red.shade400),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Icon(
                    Icons.airplay,
                    color: Colors.black.withAlpha(175),
                  ),
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(Colors
                        .grey),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
        // );
        //   } else return Container();
        // }

      ),
    );
  }

  void showAlert() {
    if (double.parse(temperature) >= 30) {
        QuickAlert.show(context: context,
            backgroundColor: Colors.orange.withOpacity(0.5),
            text:message,
            confirmBtnColor: Colors.deepOrange,
            type: QuickAlertType.warning);
    }
  }
}
