import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'PersonalDataUpdate.dart';
import 'SecondScreen.dart';

void main(){
  runApp(MaterialApp(
    home:ThirdScreen(),
  ));
}

class ThirdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Graphs'),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: (MediaQuery.of(context).size.height) / 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: (MediaQuery.of(context).size.width)/3,
                height: (MediaQuery.of(context).size.height) / 16,

                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  color: Colors.green,

                  borderRadius: BorderRadius.circular(1),
                ),
                child: Center(child: Text('You', style: TextStyle(fontSize: 20))),
              ),
              Container(
                width: (MediaQuery.of(context).size.width)/3,
                height: (MediaQuery.of(context).size.height) / 16,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  color: Colors.green,

                  borderRadius: BorderRadius.circular(1),
                ),
                child: Center(child: Text('Average User', style: TextStyle(fontSize: 20))),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: (MediaQuery.of(context).size.width)/3,
                height: (MediaQuery.of(context).size.height) / 5,
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(1),
                ),
                child: Column(
                  children: [
                    Container(
                      width: (MediaQuery.of(context).size.width)/3,
                      height: (MediaQuery.of(context).size.height) / 12,
                      decoration: BoxDecoration(
                        color: Colors.blue,

                        borderRadius: BorderRadius.circular(1),
                      ),
                      child: ListTile(title: Text('CalorieConsumption', style: TextStyle(fontSize: 10)),
                          subtitle: Text('2500')),// WILL BE SecondScreen.dataStore[index] later
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width)/3,
                      height: (MediaQuery.of(context).size.height) / 12,
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,


                      ),
                      child: Center(child: ListTile(
                        title: Text('DailyCalorieNeed',style: TextStyle(fontSize:10),),
                        subtitle: Text(PersonalDataUpdate.calorieNeedsWithActivity.toString()),
                      ),),
                    ),
                  ],
                ),
              ),
              Container(
                width: (MediaQuery.of(context).size.width)/3,
                height: (MediaQuery.of(context).size.height) / 5,
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(1),
                ),
                child: Column(
                  children: [
                    Container(
                      width: (MediaQuery.of(context).size.width)/3,
                      height: (MediaQuery.of(context).size.height) / 12,
                      decoration: BoxDecoration(
                        color: Colors.blue,

                        borderRadius: BorderRadius.circular(1),
                      ),
                      child: ListTile(title: Text('CalorieConsumption', style: TextStyle(fontSize: 10)),
                          subtitle: Text('2500')),
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width)/3,
                      height: (MediaQuery.of(context).size.height) / 12,
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,


                      ),
                      child: Center(child: ListTile(
                        title: Text('DailyCalorieNeed',style: TextStyle(fontSize:10),),
                        subtitle: Text(PersonalDataUpdate.calorieNeedsWithActivity.toString()),
                      ),),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: (MediaQuery.of(context).size.height) / 50,
          ),
          Container(
            child: Center(child: Text('Your Weekly Calorie')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                height: (MediaQuery.of(context).size.height)/3,
                width: (MediaQuery.of(context).size.width)/1.4,
                child: GroupedBarChart.withSampleData()),
          ),
          SizedBox(
            height: (MediaQuery.of(context).size.height) / 50,
          ),
          Container(
            child: Center(child: Text('Average Users Weekly Calorie')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                height: (MediaQuery.of(context).size.height)/3,
                width: (MediaQuery.of(context).size.width)/1.4,
                child: GroupedBarChart.withSampleData()),
          ),
        ],
      ),
    );
  }
}

class GroupedBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  GroupedBarChart(this.seriesList, {this.animate});

  factory GroupedBarChart.withSampleData() {
    return new GroupedBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.grouped,
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    SecondScreen.calorie=0; // When we use shared prefences, calorie will be determined in the SecondScreen and
    // instead of SecondScreen.calorie+2500 there will be just SecondScreen.dataStore[index]
    final CalorieTaken = [
      new OrdinalSales('M', SecondScreen.calorie+2500),
      new OrdinalSales('T', SecondScreen.calorie+2400),
      new OrdinalSales('W', SecondScreen.calorie+2600),
      new OrdinalSales('T', SecondScreen.calorie+2375),
      new OrdinalSales('F', SecondScreen.calorie+2900),
      new OrdinalSales('S', SecondScreen.calorie+2800),
      new OrdinalSales('S', SecondScreen.calorie+3000),
    ];


    final DailyCalorieNeeds = [
      new OrdinalSales('M', PersonalDataUpdate.calorieNeedsWithActivity),
      new OrdinalSales('T', PersonalDataUpdate.calorieNeedsWithActivity),
      new OrdinalSales('W', PersonalDataUpdate.calorieNeedsWithActivity),
      new OrdinalSales('T', PersonalDataUpdate.calorieNeedsWithActivity),
      new OrdinalSales('F', PersonalDataUpdate.calorieNeedsWithActivity),
      new OrdinalSales('S', PersonalDataUpdate.calorieNeedsWithActivity),
      new OrdinalSales('S', PersonalDataUpdate.calorieNeedsWithActivity),
    ];


    return [
      new charts.Series<OrdinalSales, String>(
        id: 'CalorieTaken',
        domainFn: (OrdinalSales sales, _) => sales.day,
        measureFn: (OrdinalSales sales, _) => sales.calorie,
        data: CalorieTaken,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'DailyCalorieNeeds',
        domainFn: (OrdinalSales sales, _) => sales.day,
        measureFn: (OrdinalSales sales, _) => sales.calorie,
        data: DailyCalorieNeeds,
      ),

    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  String day;
  double calorie;

  OrdinalSales(this.day, this.calorie);
}