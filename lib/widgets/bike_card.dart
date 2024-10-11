// bike_card.dart
import 'package:bike_inspiration_app/my_flutter_app_icons.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'dart:io';

class BikeCard extends StatelessWidget {
  final Map<String, dynamic> bikeInfo;

  const BikeCard({super.key, required this.bikeInfo});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 9,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  bikeInfo["frame"] ?? "No Frame Info",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green),
                ),
                Text(
                  bikeInfo["type"]?.toUpperCase() ?? "Unknown",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.file(
                File(bikeInfo["image_filename"]),
                errorBuilder: (context, error, stackTrace) {
                  return Text('Image not available');
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Groupset",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Wheels",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1, // you can play with this value, by default it is 1
                  child: Text(
                    "Price-Range",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: Text("${bikeInfo["groupset"] ?? 'N/A'}", maxLines: 2),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Text("${bikeInfo["wheels"] ?? 'N/A'}", maxLines: 2),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Text(
                    "${bikeInfo["pricerange"] ?? 'N/A'}",
                    maxLines: 2,
                  ),
                ),
              ],
            ),
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
                          leading: Icon(CustomIcons.cassette),
                          title: Text("Cassette"),
                          subtitle: Text("${bikeInfo["cassette"] ?? 'N/A'}"),
                        ),
                        ListTile(
                          leading: Icon(CustomIcons.chain),
                          title: Text("Chain"),
                          subtitle: Text("${bikeInfo["chain"] ?? 'N/A'}"),
                        ),
                        ListTile(
                          leading: Icon(CustomIcons.crank),
                          title: Text("Crank"),
                          subtitle: Text("${bikeInfo["crank"] ?? 'N/A'}"),
                        ),
                        ListTile(
                          leading: Icon(CustomIcons.handlebar),
                          title: Text("Handlebar"),
                          subtitle: Text("${bikeInfo["handlebar"] ?? 'N/A'}"),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Icon(CustomIcons.pedal),
                          title: Text("Pedals"),
                          subtitle: Text("${bikeInfo["pedals"] ?? 'N/A'}"),
                        ),
                        ListTile(
                          leading: Icon(CustomIcons.seat),
                          title: Text("Saddle"),
                          subtitle: Text("${bikeInfo["saddle"] ?? 'N/A'}"),
                        ),
                        ListTile(
                          leading: Icon(CustomIcons.stem),
                          title: Text("Stem"),
                          subtitle: Text("${bikeInfo["stem"] ?? 'N/A'}"),
                        ),
                        ListTile(
                          leading: Icon(CustomIcons.car),
                          title: Text("Tires"),
                          subtitle: Text("${bikeInfo["tires"] ?? 'N/A'}"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: LikeButton(
                  animationDuration: Duration(seconds: 0),
                  likeCount: 665,
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Coming Soon!')),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
