import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();
  final List<String> audioFiles = [
    'ElementosQuimicos.mp3',
    // Agrega más nombres de archivos de audio aquí
  ];

  @override
  void initState() {
    super.initState();
    _assetsAudioPlayer.open(
      Playlist(
          audios:
              audioFiles.map((file) => Audio('assets/audios/$file')).toList()),
      autoStart: false,
      showNotification: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'Reacciones químicas',
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.green,
        shadowColor: Colors.grey,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF4CAF50), // Un tono de verde
                Color(0xFF8BC34A), // Otro tono de verde
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fondoFinal.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: ListView.builder(
          itemCount: audioFiles.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(audioFiles[index]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.play_arrow),
                      onPressed: () {
                        _assetsAudioPlayer.playOrPause();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.stop),
                      onPressed: () {
                        _assetsAudioPlayer.stop();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _assetsAudioPlayer.dispose();
    super.dispose();
  }
}
