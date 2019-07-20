import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';

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
  Timer _timer;
  var _minutes = 0;
  bool running = false;

  _timerRunner(int timeInMinutes) async {
    var tid = timeInMinutes * 60;
    const oneSec = const Duration(seconds: 1);
    setState(() {
      running = !running;
    });
    if (running) {
      _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => setState(
          () {
            if (tid < 1) {
              timer.cancel();
            } else {
              _minutes = (tid / 60).floor();
              tid = tid - 1;
            }
          },
        ),
      );
    } else {
      _timer.cancel();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
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
                  ('${_minutes.toString()} minutes left'),
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
                  '3/4',
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
                  '6 today',
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
                  icon: running
                      ? Icon(Icons.stop)
                      : Icon(Icons.play_circle_outline),
                  label: running
                      ? Text(
                          "Stop",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.5,
                              fontSize: 18),
                        )
                      : Text(
                          "Start",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.5,
                              fontSize: 18),
                        ),
                  foregroundColor: Color.fromRGBO(209, 207, 235, 1),
                  backgroundColor: Color.fromRGBO(100, 95, 219, 1),
                  onPressed: () => (_timerRunner(25)),
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
}
