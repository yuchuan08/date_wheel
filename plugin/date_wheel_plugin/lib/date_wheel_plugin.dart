import 'package:common_utils/common_utils.dart';
import 'package:date_wheel_plugin/utils/date_utils.dart';
import 'package:flutter/cupertino.dart' as ios;
import 'package:flutter/material.dart';

import 'model/date_wheel_response.dart';

class DateWheelPlugin extends StatefulWidget {
  DateWheelResponse dateResponse;
  DateWheelPlugin(this.dateResponse);
  @override
  _DateWheelPluginState createState() => _DateWheelPluginState();
}

class _DateWheelPluginState extends State<DateWheelPlugin> {
  FixedExtentScrollController yearController;
  FixedExtentScrollController monthController;
  FixedExtentScrollController dayController;
  Key monthKey;
  Key dayKey;
  List<int> yearList;
  List<int> monthList;
  List<int> dayList;
  int currentYear;
  int currentMonth;
  int currentDay;
  bool isShowStartDay = false;
  String showStartDayStr;
  bool isShowEndDay = false;
  String showEndDayStr;
  DateWheelResponse dateResponse;

  @override
  void initState() {
    super.initState();
    if (ObjectUtil.isEmpty(widget.dateResponse.minDate)) {
      widget.dateResponse.minDate = DateUtils.getBeforeCurrentYMD(10 * 365);
    }
    if (ObjectUtil.isEmpty(widget.dateResponse.maxDate)) {
      widget.dateResponse.maxDate = DateUtils.getCurrentYMD();
    }
    dateResponse = DateWheelResponse(widget.dateResponse.startTime, widget.dateResponse.endTime,
        minDate: widget.dateResponse.minDate, maxDate: widget.dateResponse.maxDate);
    showStartDayStr = dateResponse.startTime;
    isShowStartDay = false;
    showEndDayStr = dateResponse.endTime;
    isShowEndDay = false;
    monthKey = UniqueKey();
    dayKey = UniqueKey();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {},
      onVerticalDragStart: (_) {},
      child: Container(
        color: Color(0xffffffff),
        child: _getBody(),
      ),
    );
  }

  Widget _getBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: onCancel,
              child: Container(
                margin: EdgeInsets.only(
                  left: 18,
                  top: 18,
                ),
                child: Text(
                  "取消",
                  style: TextStyle(color: Colors.black, fontSize: 13),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 18),
              child: Text(
                "时间筛选",
                style: TextStyle(color: Color(0xff1a8cf3), fontSize: 16),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: onConfirm,
              child: Container(
                  margin: EdgeInsets.only(
                    right: 18,
                    top: 18,
                  ),
                  child: Text(
                    "完成",
                    style: TextStyle(color: Color(0xff1a8cf3), fontSize: 13),
                  )),
            ),
          ],
        ),
        _getDateChoose(),
      ],
    );
  }

  /**
   *@author:yuchuan
   *@time:2020/3/24 17:53
   *@description:按日选择
   *@param:
   *@return:
   */
  Widget _getDateChoose() {
    if (isShowStartDay) {
      showStartDayStr =
          "${currentYear}-${currentMonth < 10 ? ("0" + currentMonth.toString()) : currentMonth}-${currentDay < 10 ? ("0" + currentDay.toString()) : currentDay}";
    }
    Widget startDateWidget = _getYMDWidget(isShowStartDay);
    if (isShowEndDay) {
      showEndDayStr =
          "${currentYear}-${currentMonth < 10 ? ("0" + currentMonth.toString()) : currentMonth}-${currentDay < 10 ? ("0" + currentDay.toString()) : currentDay}";
    }
    Widget endDateWidget = _getYMDWidget(isShowEndDay);
    return Container(
      height: 180,
      margin: EdgeInsets.only(top: 25),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (!isShowStartDay) {
                      isShowStartDay = true;
                      isShowEndDay = false;
                      dateResponse.endTime = showEndDayStr;
                      initData();
                    }
                  },
                  child: Text(
                    showStartDayStr,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: isShowStartDay ? Color(0xff1a8cf3) : Color(0xff000000), fontSize: 16),
                  ),
                ),
              ),
              Text(
                "至",
                style: TextStyle(color: Color(0xff000000), fontSize: 16),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (!isShowEndDay) {
                      isShowEndDay = true;
                      isShowStartDay = false;
                      dateResponse.startTime = showStartDayStr;
                      initData();
                    }
                  },
                  child: Text(
                    showEndDayStr,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: isShowEndDay ? Color(0xff1a8cf3) : Color(0xff000000), fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
          _getUnderLine(),
          startDateWidget,
          endDateWidget
        ],
      ),
    );
  }

  /**
   *@author:yuchuan
   *@time:2020/3/30 13:55
   *@description:年月日时间滚轮
   *@param:
   *@return:
   */
  Widget _getYMDWidget(bool isShow) {
    if (!isShow) {
      return Container();
    }
    return Expanded(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: ios.CupertinoPicker.builder(
            backgroundColor: Colors.white,
            itemExtent: 44,
            useMagnifier: true,
            childCount: yearList.length,
            itemBuilder: (context, index) {
              return _getSpinnerItem("${yearList[index]}年", true);
            },
            onSelectedItemChanged: (pos) {
              currentYear = yearList[pos];
              monthList = getMonthList(currentYear);
              int indexMonth = 0;
              for (int i = 0; i < monthList.length; i++) {
                if (currentMonth == monthList[i]) {
                  indexMonth = i;
                }
              }
              monthController = FixedExtentScrollController(initialItem: indexMonth);
              currentMonth = monthList[indexMonth];
              dayList = getDayList(currentYear, currentMonth);
              int indexDay = 0;
              for (int i = 0; i < dayList.length; i++) {
                if (currentDay == dayList[i]) {
                  indexDay = i;
                  break;
                }
              }
              dayController = FixedExtentScrollController(initialItem: indexDay);
              currentDay = dayList[indexDay];
              setState(() {
                monthKey = UniqueKey();
                dayKey = UniqueKey();
              });
            },
            scrollController: yearController,
          ),
        ),
        Expanded(
          child: ios.CupertinoPicker.builder(
            key: monthKey,
            backgroundColor: Colors.white,
            itemExtent: 44,
            useMagnifier: true,
            childCount: monthList.length,
            itemBuilder: (context, index) {
              return _getSpinnerItem("${monthList[index]}月", false);
            },
            onSelectedItemChanged: (pos) {
              currentMonth = monthList[pos];
              dayList = getDayList(currentYear, currentMonth);
              int indexDay = 0;
              for (int i = 0; i < dayList.length; i++) {
                if (currentDay == dayList[i]) {
                  indexDay = i;
                  break;
                }
              }
              dayController = FixedExtentScrollController(initialItem: indexDay);
              currentDay = dayList[indexDay];
              setState(() {
                dayKey = GlobalKey();
              });
            },
            scrollController: monthController,
          ),
        ),
        Expanded(
          child: ios.CupertinoPicker.builder(
            key: dayKey,
            backgroundColor: Colors.white,
            itemExtent: 44,
            useMagnifier: true,
            childCount: dayList.length,
            itemBuilder: (context, index) {
              return _getSpinnerItem("${dayList[index]}日", false);
            },
            onSelectedItemChanged: (pos) {
              setState(() {
                currentDay = dayList[pos];
              });
            },
            scrollController: dayController,
          ),
        )
      ],
    ));
  }

  /**
   *@author:yuchuan
   *@time:2020/3/30 14:03
   *@description:下滑横线
   *@param:
   *@return:
   */
  Widget _getUnderLine() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: 1,
            width: double.infinity,
            color: Color(0xffdbdbdb),
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 9),
          ),
        ),
        Container(width: 12),
        Expanded(
          child: Container(
            height: 1,
            width: double.infinity,
            color: Color(0xffdbdbdb),
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 9),
          ),
        ),
      ],
    );
  }

  Widget _getSpinnerItem(String value, bool leftOne) {
    return Container(
      padding: leftOne ? EdgeInsets.only(right: 7.5) : EdgeInsets.only(left: 7.5),
      alignment: Alignment.center,
      child: Text(
        value,
        style: TextStyle(color: Color(0xff333333), fontSize: 16),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    yearController?.dispose();
    monthController?.dispose();
    dayController?.dispose();
  }

  /**
   *@author:yuchuan
   *@time:1/29/21 3:20 PM
   *@description:获取所有年份数组
   *@param:
   *@return:
   */
  List<int> getYearList() {
    List<String> minDateArray = dateResponse.minDate.split("-");
    List<String> maxDateArray = dateResponse.maxDate.split("-");
    int minYear = int.parse(minDateArray[0]);
    int maxYear = int.parse(maxDateArray[0]);
    List<int> yearList = [];
    for (int i = minYear; i <= maxYear; i++) {
      yearList.add(i);
    }
    return yearList;
  }

  /**
   *@author:yuchuan
   *@time:1/29/21 3:21 PM
   *@description:根据年份获取其所有月份数组
   *@param:
   *@return:
   */
  List<int> getMonthList(int currentYear) {
    List<String> minDateArray = dateResponse.minDate.split("-");
    List<String> maxDateArray = dateResponse.maxDate.split("-");
    List<int> monthList = [];
    if (int.parse(minDateArray[0]) == int.parse(maxDateArray[0])) {
      for (int month = int.parse(minDateArray[1]); month <= int.parse(maxDateArray[1]); month++) {
        monthList.add(month);
      }
      return monthList;
    }
    if (currentYear == int.parse(minDateArray[0])) {
      for (int month = int.parse(minDateArray[1]); month <= 12; month++) {
        monthList.add(month);
      }
      return monthList;
    }
    if (currentYear == int.parse(maxDateArray[0])) {
      for (int month = 1; month <= int.parse(maxDateArray[1]); month++) {
        monthList.add(month);
      }
      return monthList;
    }
    for (int month = 1; month <= 12; month++) {
      monthList.add(month);
    }
    return monthList;
  }

  /**
   *@author:yuchuan
   *@time:1/29/21 3:35 PM
   *@description:根据年份和月份获取其所有天数数组
   *@param:
   *@return:
   */
  List<int> getDayList(int year, int month) {
    List<String> minDateArray = dateResponse.minDate.split("-");
    List<String> maxDateArray = dateResponse.maxDate.split("-");
    int minYear = int.parse(minDateArray[0]);
    int minMonth = int.parse(minDateArray[1]);
    int minDay = int.parse(minDateArray[2]);
    int maxYear = int.parse(maxDateArray[0]);
    int maxMonth = int.parse(maxDateArray[1]);
    int maxDay = int.parse(maxDateArray[2]);
    List<int> dayList = [];
    if (minYear == maxYear) {
      if (minMonth == maxMonth) {
        for (int index = minDay; index <= maxDay; index++) {
          dayList.add(index);
        }
        return dayList;
      }
      if (month <= minMonth) {
        for (int index = minDay; index <= getDaysByMonth(year, month); index++) {
          dayList.add(index);
        }
        return dayList;
      }
      if (month >= maxMonth) {
        for (int index = 1; index <= maxDay; index++) {
          dayList.add(index);
        }
        return dayList;
      }
      for (int index = 1; index <= getDaysByMonth(year, month); index++) {
        dayList.add(index);
      }
      return dayList;
    }
    if (year <= minYear) {
      if (month <= minMonth) {
        for (int index = minDay; index <= getDaysByMonth(year, month); index++) {
          dayList.add(index);
        }
        return dayList;
      } else {
        for (int index = 1; index <= getDaysByMonth(year, month); index++) {
          dayList.add(index);
        }
        return dayList;
      }
    } else if (year >= maxYear) {
      if (month >= maxMonth) {
        for (int index = 1; index <= maxDay; index++) {
          dayList.add(index);
        }
        return dayList;
      } else {
        for (int index = 1; index <= getDaysByMonth(year, month); index++) {
          dayList.add(index);
        }
        return dayList;
      }
    } else {
      for (int index = 1; index <= getDaysByMonth(year, month); index++) {
        dayList.add(index);
      }
      return dayList;
    }
  }

  int getDaysByMonth(int year, int month) {
    int totalDays = 0;
    switch (month) {
      case 1:
      case 3:
      case 5:
      case 7:
      case 8:
      case 10:
      case 12:
        totalDays = 31;
        break;
      case 4:
      case 6:
      case 9:
      case 11:
        totalDays = 30;
        break;
      case 2:
        if (DateUtil.isLeapYearByYear(year)) {
          totalDays = 29;
        } else {
          totalDays = 28;
        }
        break;
    }
    return totalDays;
  }

  /**
   *@author:yuchuan
   *@time:1/29/21 3:19 PM
   *@description:初始化数据
   *@param:
   *@return:
   */
  void initData() {
    showStartDayStr = dateResponse.startTime;
    showEndDayStr = dateResponse.endTime;
    List<String> startDateArray = showStartDayStr.split("-");
    List<String> endDateArray = showEndDayStr.split("-");
    int startYear = int.parse(startDateArray[0]);
    int endYear = int.parse(endDateArray[0]);
    int startMonth = int.parse(startDateArray[1]);
    int endMonth = int.parse(endDateArray[1]);
    if (isShowStartDay) {
      currentYear = startYear;
      currentMonth = startMonth;
      currentDay = int.parse(startDateArray[2]);
    }
    if (isShowEndDay) {
      currentYear = endYear;
      currentMonth = endMonth;
      currentDay = int.parse(endDateArray[2]);
    }
    if (ObjectUtil.isEmpty(currentYear)) {
      currentYear = startYear;
      currentMonth = startMonth;
      currentDay = int.parse(startDateArray[2]);
    }
    yearList = getYearList();
    monthList = getMonthList(currentYear);
    dayList = getDayList(currentYear, currentMonth);
    int indexYear = 0;
    for (int i = 0; i < yearList.length; i++) {
      if (currentYear == yearList[i]) {
        indexYear = i;
        break;
      }
    }
    int indexMonth = 0;
    for (int j = 0; j < monthList.length; j++) {
      if (currentMonth == monthList[j]) {
        indexMonth = j;
        break;
      }
    }
    int indexDay = 0;
    for (int j = 0; j < dayList.length; j++) {
      if (currentDay == dayList[j]) {
        indexDay = j;
        break;
      }
    }
    yearController = FixedExtentScrollController(initialItem: indexYear);
    monthController = FixedExtentScrollController(initialItem: indexMonth);
    dayController = FixedExtentScrollController(initialItem: indexDay);
    setState(() {
      monthKey = UniqueKey();
      dayKey = UniqueKey();
    });
  }

  /**
   *@author:yuchuan
   *@time:2020/3/30 18:12
   *@description:点击完成按钮响应事件
   *@param:
   *@return:
   */
  void onConfirm() {
    List<String> startDateArray = showStartDayStr.split("-");
    DateTime startTime =
        DateTime(int.tryParse(startDateArray[0]), int.tryParse(startDateArray[1]), int.tryParse(startDateArray[2]));
    List<String> endDateArray = showEndDayStr.split("-");
    DateTime endTime =
        DateTime(int.tryParse(endDateArray[0]), int.tryParse(endDateArray[1]), int.tryParse(endDateArray[2]));
    if (startTime.isAfter(endTime)) {
      dateResponse.startTime = showEndDayStr;
      dateResponse.endTime = showStartDayStr;
    } else {
      dateResponse.startTime = showStartDayStr;
      dateResponse.endTime = showEndDayStr;
    }
    Navigator.of(context).pop(dateResponse);
  }

  /**
    *@author:yuchuan
    *@time:1/29/21 3:13 PM
    *@description:点击取消按钮响应事件
    *@param:
    *@return:
   */
  void onCancel() {
    Navigator.of(context).pop();
  }
}
