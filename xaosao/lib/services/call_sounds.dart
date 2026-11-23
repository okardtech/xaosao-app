import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

/// The sounds of a call: the model's ringtone, the customer's ringback,
/// and the click on mute.
///
/// The tones are synthesized files in `assets/sounds/` (no licensed audio).
class CallSounds {
  CallSounds._();

  static AudioPlayer? _player;
  static String? _playing;

  /// Ringtone for an incoming call, on the ringtone channel so it follows
  /// the phone's ring volume rather than the media volume.
  static Future<void> playRingtone() => _loop(
        'sounds/ringtone.wav',
        AudioContext(
          android: const AudioContextAndroid(
            contentType: AndroidContentType.sonification,
            usageType: AndroidUsageType.notificationRingtone,
            audioFocus: AndroidAudioFocus.gainTransient,
          ),
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: const {AVAudioSessionOptions.duckOthers},
          ),
        ),
      );

  /// Ringback while the customer waits for her to answer.
  ///
  /// The customer is already in the call room with the microphone open, so
  /// this must not take the audio session away from WebRTC: on iOS it joins
  /// the same play-and-record session, and on Android it asks for no focus.
  static Future<void> playRingback() => _loop(
        'sounds/ringback.wav',
        AudioContext(
          android: const AudioContextAndroid(
            audioMode: AndroidAudioMode.inCommunication,
            contentType: AndroidContentType.speech,
            usageType: AndroidUsageType.voiceCommunicationSignalling,
            audioFocus: AndroidAudioFocus.none,
          ),
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playAndRecord,
            options: const {
              AVAudioSessionOptions.mixWithOthers,
              AVAudioSessionOptions.allowBluetooth,
            },
          ),
        ),
      );

  static Future<void> _loop(String asset, AudioContext context) async {
    if (_playing == asset) return;
    await stop();
    try {
      final player = AudioPlayer();
      _player = player;
      _playing = asset;
      await player.setAudioContext(context);
      await player.setReleaseMode(ReleaseMode.loop);
      await player.play(AssetSource(asset));
    } catch (_) {
      // A missing sound must never break a call.
      _playing = null;
    }
  }

  static Future<void> stop() async {
    final player = _player;
    _player = null;
    _playing = null;
    if (player == null) return;
    try {
      await player.stop();
      await player.dispose();
    } catch (_) {}
  }

  /// The feedback on mute / unmute: a short vibration and a click.
  static void toggleFeedback() {
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.click);
  }
}
