import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'video_list.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color(0xFFFF0000),
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Youtube Player Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        appBarTheme: AppBarTheme(color: Color(0xFFFF0000)),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: MyHomePage(title: 'Youtube Player Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  YoutubePlayerController _controller = YoutubePlayerController();
  var _idController = TextEditingController();
  var _seekToController = TextEditingController();
  double _volume = 100;
  bool _muted = true;
  String _playerStatus = "";
  String _errorCode = '0';

  String _videoId = "u4O8wE0gYO0";

  // iLnmTe5Q2Qw <<<< video anterior

  void listener() {
    if (_controller.value.playerState == PlayerState.ENDED) {
      _showThankYouDialog();
    }
    setState(() {
      _playerStatus = _controller.value.playerState.toString();
      _errorCode = _controller.value.errorCode.toString();
    });
  }

  @override
  void deactivate() {
    // This pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubeScaffold(
      //faz o video preencher a tela quando virar o celular na horizontal
      fullScreenOnOrientationChange: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.video_library,
                color: Colors.white,
              ),
              onPressed: () async {
                //Navega para a pagina VideoList
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VideoList()),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              YoutubePlayer(
                //Player principal de video
                context: context,
                videoId: _videoId,
                flags: YoutubePlayerFlags(
                  //Configurações do player de video
                  mute: false,
                  autoPlay: false,
                  forceHideAnnotation: true,
                  showVideoProgressIndicator: true,
                  disableDragSeek: false,
                ),
                videoProgressIndicatorColor: Color(0xFFFF0000),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      //Aparece na tela cheia
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    onPressed: () {},
                  ),
                  Text(
                    //Titulo da tela do video
                    'Hello! This is a test title.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      //Icone de configuracoes do player
                      Icons.settings,
                      color: Colors.white,
                      size: 25.0,
                    ),
                    onPressed: () {},
                  ),
                ],
                progressColors: ProgressColors(
                  playedColor: Color(0xFFFF0000),
                  handleColor: Color(0xFFFF4433),
                ),
                onPlayerInitialized: (controller) {
                  _controller = controller;
                  _controller.addListener(listener);
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      //Campo para inserir link ou ID de video
                      controller: _idController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), //borda da caixa de input
                          hintText: "Enter youtube \<video id\> or \<link\>"),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    InkWell(
                      //Detector de click para confirmar o ID do video
                      onTap: () {
                        setState(() {
                          _videoId = _idController.text;
                          // Se o texto é um link, converte para ID
                          if (_videoId.contains("http")) {
                            _videoId = YoutubePlayer.convertUrlToId(_videoId);
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 16.0,
                        ),
                        color: Color(0xFFFF0000),
                        child: Text(
                          "PLAY",
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      //Linha de icones de pause, mute e tela cheia
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            //altera o icone para pausado ou rodando
                            _controller.value.isPlaying
                                ? Icons.play_arrow
                                : Icons.pause,
                          ),
                          onPressed: () {
                            //Alterna o video para pausado ou rodando
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                            setState(() {});
                          },
                        ),
                        IconButton(
                          icon:
                              Icon(_muted ? Icons.volume_off : Icons.volume_up),
                          onPressed: () {
                            _muted ? _controller.unMute() : _controller.mute();
                            setState(() {
                              _muted = !_muted;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.fullscreen),
                          onPressed: () => _controller.enterFullScreen(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      //Campo para selecionar o minuto desejado do video
                      controller: _seekToController,
                      keyboardType: TextInputType.number, //Ativa teclado de numeros
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Seek to seconds",
                        suffixIcon: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: OutlineButton(
                            child: Text("Seek"),
                            //Função que procura o tempo determinado pelo controlador
                            onPressed: () => _controller.seekTo(
                                  Duration(
                                    //converte o texto do input para int
                                    seconds: int.parse(_seekToController.text),
                                  ),
                                ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      //Linha de controle do volume
                      children: <Widget>[
                        Text(
                          "Volume",
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                        Expanded(
                          child: Slider(
                            //Responsavel por controlar o volume
                            inactiveColor: Colors.transparent,
                            value: _volume,
                            min: 0.0,
                            max: 100.0,
                            divisions: 10,
                            label: '${(_volume).round()}',
                            //altera o valor de volume
                            onChanged: (value) {
                              setState(() {
                                _volume = value;
                              });
                              _controller.setVolume(_volume.round());
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        //Mostra o stado atual do video (Playing, Buffering, Paused...)
                        "Status: $_playerStatus",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        //Mostra o codigo dos erros
                        "Error Code: $_errorCode",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showThankYouDialog() {
    showDialog(
      //Mostra caixa de dialogo ao fim do video
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Video Ended"),
          content: Text("Thank you for trying the plugin!"),
        );
      },
    );
  }
}
