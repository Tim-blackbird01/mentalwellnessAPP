import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Song {
  final String title;
  final String artist;
  final String url;

  Song({required this.title, required this.artist, required this.url});
}

class MusicPlayerScreen extends StatefulWidget {
  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  final CollectionReference songsCollection =
      FirebaseFirestore.instance.collection('songs');
  List<Song> songs = [];
  int currentIndex = 0;
  PlayerState playerState = PlayerState.STOPPED;

  @override
  void initState() {
    super.initState();
    fetchSongs();
  }

  Future<void> fetchSongs() async {
    final snapshot = await songsCollection.get();
    setState(() {
      songs = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Song(
          title: data['title'] as String,
          artist: data['artist'] as String,
          url: data['url'] as String,
        );
      }).toList();
    });
  }

  void playAudio(String url) async {
  await audioPlayer.play(UrlSource(url));
  setState(() {
    playerState = PlayerState.PLAYING;
  });
}
  void pauseAudio() {
    audioPlayer.pause();
    setState(() {
      playerState = PlayerState.PAUSED;
    });
  }

  void stopAudio() {
    audioPlayer.stop();
    setState(() {
      playerState = PlayerState.STOPPED;
    });
  }

  void playNext() {
  stopAudio();
  setState(() {
    currentIndex = (currentIndex + 1) % songs.length;
  });
  playAudio(songs[currentIndex].url);
}
  void playPrevious() {
    stopAudio();
    setState(() {
      currentIndex = (currentIndex - 1 + songs.length) % songs.length;
    });
    playAudio(songs[currentIndex].url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Now Playing:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              songs.isNotEmpty ? songs[currentIndex].title : '',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous),
                  onPressed: playPrevious,
                ),
                IconButton(
                  icon: Icon(playerState == PlayerState.PLAYING
                      ? Icons.pause
                      : Icons.play_arrow),
                  onPressed: () {
                    if (playerState == PlayerState.PLAYING) {
                      pauseAudio();
                    } else {
                      playAudio(songs[currentIndex].url);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.skip_next),
                  onPressed: playNext,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum PlayerState {
  STOPPED,
  PLAYING,
  PAUSED,
}
