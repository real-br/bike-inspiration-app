import 'package:flutter/material.dart';
import 'package:bike_inspiration_app/widgets/my_flutter_app_icons.dart';
import 'get_user_id.dart';
import 'package:bike_inspiration_app/widgets/save_post.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SavedBikeCard extends StatefulWidget {
  final Map<String, dynamic> bikeInfo;
  final VoidCallback onDelete;
  SavedBikeCard({required this.bikeInfo, required this.onDelete});
  @override
  _SavedBikeCardState createState() => _SavedBikeCardState();
}

class _SavedBikeCardState extends State<SavedBikeCard> {
  String? userName;
  String? token;

  @override
  void initState() {
    super.initState();
    _initializeUserAndSavedStatus();
  }

  Future<void> _initializeUserAndSavedStatus() async {
    final userInfo = await getUserId();
    userName = userInfo['userName'];
    token = userInfo['token'];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 9,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: AspectRatio(
                      aspectRatio:
                          16 / 9, // Or set dynamically based on your needs
                      child: Image.network(
                        widget.bikeInfo["image_url"],
                        fit: BoxFit
                            .contain, // Adjusts image to fit fully without cropping
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Model",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("${widget.bikeInfo["frame"] ?? 'N/A'}"),
                      SizedBox(height: 10),
                      Text(
                        "Type",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("${widget.bikeInfo["type"] ?? 'N/A'}"),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Year",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("${widget.bikeInfo["year"] ?? 'N/A'}"),
                      SizedBox(height: 10),
                      Text(
                        "Price",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("${widget.bikeInfo["price_range"] ?? 'N/A'}"),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.grey),
                      onPressed: () {
                        unsavePost(widget.bikeInfo["id"], userName!, token!);
                        widget.bikeInfo.clear();
                        widget.onDelete();
                      } // Trigger the delete callback
                      ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('More details'),
              shape: Border(),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: Icon(CustomIcons.racing_bike),
                            title: Text("Groupset"),
                            subtitle:
                                Text("${widget.bikeInfo["groupset"] ?? 'N/A'}"),
                          ),
                          ListTile(
                            leading: Icon(CustomIcons.cassette),
                            title: Text("Cassette"),
                            subtitle:
                                Text("${widget.bikeInfo["cassette"] ?? 'N/A'}"),
                          ),
                          ListTile(
                            leading: Icon(CustomIcons.chain),
                            title: Text("Chain"),
                            subtitle:
                                Text("${widget.bikeInfo["chain"] ?? 'N/A'}"),
                          ),
                          ListTile(
                            leading: Icon(CustomIcons.crank),
                            title: Text("Crank"),
                            subtitle:
                                Text("${widget.bikeInfo["crank"] ?? 'N/A'}"),
                          ),
                          ListTile(
                            leading: Icon(CustomIcons.handlebar),
                            title: Text("Handlebar"),
                            subtitle: Text(
                                "${widget.bikeInfo["handlebar"] ?? 'N/A'}"),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: Icon(CustomIcons.spoke_wheel),
                            title: Text("Wheels"),
                            subtitle:
                                Text("${widget.bikeInfo["wheels"] ?? 'N/A'}"),
                          ),
                          ListTile(
                            leading: Icon(CustomIcons.pedal),
                            title: Text("Pedals"),
                            subtitle:
                                Text("${widget.bikeInfo["pedals"] ?? 'N/A'}"),
                          ),
                          ListTile(
                            leading: Icon(CustomIcons.seat),
                            title: Text("Saddle"),
                            subtitle:
                                Text("${widget.bikeInfo["saddle"] ?? 'N/A'}"),
                          ),
                          ListTile(
                            leading: Icon(CustomIcons.stem),
                            title: Text("Stem"),
                            subtitle:
                                Text("${widget.bikeInfo["stem"] ?? 'N/A'}"),
                          ),
                          ListTile(
                            leading: Icon(CustomIcons.car),
                            title: Text("Tires"),
                            subtitle:
                                Text("${widget.bikeInfo["tires"] ?? 'N/A'}"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
