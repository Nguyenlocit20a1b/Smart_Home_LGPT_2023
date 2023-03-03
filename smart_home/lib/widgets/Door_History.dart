import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
class ImageGrid extends StatefulWidget {
  @override
  _ImageGridState createState() => _ImageGridState();
}

class _ImageGridState extends State<ImageGrid> {
  List<String> imageUrls = [];
  List<DateTime> dateList = [];
  @override
  void initState() {
    super.initState();
    callRealTime();
  }
  void callRealTime() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      getImages();
    });
  }
  Future<void> getImages() async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      final Reference storageRef = storage.ref().child('/');
      final ListResult result = await storageRef.listAll();
      final List<String> urls = [];
      final List<DateTime> dates = [];
      for (final item in result.items) {
        final String url = await item.getDownloadURL();
        urls.add(url);
        final metadata = await item.getMetadata();
        final created = metadata.timeCreated;
        dates.add(created!);
      }
      setState(() {
        imageUrls = urls;
        dateList = dates ;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: imageUrls.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FullScreenImage(url: imageUrls[index], date: dateList[index],),
              ),
            );
          },
          child: Hero(
            tag: 'imageHero$index',
            child: Image.network(
              imageUrls[index],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String url;
  final DateTime date ;

  FullScreenImage({super.key, required this.url, required this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 250,),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Center(
              child: Hero(
                tag: 'imageHero0',
                child: Image.network(url),
              ),
            ),
          ),
          SizedBox(height: 20,),
           Container(child: Text("This person visited your house" , style: TextStyle(color: Colors.black, fontSize: 25),),),
          SizedBox(height: 10,),
          Container(
            child: Text(date.toString(), style:  TextStyle(color: Colors.black , fontSize: 15 , fontWeight: FontWeight.bold),),
          )
        ],
      ),
    );
  }
}
