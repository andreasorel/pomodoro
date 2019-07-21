import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'pomodoro'),
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
  Timer timer;
  Stopwatch _watch = new Stopwatch();

  String _elapsedTime = '';

  @override
  void dispose() {
    _watch.stop();
    super.dispose();
  }

  PageController controller = PageController();
  var currentPageValue = 0.0;

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      setState(() {
        currentPageValue = controller.page;
      });
    });
    return Scaffold(
      backgroundColor: Color.fromRGBO(117, 112, 237, 1),
      appBar: _buildAppBar(),
      body: _buildWindow(),
    );
  }

  Column _buildWindow() {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 10,
          child: PageView(
            physics: BouncingScrollPhysics(),
            controller: controller,
            children: <Widget>[
              _buildTimerView(),
              _buildCalendarView(),
              _buildTimerView(),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: DotsIndicator(
            dotsCount: 3,
            position: currentPageValue.toInt(),
            decorator: DotsDecorator(
              color: Color.fromRGBO(100, 95, 219, 1),
              activeColor: Color.fromRGBO(209, 207, 235, 1),
            ),
          ),
        )
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Color.fromRGBO(124, 119, 242, 1),
      title: Text(
        widget.title,
        style: TextStyle(
          fontFamily: "Montserrat",
          color: Color.fromRGBO(229, 227, 255, 1),
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      leading: Container(
        child: InkWell(
          child: Icon(
            Icons.menu,
            color: Color.fromRGBO(182, 178, 255, 1),
            size: 25,
          ),
          onTap: () => (print("object")),
        ),
      ),
      actions: <Widget>[
        Container(
          padding: EdgeInsets.only(right: 15),
          child: Icon(
            Icons.calendar_today,
            color: Color.fromRGBO(182, 178, 255, 1),
            size: 25,
          ),
        ),
      ],
      elevation: 0,
    );
  }

  Container _buildTimerView() {
    bool running = _watch.isRunning;
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            flex: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  ('$_elapsedTime'),
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontFamily: "Montserrat",
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w500),
                ),
                Divider(
                  height: 10,
                  color: Colors.transparent,
                ),
                Text(
                  '0/4',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromRGBO(229, 227, 255, 1),
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w400,
                    letterSpacing: 5,
                  ),
                ),
                Divider(
                  height: 10,
                  color: Colors.transparent,
                ),
                Text(
                  '0 today',
                  style: TextStyle(
                      fontSize: 20,
                      color: Color.fromRGBO(229, 227, 255, 1),
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.5),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton.extended(
                  icon: _watch.isRunning
                      ? Icon(Icons.stop)
                      : Icon(_watch.elapsedMilliseconds > 0
                          ? Icons.refresh
                          : Icons.play_circle_outline),
                  label: _watch.isRunning
                      ? Text(
                          "Stop",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.5,
                              fontSize: 18),
                        )
                      : Text(
                          _watch.elapsedMilliseconds > 0 ? "Reset" : "Start",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.5,
                              fontSize: 18),
                        ),
                  foregroundColor: Color.fromRGBO(209, 207, 235, 1),
                  backgroundColor: Color.fromRGBO(100, 95, 219, 1),
                  onPressed: () => (checkTimerState()),
                  elevation: 3,
                  hoverElevation: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _buildCalendarView() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            child: Text("side 2"),
          )
        ],
      ),
    );
  }

  checkTimerState() {
    if (_watch.isRunning) {
      _watch.stop();
      setTime();
    } else if (!_watch.isRunning && _watch.elapsedMilliseconds > 0) {
      _watch.reset();
      setTime();
    } else {
      _watch.start();
      timer = new Timer.periodic(
        Duration(milliseconds: 500),
        updateTime,
      );
    }
  }

  updateTime(Timer timer) {
    if (_watch.isRunning) {
      setState(() {
        _elapsedTime = transformMilliseconds(_watch.elapsedMilliseconds);
      });
    }
  }

  setTime() {
    var currentTime = _watch.elapsedMilliseconds;
    setState(() {
      _elapsedTime = transformMilliseconds(currentTime);
    });
  }

  transformMilliseconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }
}
