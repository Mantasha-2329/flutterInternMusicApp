import 'dart:math';  // For shuffle functionality
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';  // For audio playback

void main() => runApp(MusicApp());

class MusicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SimpleMusicPlayerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SimpleMusicPlayerScreen extends StatefulWidget {
  @override
  _SimpleMusicPlayerScreenState createState() => _SimpleMusicPlayerScreenState();
}

class _SimpleMusicPlayerScreenState extends State<SimpleMusicPlayerScreen> {
  AudioPlayer audioPlayer = AudioPlayer();  // Create audio player
  bool isPlaying = false;  // Track if music is playing
  bool isShuffle = false;  // Track if shuffle is enabled
  int currentTrackIndex = 0;  // Track current song index
  Random random = Random();  // Random number generator for shuffle

  // Simple playlists with URLs (replace with valid URLs)
  Map<String, List<String>> playlists = {
    'Chill': ['https://soundcloud.com/percyabmusic/aise-kyun-percy-ab-remix-hindi?si=6d7618f6b79541a7b16aaae9fb736cd7&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing',
              'https://soundcloud.com/spartan-400266619/chill-indian-sing-off-rajneesh-patel-dhruvan-moorthy-hindi-punjabi-marathi-song?si=10f9ad6106de4e89944de08555af9ea9&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing'],
    'Rock': ['https://soundcloud.com/kuenzang-jetsun-dema/sets/hindi-rock-song-1?si=fec31aaa72ba4178a91ec8a0d7eed633&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing',
             'https://soundcloud.com/kuenzang-jetsun-dema/sets/hindi-rock-song-1?si=2af6429220d44afc9875a6d832948992&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing'],
    'Romantic':[
      'https://soundcloud.com/flex-musix/mahiya-new-hindi-songs?si=48208c86e75943fbae0adcd147e87382&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing',
      'https://soundcloud.com/flex-musix/khaab-hindi-new-romantic-song?si=69fa504af1fc4497817ad67652ad21fd&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing',
      'https://soundcloud.com/sabanoor543/naina-lageya-romantic-hindi-song-love-story-latest-hindi-song-2024-hindi-video-song?si=d79c18178ad64fc6b13aacbfea6320b5&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing',
    ],
    'Party Vibes': [
      'https://soundcloud.com/djgammer/sugar-were-going-down?si=1e2bff2936cc4e70a570513dfba7c7a7&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing',
      'https://soundcloud.com/mahbub-alam-285692658/sets/hindi-party-song?si=67e8f01d9c9d491e8fee7df1ac5bbae0&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing',
      'https://soundcloud.com/mahbub-alam-285692658/sets/hindi-party-song?si=94e06b1b9ed2480f8c15e55c26ad455b&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing',
      'https://soundcloud.com/mahbub-alam-285692658/sets/hindi-party-song?si=b2391b56362740038634621080cf9e6b&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing'
    ],
  };

  String selectedPlaylist = 'Chill';  // Default playlist

  // Get the songs of the current playlist
  List<String> get currentPlaylist => playlists[selectedPlaylist]!;

  // Play the selected track
  void playTrack() async {
    await audioPlayer.play(currentPlaylist[currentTrackIndex] as Source);
    setState(() {
      isPlaying = true;
    });
  }

  // Stop the current track
  void stopTrack() async {
    await audioPlayer.stop();
    setState(() {
      isPlaying = false;
    });
  }

  // Skip to the next track
  void nextTrack() {
    setState(() {
      if (isShuffle) {
        currentTrackIndex = random.nextInt(currentPlaylist.length);  // Pick random track in shuffle mode
      } else {
        currentTrackIndex = (currentTrackIndex + 1) % currentPlaylist.length;  // Move to next track
      }
      playTrack();
    });
  }

  // Toggle shuffle mode
  void toggleShuffle() {
    setState(() {
      isShuffle = !isShuffle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Center(child: Text( 'Music Player',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show the current playlist and track number
            Text('Playlist: $selectedPlaylist', style: TextStyle(fontSize: 28)),
            SizedBox(height: 10,),
            Text('Music: ${currentTrackIndex + 1}', style: TextStyle(fontSize: 17)),
            SizedBox(height:40),
         Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpan2MAUOki88jX9XLn79G1IJ9GtSt-kkPHA&s'),
            // Dropdown to select playlist
            DropdownButton<String>(
              value: selectedPlaylist,
              items: playlists.keys.map((playlist) {
                return DropdownMenuItem(
                  value: playlist,
                  child: Text(playlist),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPlaylist = value!;
                  currentTrackIndex = 0;
                  stopTrack();  // Stop the current track when playlist changes
                });
              },
            ),
            SizedBox(height: 20),

            // Play, Stop, and Next buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous),
                  onPressed: nextTrack,
                  iconSize: 50,
                ),
                IconButton(
                  icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                  onPressed: isPlaying ? stopTrack : playTrack,
                  iconSize: 50,
                ),
                IconButton(
                  icon: Icon(Icons.skip_next),
                  onPressed: nextTrack,
                  iconSize: 50,
                ),
              ],
            ),
            SizedBox(height: 20),

            // Shuffle switch
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Shuffle', style: TextStyle(fontSize:20)),
                Switch(
                  value: isShuffle,
                  onChanged: (value) {
                    toggleShuffle();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}