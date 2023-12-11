import 'package:flutter_tts/flutter_tts.dart';

class SpeakServices {
   FlutterTts flutterTts = FlutterTts();

  play(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.6);
    await flutterTts.speak(text);
  }
}
