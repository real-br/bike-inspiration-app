import 'package:bike_inspiration_app/widgets/my_flutter_app_icons.dart';
import 'package:bike_inspiration_app/widgets/save_post.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'get_user_id.dart';

class BikeCard extends StatefulWidget {
  final Map<String, dynamic> bikeInfo;
  BikeCard({required this.bikeInfo});
  @override
  _BikeCardState createState() => _BikeCardState();
}

class _BikeCardState extends State<BikeCard> {
  bool _isSaved = false;
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

    setState(() {
      _isSaved = checkSaved(widget.bikeInfo, userName!);
    });
  }

  bool checkSaved(Map<String, dynamic> bikeInfo, String userName) {
    if (bikeInfo.containsKey("saved_posts") &&
        bikeInfo["saved_posts"] is List) {
      for (var savedPost in bikeInfo["saved_posts"]) {
        if (savedPost['user_name'] == userName) {
          return true;
        }
      }
    }
    return false;
  }

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
                  widget.bikeInfo["frame"] ?? "No Frame Info",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green),
                ),
                Text(
                  widget.bikeInfo["type"]?.toUpperCase() ?? "Unknown",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(widget.bikeInfo["image_url"]),
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
                  child: Text("${widget.bikeInfo["groupset"] ?? 'N/A'}",
                      maxLines: 2),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Text("${widget.bikeInfo["wheels"] ?? 'N/A'}",
                      maxLines: 2),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Text(
                    "${widget.bikeInfo["price_range"] ?? 'N/A'}",
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
                          subtitle:
                              Text("${widget.bikeInfo["handlebar"] ?? 'N/A'}"),
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
                          subtitle: Text("${widget.bikeInfo["stem"] ?? 'N/A'}"),
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
                  icon: Icon(Icons.push_pin,
                      color: _isSaved ? Colors.green : Colors.grey),
                  onPressed: () async {
                    setState(() {
                      _isSaved = !_isSaved;
                    });
                    if (_isSaved) {
                      savePost(widget.bikeInfo["id"], userName!, token!);
                    } else {
                      unsavePost(widget.bikeInfo["id"], userName!, token!);
                    }
                  },
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
