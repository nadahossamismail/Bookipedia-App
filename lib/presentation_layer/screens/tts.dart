import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bookipedia/app/api_constants.dart';
import 'package:bookipedia/data_layer/network/dio_factory.dart';
import 'package:bookipedia/data_layer/network/error_handler.dart';
import 'package:bookipedia/presentation_layer/widgets/alert_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

class TextToSpeech extends StatefulWidget {
  const TextToSpeech({super.key, required this.text});
  final String text;

  @override
  State<TextToSpeech> createState() => _TextToSpeechState();
}

class _TextToSpeechState extends State<TextToSpeech> {
  List<int> recordedData = [];
  bool isLoading = false;
  bool isPlaying = false;
  bool isFinished = false;
  StreamSubscription? _playerStatus;
  StreamSubscription? _audioStream;
  final player = AudioPlayer();
  late File recordedFile;
  var filePath = "";
  Duration? duration = Duration.zero;
  var audioLenght = 0;
  Duration? position = Duration.zero;

  @override
  void initState() {
    if (mounted) {
      initPlugin();
      createFile();
    }
    super.initState();
  }

  void createFile() async {
    var path = await getTemporaryDirectory();
    filePath = "${path.path}/recorded.wav";
    recordedFile = File(filePath);
  }

  @override
  void dispose() async {
    super.dispose();
    if (mounted) {
      _playerStatus?.cancel();
      _audioStream?.cancel();
      await player.stop();
      await player.release();
      if (await recordedFile.exists()) {
        recordedFile.delete();
      }
    }
  }

  Future<void> initPlugin() async {
    final dio = DioFactory.getDio();

    isLoading = true;
    try {
      Response response = await dio.get("/ai/tts",
          data: {"text": widget.text},
          options: Options(
            responseType: ResponseType.stream,
            headers: ApiHeaders.tokenHeader,
          ));

      _audioStream = response.data.stream.listen((Uint8List data) async {
        recordedData.addAll(data);
        log("received audio chunk");
      }, onDone: () async {
        await save(recordedData, 22050);
        await player.play(DeviceFileSource(filePath));
        duration = await player.getDuration();
        audioLenght = duration!.inSeconds;
        position = await player.getCurrentPosition();
        player.onDurationChanged.listen((newDuration) {
          setState(() {
            duration = newDuration;
          });
        });
        player.onPositionChanged.listen((newPosition) {
          if (newPosition.inSeconds == audioLenght) {
            setState(() {
              isFinished = true;
            });
          }
          setState(() {
            position = newPosition;
          });
        });
        setState(() {
          isLoading = false;
        });
      });
    } catch (e) {
      var faliure = ErrorHandler.handle(e).failure;
      AppAlertDialog(message: faliure.message);
    }
  }

  Future<void> save(List<int> data, int sampleRate) async {
    var channels = 1;

    int byteRate = ((16 * sampleRate * channels) / 8).round();

    var size = data.length;

    var fileSize = size + 36;

    Uint8List header = Uint8List.fromList([
      // "RIFF"
      82, 73, 70, 70,
      fileSize & 0xff,
      (fileSize >> 8) & 0xff,
      (fileSize >> 16) & 0xff,
      (fileSize >> 24) & 0xff,
      // WAVE
      87, 65, 86, 69,
      // fmt
      102, 109, 116, 32,
      // fmt chunk size 16
      16, 0, 0, 0,
      // Type of format
      1, 0,
      // One channel
      channels, 0,
      // Sample rate
      sampleRate & 0xff,
      (sampleRate >> 8) & 0xff,
      (sampleRate >> 16) & 0xff,
      (sampleRate >> 24) & 0xff,
      // Byte rate
      byteRate & 0xff,
      (byteRate >> 8) & 0xff,
      (byteRate >> 16) & 0xff,
      (byteRate >> 24) & 0xff,
      // Uhm
      ((16 * channels) / 8).round(), 0,
      // bitsize
      16, 0,
      // "data"
      100, 97, 116, 97,
      size & 0xff,
      (size >> 8) & 0xff,
      (size >> 16) & 0xff,
      (size >> 24) & 0xff,
      ...data
    ]);
    return recordedFile.writeAsBytesSync(header, flush: true);
  }

  String formateTime(int seconds) {
    var hhMmSs = "${(Duration(seconds: seconds))}".split(":");
    hhMmSs.removeAt(0);
    var mmSS = hhMmSs.join(":").split(".")[0];
    return mmSS;
  }

  @override
  Widget build(BuildContext context) {
    var playPauseReplay = isFinished
        ? Icons.replay
        : isPlaying
            ? Icons.play_arrow
            : Icons.pause;
    return Builder(builder: (_) {
      return Flushbar(
        icon: isLoading
            ? null
            : IconButton(
                padding: const EdgeInsets.only(left: 15),
                onPressed: () async {
                  setState(() {
                    isPlaying = !isPlaying;
                  });
                  if (!isFinished) {
                    isPlaying
                        ? await player.pause()
                        : await player.play(DeviceFileSource(filePath));
                  } else {
                    await player.stop();
                    await player.play(DeviceFileSource(filePath));
                    setState(() {
                      isFinished = false;
                      isPlaying = false;
                    });
                  }
                },
                icon: Icon(playPauseReplay, size: 26, color: Colors.white)),
        messageText: isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "This might take a few seconds",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  AnimatedTextKit(
                    isRepeatingAnimation: true,
                    repeatForever: true,
                    animatedTexts: [
                      WavyAnimatedText(
                        " ...",
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${formateTime(position!.inSeconds)}/${formateTime((duration! - position!).inSeconds)}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 160,
                    child: Slider(
                      value: position!.inSeconds.toDouble(),
                      onChanged: (value) {
                        final newPosition = Duration(seconds: value.toInt());
                        player.seek(newPosition);
                        player.resume();
                        setState(() {
                          isPlaying = false;
                        });
                      },
                      min: 0,
                      max: audioLenght.toDouble(),
                    ),
                  ),
                ],
              ),
        mainButton: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white)),
      );
    });
  }
}
