import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45); // Slightly slower for clarity
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    _tts.setErrorHandler((message) {
      debugPrint('[TTS] Error: $message');
    });

    _isInitialized = true;
  }

  Future<void> speak(String text) async {
    await init();
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> speakSentence(List<String> words) async {
    final sentence = words.join(' ');
    await speak(sentence);
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  Future<void> setRate(double rate) async {
    await _tts.setSpeechRate(rate.clamp(0.1, 1.0));
  }

  Future<void> setPitch(double pitch) async {
    await _tts.setPitch(pitch.clamp(0.5, 2.0));
  }

  Future<List<dynamic>> getAvailableVoices() async {
    return await _tts.getVoices ?? [];
  }

  Future<void> setVoice(Map<String, String> voice) async {
    await _tts.setVoice(voice);
  }
}
