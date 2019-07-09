import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoList extends StatefulWidget {
  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  var videoIds = <String>[
    //Lista de IDs de videos
    "Gb_-rZB2Foc",
    "FJzZ6zIJZzo",
    "Gs069dndIYk",
    "VwBIVWX8YtQ",
    "l-FxY25lYzY",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video List"),
      ),
      body: ListView.separated(
        //Cria lista de videos declarados acima
        itemBuilder: (context, index) => YoutubePlayer(
              key: UniqueKey(),
              context: context,
              videoId: videoIds[index],
              flags: YoutubePlayerFlags(
                autoPlay: false,
                showVideoProgressIndicator: true,
                hideFullScreenButton: true,
              ),
            ),
        separatorBuilder: (_, i) => SizedBox(
              height: 10.0,
            ),
        itemCount: videoIds.length,
      ),
    );
  }
}
