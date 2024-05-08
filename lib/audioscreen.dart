import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:quimicapp/personalizadorwidget.dart';
import 'package:quimicapp/themeAppDark/themenotifier.dart';

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
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: PersonalizadorWidget.buildGradientAppBar(
          title: 'Audios química', context: context),
      body: Consumer<ThemeNotifier>(
        builder: (context, value, child) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: themeNotifier.isUsingFirstTheme
                ? const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/fondoFinal.jpg"),
                      fit: BoxFit.fill,
                    ),
                  )
                : BoxDecoration(
                    color: Colors.grey[600],
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
                          Theme.of(context)
                              .primaryColor, // Color primario del tema
                          Theme.of(context).colorScheme.secondary,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius:
                          BorderRadius.circular(15), // Borde redondeado
                    ),
                    child: SizedBox(
                      height: 99,
                      child: Card(
                        color: Colors.white, // Fondo blanco
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.music_note,
                                  color: Theme.of(context).iconTheme.color),
                              title: SizedBox(
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
                                    icon: Icon(Icons.skip_previous,
                                        color:
                                            Theme.of(context).iconTheme.color),
                                    color: Colors.black,
                                    // Botón para comenzar desde el principio
                                    onPressed: () {
                                      _audioPlayers[index].seek(Duration.zero);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.play_arrow,
                                        color:
                                            Theme.of(context).iconTheme.color),
                                    color: Colors.black,
                                    onPressed: () {
                                      for (var player in _audioPlayers) {
                                        if (player.isPlaying.value) {
                                          player.stop();
                                        }
                                      }
                                      _audioPlayers[index].open(
                                        Audio(
                                            'assets/audios/${audioFiles[index]}'),
                                        autoStart: true,
                                        showNotification: true,
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.stop,
                                        color:
                                            Theme.of(context).iconTheme.color),
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
                                    _audioPlayers[index]
                                        .current
                                        .valueOrNull
                                        ?.audio;
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
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Text(
                                            totalDuration != Duration.zero
                                                ? totalDuration
                                                    .toString()
                                                    .split('.')
                                                    .first
                                                : '00:00:00',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 315,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: LinearProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
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
          );
        },
      ),
    );
  }
}
