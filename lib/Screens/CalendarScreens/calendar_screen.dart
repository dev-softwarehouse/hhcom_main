import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:hhcom/Screens/base_scaffold.dart';
import 'package:hhcom/Utils/utils.dart';

/// Show the calendar in this screen
class CalendarScreen extends StatefulWidget {
  CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        child: Padding(
      padding: EdgeInsets.only(top: Utils().safePaddingTop(context)),
      child: CalendarCarousel<Event>(
        onDayPressed: (date, events) {
          this.setState(() => _currentDate = date);
          events.forEach((event) => print(event.title));
        },
        weekendTextStyle: TextStyle(
          color: Colors.red,
        ),
        thisMonthDayBorderColor: Colors.grey,
        selectedDateTime: _currentDate,
        showIconBehindDayText: true,
        customGridViewPhysics: NeverScrollableScrollPhysics(),
        markedDateShowIcon: true,
        markedDateIconMaxShown: 2,
        selectedDayTextStyle: TextStyle(
          color: Colors.white,
        ),
        todayTextStyle: TextStyle(
          color: Colors.blue,
        ),
        markedDateIconBuilder: (event) {
          return event.icon ?? Icon(Icons.help_outline);
        },
        minSelectedDate: _currentDate.subtract(Duration(days: 360)),
        maxSelectedDate: _currentDate.add(Duration(days: 360)),
        todayButtonColor: Colors.transparent,
        todayBorderColor: Colors.green,
        markedDateMoreShowTotal: true,
      ),
    ));
  }
}
