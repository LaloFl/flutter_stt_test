import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stts;
import './utils/stt_commands.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Speech To Text Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Speech To Text'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _speech = stts.SpeechToText();
  bool isListening = false;
  String text = "";
  String localeId = "es_MX";
  // String localeId = "en_US";

  double sumar(Iterable values) {
    return values.reduce((a, b) => a + b);
  }

  void listen() async {
    if (!isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          print(status);
          if (status == "not listening") {
            isListening = false;
          }
        },
        onError: (error) => print(error),
      );
      if (available) {
        setState(() {
          isListening = true;
        });
        _speech.listen(
          localeId: localeId,
          listenMode: stts.ListenMode.dictation,
          listenFor: const Duration(seconds: 10),
          onResult: (result) => setState(() {
            text = result.recognizedWords;
          }),
        );
      }
    } else {
      setState(() {
        isListening = false;
        _speech.stop();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _speech = stts.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    List<String> parsedStrList =
        text.replaceAll(",", "").replaceAll("\$", "").toLowerCase().split(" ");

    String mainCmd = "";
    String execCmd = "";

    // GET MAIN COMMAND
    for (var cmd in mainCmds.values) {
      if (parsedStrList.any((element) {
        mainCmd = element;
        return cmd["alias"].contains(element);
      })) {
        print("main command recognized $mainCmd");
      }

      // GET KEY OF MAIN COMMAND
      for (var key in mainCmds.keys) {
        if (mainCmds[key]["alias"].contains(mainCmd)) {
          mainCmd = key;
          print("main command key recognized $key");
        }
      }
    }

    // GET EXEC COMMAND
    for (var cmd in execCmds.values) {
      if (parsedStrList.any((element) {
        execCmd = element;
        return cmd["alias"].contains(element);
      })) {
        print("exec command recognized $execCmd");
      }

      // GET KEY OF EXEC COMMAND
      for (var key in execCmds.keys) {
        if (execCmds[key]["alias"].contains(execCmd)) {
          execCmd = key;
          print("exec command key recognized $key");
        }
      }
    }

    // GET ARGS FOR EXEC COMMAND
    List<String> args = [];
    for (var i = 0; i < parsedStrList.length; i++) {
      if (double.tryParse(parsedStrList[i]) != null) {
        args.add(parsedStrList[i]);
      }
    }
    print("args: $args");

    // FINAL COMMAND WITH ARGS
    String finalCmd = "$mainCmd $execCmd $args";
    print(finalCmd);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Row(
            children: [
              Text(localeId == "es_MX" ? "ES" : "EN"),
              Switch(
                value: "en_US" == localeId,
                activeColor: Theme.of(context).colorScheme.onBackground,
                onChanged: (bool value) {
                  setState(() {
                    localeId = localeId == "es_MX" ? "en_US" : "es_MX";
                  });
                },
              ),
            ],
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 40),
            Text(
              "CMD: $finalCmd",
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        repeat: true,
        endRadius: 80,
        duration: const Duration(milliseconds: 1200),
        glowColor: Theme.of(context).primaryColor,
        child: FloatingActionButton(
          onPressed: listen,
          tooltip: 'Activate Speech To Text',
          child: Icon(isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
    );
  }
}
