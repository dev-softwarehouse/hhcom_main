import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hhcom/Models/enum/enums.dart';
import 'package:hhcom/Utils/Constant/constant.dart';
import 'package:hhcom/Utils/Constant/constant_widget.dart';
import 'package:hhcom/Utils/app_theme.dart';
import 'package:hhcom/widget/warning_dialog.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class DateTimeSelection extends StatefulWidget {
  Function doneButtonPressed;
  DateTime? oldSelectedDateTime;

  DateTimeSelection({required this.doneButtonPressed, this.oldSelectedDateTime});

  @override
  State<DateTimeSelection> createState() => _DateTimeSelectionState();
}

class _DateTimeSelectionState extends State<DateTimeSelection> {
  DateTime _currentDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  List<String> weekDay = ["Pn", "Wt", "Śr", "Czw", "Pt", "Sb", "Ndz"];

  Widget timeDisplay(String time) {
    return Container(
      width: 75,
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.symmetric(horizontal: BorderSide(color: Color(0xFF999999))),
      ),
      child: Text(
        time,
        textAlign: TextAlign.center,
        style: TextStyles.timeHeader,
      ),
    );
  }

  Widget nextPrevArrow({bool isLeft = true}) {
    return Icon(
      (isLeft) ? Icons.chevron_left : Icons.chevron_right,
      color: Colors.black,
      size: 42,
    );
  }

  Color get borderColor {
    return Color(0xffBBBBBB);
  }

  Color get selectedDateBorderColor {
    return Color(0xffFFADAD);
  }

  Color get selectedDateBackgroundColor {
    return Color(0xffFFE1E1);
  }

  String _currentHr = defaultTimeHrMin;
  String _currentMin = defaultTimeHrMin;

  @override
  void initState() {
    super.initState();
    if (widget.oldSelectedDateTime != null) {
      _selectedDate = widget.oldSelectedDateTime!;
      _currentMin = DateFormat.m().format(widget.oldSelectedDateTime!);
      _currentHr = DateFormat.H().format(widget.oldSelectedDateTime!);
    }
  }

  void showTimePicker() {
    DateTime selectedTime;

    if (_currentHr == defaultTimeHrMin && _currentMin == defaultTimeHrMin) {
      if (widget.oldSelectedDateTime != null) {
        selectedTime = widget.oldSelectedDateTime!;
      } else {
        selectedTime = DateTime.now();
      }
    } else {
      selectedTime = DateFormat("HH:mm").parse(_currentHr + ":" + _currentMin);
    }
    DatePicker.showTimePicker(context, currentTime: selectedTime, locale: LocaleType.pl, showSecondsColumn: false, onConfirm: (dateTime) {
      String formattedTime = DateFormat.Hm().format(dateTime);
      setState(() {
        _currentMin = DateFormat.m().format(dateTime);
        _currentHr = DateFormat.H().format(dateTime);
      });

      print(formattedTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.doneButtonPressed(null);
        return false;
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 5.0,
        color: Color(0xFFEEEEEE),
        child: Container(
          constraints: BoxConstraints(maxWidth: 80.w, maxHeight: 75.h),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        color: Color(0xFFEEEEEE),
                        constraints: BoxConstraints(maxWidth: 65.w, maxHeight: 42.h),
                        child: CalendarCarousel<Event>(
                          onDayPressed: (date, events) {
                            print(date);
                            setState(() {
                              _selectedDate = date;
                            });
                          },
                          weekendTextStyle: TextStyles.calendarDateHeader,
                          dayPadding: 5.0,
                          headerTextStyle: TextStyles.calendarMonthHeader,
                          leftButtonIcon: nextPrevArrow(),
                          rightButtonIcon: nextPrevArrow(isLeft: false),

                          thisMonthDayBorderColor: borderColor,
                          selectedDateTime: _selectedDate,
                          showIconBehindDayText: true,
                          customGridViewPhysics: NeverScrollableScrollPhysics(),
                          markedDateShowIcon: false,
                          daysTextStyle: TextStyles.calendarDateHeader,
                          weekDayMargin: EdgeInsets.all(5),
                          weekDayPadding: EdgeInsets.all(5),
                          customWeekDayBuilder: (index, day) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 20.0),
                              child: Text(
                                weekDay[index],
                                style: TextStyles.calendarWeekHeader,
                              ),
                            );
                          },
                          markedDateIconMaxShown: 2,
                          selectedDayTextStyle: TextStyles.calendarDateHeader,
                          todayTextStyle: TextStyles.calendarDateHeader,
                          minSelectedDate: _currentDate.subtract(Duration(days: 360)),
                          maxSelectedDate: _currentDate.add(Duration(days: 360)),
                          todayButtonColor: Colors.transparent,
                          todayBorderColor: borderColor,
                          selectedDayBorderColor: selectedDateBorderColor,
                          selectedDayButtonColor: selectedDateBackgroundColor,
                          markedDateMoreShowTotal: false,
                          //locale: "pl_PL",// -> shows pon. but design has pn
                          daysHaveCircularBorder: false,
                          nextDaysTextStyle: TextStyle(color: Colors.transparent),
                          prevDaysTextStyle: TextStyle(color: Colors.transparent),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: showTimePicker,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              timeDisplay(_currentHr),
                              Text(
                                timeSeparator,
                                textAlign: TextAlign.center,
                                style: TextStyles.timeHeader,
                              ),
                              timeDisplay(_currentMin),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          customIcon(size: 8, icon: time_select_appointment),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: customTextButton(
                      cornerRadius: 15,
                      height: 12,
                      width: 25,
                      btnText: saveDateTimeBtnHeader,
                      onTap: () {
                        if (_currentHr == defaultTimeHrMin && _currentMin == defaultTimeHrMin) {
                          WarningMessageDialog.showDialog(context, notTimeSelectedErrMsg, type: MsgType.error);
                          Future.delayed(Duration(seconds: 3), showTimePicker);
                        } else {
                          DateTime dateTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, int.parse(_currentHr), int.parse(_currentMin));
                          widget.doneButtonPressed(dateTime);
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
