import 'package:common_utils/common_utils.dart';
import 'package:date_wheel_plugin/date_wheel_plugin.dart';
import 'package:date_wheel_plugin/model/date_wheel_response.dart';
import 'package:date_wheel_plugin/utils/date_utils.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: '日期选择器'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  DateWheelResponse dateResponse;
  final String title;
  MyHomePage({Key key, this.title}) {
    if (ObjectUtil.isEmpty(dateResponse)) {
      String startTime = DateUtils.getBeforeCurrentYMD(90);
      String endTime = DateUtils.getCurrentYMD();
      dateResponse = DateWheelResponse(startTime, endTime, minDate: "2018-10-31", maxDate: "2021-01-01");
    }
  }
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(
          '${widget.dateResponse.startTime}-${widget.dateResponse.endTime}',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showDateBottomSheet,
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void showDateBottomSheet() async {
    DateWheelResponse tempResult = await showModalBottomSheet<DateWheelResponse>(
      context: context,
      isDismissible: true,
      builder: (_) {
        return DateWheelPlugin(widget.dateResponse);
      },
    );

    if (ObjectUtil.isEmpty(tempResult)) {
      return;
    }
    setState(() {
      widget.dateResponse = tempResult;
    });
  }
}
