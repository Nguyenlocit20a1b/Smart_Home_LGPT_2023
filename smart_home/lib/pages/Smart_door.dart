
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../widgets/Door_History.dart';
import '../widgets/LatestPhotoWidget.dart';



class SmartDoor extends StatefulWidget {
  const SmartDoor({Key? key}) : super(key: key);

  @override
  State<SmartDoor> createState() => _SmartDoorState();
}
  bool status = true ;

class _SmartDoorState extends State<SmartDoor> {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref('door');
  @override
  void initState() {
    databaseReference.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      String statusOfDoor = snapshot.child('status').value.toString();
      print(statusOfDoor);
      if(double.parse(statusOfDoor) == 1) {
        print(double.parse(statusOfDoor));
        setState(() {
          status = true;
        });

      } else {
        setState(() {
          status = false;
        });

      }
    });
    // TODO: implement initState
    super.initState();
  }

  void showAlertSuccess() {
    QuickAlert.show(context: context,
        text:"The door has been opened",
        type: QuickAlertType.success);
  }
  void openDoor() {
    databaseReference.update({
      'status': 1,
    });
    showAlertSuccess();
  }

  void closeDoor() {
    databaseReference.update({
      'status': 0,
    });

  }
  void doorState(statusDoor) {
    setState(() {
      status = statusDoor;
    });
    if(status) {
      openDoor();
    } else {
      closeDoor();
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Smart Door'),
      backgroundColor: Colors.grey.shade700,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 400,
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 4,
                    offset: Offset(8, 10), // Shadow position
                  ),
                ],
              ),
              child: !status? LatestPhotoWidget(folderPath: '/'): NoBody(),
            ),
            SizedBox(height: 30,),
            !status?
            Text("Make sure you know this person", style: TextStyle(color: Colors.black, fontSize: 23),)
            :Text("  The door is open, please  attention ", style: TextStyle(color: Colors.black, fontSize: 23),) ,
            SizedBox(height: 20,),
            status? ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
              ),
              onPressed: () {
                doorState(false);
              },
              child: Text('Close Door', style: TextStyle(fontSize: 28)
              ),
            ):ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white,
              ),
              onPressed: () {
                doorState(true);
              },
              child: Text('Open Door', style: TextStyle(fontSize: 28)
              ),
            ),
            SizedBox(height: 20,),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ImageGrid()),
              );},
              child: const Text('See History'),
            )
          ],
        ),
      ) ,
    );
  }
  Widget NoBody() {
    return   Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 4,
            offset: Offset(8, 10), // Shadow position
          ),
        ],
      ),
      child: Image.network('https://i.ytimg.com/vi/YtXJQomYZug/maxresdefault.jpg', fit: BoxFit.cover ,),
    );
  }

}
