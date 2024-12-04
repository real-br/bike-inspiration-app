import 'package:bike_inspiration_app/widgets/my_flutter_app_icons.dart';
import 'package:bike_inspiration_app/widgets/save_post.dart';
import 'package:bike_inspiration_app/widgets/like_post.dart';
import 'package:flutter/material.dart';
import 'get_user_id.dart';

class BikeCard extends StatefulWidget {
  final Map<String, dynamic> bikeInfo;
  BikeCard({required this.bikeInfo});
  @override
  _BikeCardState createState() => _BikeCardState();
}

class _BikeCardState extends State<BikeCard> {
  bool _isSaved = false;
  bool _isLiked = false;
  String? userName;
  String? token;
  int? _nrLikes = 0;

  @override
  void initState() {
    super.initState();
    _initializeUserAndSavedAndLikedStatus();
  }

  Future<void> _initializeUserAndSavedAndLikedStatus() async {
    final userInfo = await getUserId();
    userName = userInfo['userName'];
    token = userInfo['token'];
    final nrLikes = await getNrLikes(widget.bikeInfo["id"], token!);

    setState(() {
      _isSaved = checkSaved(widget.bikeInfo, userName!);
      _isLiked = checkLiked(widget.bikeInfo, userName!);
      _nrLikes = nrLikes;
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

  bool checkLiked(Map<String, dynamic> bikeInfo, String userName) {
    print(bikeInfo);
    if (bikeInfo.containsKey("liked_posts") &&
        bikeInfo["liked_posts"] is List) {
      for (var likedPost in bikeInfo["liked_posts"]) {
        if (likedPost['user_name'] == userName) {
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
        mainAxisAlignment: MainAxisAlignment.center,
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
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: AspectRatio(
                  aspectRatio: 16 / 9, // Adjust the aspect ratio as needed
                  child: Image.network(
                    widget.bikeInfo["image_url"],
                    fit: BoxFit
                        .contain, // Ensures the image scales and crops appropriately
                  ),
                ),
              )),
          SizedBox(height: 10),
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
                  flex: 1,
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: _isLiked
                          ? Icon(Icons.favorite, color: Colors.red)
                          : Icon(
                              Icons.favorite_border,
                              color: Colors.grey,
                            ),
                      onPressed: () async {
                        setState(() {
                          _isLiked = !_isLiked;
                        });
                        if (_isLiked) {
                          likePost(widget.bikeInfo["id"], userName!, token!);
                          _nrLikes = (_nrLikes ?? 0) + 1;
                        } else {
                          unlikePost(widget.bikeInfo["id"], userName!, token!);
                          _nrLikes = (_nrLikes ?? 0) - 1;
                        }
                      },
                    ),
                    Text(_nrLikes.toString()),
                  ],
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
