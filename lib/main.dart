import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StopWatch(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StopWatch extends StatefulWidget {
  const StopWatch({super.key});

  @override
  State<StopWatch> createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  bool _started = false;
  List<String> _laps = [];

  void _start() {
    setState(() {
      _started = true;
    });
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (Timer timer) {
      if (_stopwatch.isRunning) {
        setState(() {}); // Update the UI
      }
    });
  }

  void _stop() {
    _stopwatch.stop();
    _timer?.cancel();
    setState(() {
      _started = false;
    });
  }

  void _reset() {
    _stopwatch.reset();
    _timer?.cancel();
    setState(() {
      _started = false;
      _laps.clear();
    });
  }

  void _addLap() {
    if (_stopwatch.isRunning) {
      final lapTime = _stopwatch.elapsed;
      final lapStr = _formatDuration(lapTime);
      setState(() {
        _laps.add(lapStr);
      });
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    final milliseconds = duration.inMilliseconds % 1000;

    final digitMinutes = minutes.toString().padLeft(2, '0');
    final digitSeconds = seconds.toString().padLeft(2, '0');
    final digitMilliseconds = (milliseconds ~/ 10).toString().padLeft(2, '0');

    return '$digitMinutes:$digitSeconds:$digitMilliseconds';
  }

  @override
  Widget build(BuildContext context) {
    final elapsedTime = _stopwatch.elapsed;
    final displayTime = _formatDuration(elapsedTime);

    return Scaffold(
      backgroundColor: Colors.black12,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Stopwatch',
                  style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  displayTime,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 82,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                height: 400,
                decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(9)),
                child: ListView.builder(
                    itemCount: _laps.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Lap ${index + 1}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Text(
                              '${_laps[index]}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            )
                          ],
                        ),
                      );
                    }),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: RawMaterialButton(
                    onPressed: () {
                      !_started ? _start() : _stop();
                    },
                    fillColor: Colors.white12,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    constraints: BoxConstraints(minHeight: 60),
                    shape:
                        StadiumBorder(side: BorderSide(color: Colors.white30)),
                    child: Text(
                      !_started ? 'Start' : 'Stop',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      _addLap();
                    },
                    color: Colors.white,
                    icon: Icon(Icons.flag, size: 30),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                      child: RawMaterialButton(
                    onPressed: () {
                      _reset();
                    },
                    fillColor: Colors.white12,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    constraints: BoxConstraints(minHeight: 60),
                    shape:
                        StadiumBorder(side: BorderSide(color: Colors.white30)),
                    child: Text(
                      'Reset',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
