
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'Tasks/Task.dart';
import 'package:time_visualiser/Tasks/Occurrence.dart';
import 'package:time_visualiser/User/User.dart';


class WeekView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyWeekView(title: 'Time management app'),
    );
  }
}

// it always has to add up to 24 hrs
// if I work 3 hrs then 21 hrs are free
// and if I study another 2hrs then 19hrs are free and so on

class MyWeekView extends StatefulWidget {
  MyWeekView({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyWeekViewState createState() => _MyWeekViewState();
}

class _MyWeekViewState extends State<MyWeekView> {
  List<List<TaskData>> listOfAllDays = [];

  void createAllTaskData() {
    User myUser = MyHomePage.theUser;
    
    for (int i = 0; i < 7; i++) {
      List<TaskData> listOfDayTasks = [];
      for (Task task in myUser.tasks) {
        for (Occurrence occurs in task.occurrence) {
          if (occurs.daysPerWeek.contains(i)) {
            int time = occurs.time[1].hour - occurs.time[0].hour;
            listOfDayTasks.add(new TaskData('task.name', time));
            print("Hello: " + time.toString() + " " + task.name + " " + i.toString());
          }
        }
      }
      int count = 0;
      for (TaskData data in listOfDayTasks) {
        print("Hello again");
        count += data.time;
      }
      int freeTime = 24 - count;
      print(freeTime.toString() + " time");
      listOfDayTasks.add(new TaskData('Free', freeTime));
      listOfAllDays.add(listOfDayTasks);
    }
    setState() {
      build(context);
    }
  }

  List<charts.Series<TaskData, int>> _createSampleData() {
    createAllTaskData();
    final data = listOfAllDays[0];

    return [
      new charts.Series<TaskData, int>(
        id: 'Sales',
        domainFn: (TaskData sales, _) => sales.time,
        measureFn: (TaskData sales, _) => sales.time,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Container(
          child: DonutPieChart(_createSampleData()),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            );
        },
      ),
   );
  }
}

class DonutPieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DonutPieChart(this.seriesList, {this.animate});

  /// Creates a [PieChart] with sample data and no transition.
  factory DonutPieChart.withSampleData() {
    return new DonutPieChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
        // Configure the width of the pie slices to 60px. The remaining space in
        // the chart will be left as a hole in the center.
        defaultRenderer: new charts.ArcRendererConfig(arcWidth: 500));
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TaskData, int>> _createSampleData() {
    final data = [
      new TaskData("Work", 200),
      new TaskData("Exercise", 75),
      new TaskData("Study", 25),
      new TaskData("Chill", 5),
    ];

    return [
      new charts.Series<TaskData, int>(
        id: 'Sales',
        domainFn: (TaskData sales, _) => sales.time,
        measureFn: (TaskData sales, _) => sales.time,
        data: data,
      )
    ];
  }
}

/// Sample linear data type.
class TaskData {
  final String name;
  final int time;

  TaskData(this.name, this.time);
}















