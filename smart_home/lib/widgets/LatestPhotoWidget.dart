import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
class LatestPhotoWidget extends StatefulWidget {
  final String folderPath;
  LatestPhotoWidget({required this.folderPath});
  @override
  _LatestPhotoWidgetState createState() => _LatestPhotoWidgetState();
}

class _LatestPhotoWidgetState extends State<LatestPhotoWidget> {
  String? _latestPhotoUrl;
   late String  listResult;
  @override
  void initState() {
    super.initState();
    callRealTime();
  }
  void callRealTime() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      _getLatestPhoto();
    });
  }
  Future<void> _getLatestPhoto() async {
    final downloadUrl = await getLatestFileUrl(widget.folderPath);
    setState(() {
      _latestPhotoUrl = downloadUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _latestPhotoUrl == null
        ? Center(child: CircularProgressIndicator())
        : Image.network(_latestPhotoUrl!, fit: BoxFit.cover,);
  }

  Future<String?> getLatestFileUrl(String folderPath) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    // Replace "exampleFolder" with the name of the folder
    // that you want to retrieve the latest file from.
    Reference  ref = storage.ref().child(folderPath);
    final ListResult result = await ref.listAll();
    final List<Reference> items = result.items;
    List Listcreated = [];
    // for one get and sort metadata by createdTime
    for(var item in items) {
      final metadata = await item.getMetadata();
      final createdTime = metadata.timeCreated;
      Listcreated.add(createdTime);
      Listcreated.sort((a, b) => b.compareTo(a));
    }
    // Compare latestCreatedTime with timeCreated of file
    for (var ref in items ) {
      final metadata = await ref.getMetadata();
      final fileCreateTime = metadata.timeCreated;
      int? compare = fileCreateTime?.compareTo(Listcreated.first);
      // if compare == 0 (fileCreatedTime new )
      if(compare == 0) {
        return _latestPhotoUrl = await ref.getDownloadURL();
      }
    }
    return _latestPhotoUrl;
    }
}
