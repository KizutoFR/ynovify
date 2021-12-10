import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'music.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ynovify v2',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blueGrey[900],
      ),
      home: const MyHomePage(title: 'Ynovify'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _index = 0;
  bool _play=false;
  Duration? dureemax = Duration();
  Duration duree = Duration();
  final _player = AudioPlayer();
  double _timingValue =0;
  Duration _timingDuration = Duration();
  List<Music> myMusicList = [
    Music('YSL','Ninho','https://static.fnac-static.com/multimedia/Images/FR/NR/c8/53/d4/13915080/1540-1/tsp20211110173128/Jefe.jpg','https://wvv.33rapfr.com/wp-content/uploads/2021/12/Ninho-YSL.mp3'),
    Music('Tempête','SCH','https://images.genius.com/f8363c49c70651643f979dbf68b85db5.300x300x1.jpg','https://wvv.33rapfr.com/wp-content/uploads/2021/03/21-Temp%C3%AAte-Bonus.mp3'),
  ];

  @override
  void initState(){
    super.initState();
    _init();
  }


  Future<void> _init() async {
    _player.playbackEventStream.listen((event) {},
    onError: (Object e, StackTrace stackTrace){
      print('A stream error : $e');
    });

    _player.positionStream.listen((event) {
      _changeTimingDuration(event);
      _changeTimingValue(event.inSeconds.toDouble());
    },
     onError: (Object e, StackTrace stackTrace){
      print('A stream error : $e');
    });

    try {
      await _updateMusic();
    } catch (e) {
      print(e);
    }

  }

  void _playpause(){
    setState(() {
      _play = !_play;
      if (_play) {
        _player.play();
      } else {
        _player.pause();
      }
    });
  }

_updateMusic() async{
  try {
    await _player
          .setAudioSource(AudioSource.uri(Uri.parse(myMusicList[_index].urlSong)))
          .then((duration)=>{
            setState((){
              dureemax = duration;
            }
            )
          });
  } catch (e) {
    print('ERROOOOOOOOOOOOOR = $e');
  }
}

_changeTimingValue(double value){
  setState(() {
    _timingValue=value;
  });
}

_changeTimingDuration(Duration value){
  setState(() {
    _timingDuration = value;
  });
}


  void _nextMusic() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if(_index< myMusicList.length-1){
      _index++;
     }else{
       _index=0;
     }
    });
    print("changement de musique");
    _updateMusic();
  }

  void _prevMusic() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if(_index>0){ 
       _index--;
      }else{
        _index = myMusicList.length-1;
      }
    });
    _updateMusic();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title,style: const TextStyle(fontSize: 30)),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(  //widget Colum (peut contenir plusieurs children)
            mainAxisSize: MainAxisSize.min, //la colonne se rétrécit pour s'adapter (fit) aux children
            children: <Widget>[ // tableau de widget
                Image.network(myMusicList[_index].imagePath), // affiche une image avce url (peut contenir plusieur option tel que width, height, opacity, box-fit ..)
                ListTile( // une class qui contient généralement 1 à 3 ligne de texte ainsi qu'une icône de début ou de fin.
                title: Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 20), //apply padding to LTRB, L:Left, T:Top, R:Right, B:Bottom
                  child:Text(
                    myMusicList[_index].title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 35,color: Colors.white),
                  ),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 20), //apply padding to LTRB, L:Left, T:Top, R:Right, B:Bottom
                  child: Text(
                    myMusicList[_index].singer,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 25,color: Colors.white),),
                  ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                children: <Widget>[
                  IconButton(
                      icon: const Icon(Icons.skip_previous),
                      color: Colors.white,
                      iconSize: 40,
                      onPressed: _prevMusic,
                    ),

                    IconButton(
                      icon: _play?(const Icon(Icons.pause_circle)):(const Icon(Icons.play_circle)),           
                      color: Colors.white,
                      iconSize: 60,
                      onPressed:_playpause,
                    ),

                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      color: Colors.white,
                      iconSize: 40,
                      onPressed: _nextMusic,
                    ),
                ]
              ),
              Slider(
                value: _timingValue,
                min:0,
                max: _player.duration !=null? _player.duration!.inSeconds.toDouble() : _timingValue,
                onChanged: (double value) => _changeTimingValue(value),
                onChangeEnd: (double value) =>{
                  _player.seek(Duration(seconds: value.toInt()))
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                Text(
                    _timingDuration.toString().split('.')[0],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20,color: Colors.white),
                ),
                Text(
                    dureemax.toString().split('.')[0],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20,color: Colors.white),
                ),
                ]
              )
            ],
          ),
      ),
    );
  }
}
