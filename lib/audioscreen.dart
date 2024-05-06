import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  List<AssetsAudioPlayer> _audioPlayers = [];
  final List<String> audioFiles = [
    'Ciencia rapida.mp3',
    'Propiedades de la materia.mp3',
    'ElementosQuimicos.mp3',
    'El atomo nucleado.mp3',

    // Agrega más nombres de archivos de audio aquí
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayers = List.generate(audioFiles.length, (index) {
      return AssetsAudioPlayer();
    });
  }

  @override
  void dispose() {
    // Detener todos los audios al salir de la pantalla
    for (var player in _audioPlayers) {
      player.stop();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'Audios Química',
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
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF4CAF50), // Un tono de verde
                      Color(0xFF8BC34A), // Otro tono de verde
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(15), // Borde redondeado
                ),
                child: SizedBox(
                  height: 99,
                  child: Card(
                    color: Colors.white, // Fondo blanco
                    child: Column(
                      children: [
                        ListTile(
                          // Color de fondo al pasar el cursor
                          leading: Icon(Icons.music_note, color: Colors.black),
                          title: Container(
                            height: 20,
                            width: 150,
                            child: Marquee(
                              text: audioFiles[index],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              velocity: 50.0,
                              blankSpace: 20.0,
                              startPadding: 10.0,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.skip_previous),
                                color: Colors.black,
                                // Botón para comenzar desde el principio
                                onPressed: () {
                                  _audioPlayers[index].seek(Duration.zero);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.play_arrow),
                                color: Colors.black,
                                onPressed: () {
                                  for (var player in _audioPlayers) {
                                    if (player.isPlaying.value) {
                                      player.stop();
                                    }
                                  }
                                  _audioPlayers[index].open(
                                    Audio('assets/audios/${audioFiles[index]}'),
                                    autoStart: true,
                                    showNotification: true,
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.stop),
                                color: Colors.black,
                                onPressed: () {
                                  _audioPlayers[index].stop();
                                },
                              ),
                            ],
                          ),
                        ),
                        // Barra de progreso
                        StreamBuilder<Duration>(
                          stream: _audioPlayers[index].currentPosition,
                          builder: (context, snapshot) {
                            final Duration? currentPosition = snapshot.data;
                            final PlayingAudio? currentAudio =
                                _audioPlayers[index].current.valueOrNull?.audio;
                            final Duration totalDuration =
                                currentAudio?.duration ?? Duration.zero;
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        currentPosition != null
                                            ? currentPosition
                                                .toString()
                                                .split('.')
                                                .first
                                            : '00:00:00',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        totalDuration != Duration.zero
                                            ? totalDuration
                                                .toString()
                                                .split('.')
                                                .first
                                            : '00:00:00',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: LinearProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.orange),
                                    backgroundColor: Colors.grey,
                                    minHeight: 15,
                                    value: currentPosition != null &&
                                            totalDuration != Duration.zero
                                        ? currentPosition.inMilliseconds /
                                            totalDuration.inMilliseconds
                                        : 0.0,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
