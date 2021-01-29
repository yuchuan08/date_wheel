import 'package:common_utils/common_utils.dart';

class DateUtils {
  /**
   *@author:yuchuan
   *@time:2018/11/6 18:05
   *@description:如果startTime在endTime之后返回true，反之返回true
   *@param:
   *@return:
   */
  static bool compairTime(String startTimeString, String endTimeString) {
    DateTime startDate = DateTime.parse(startTimeString);
    DateTime endDate = DateTime.parse(endTimeString);
    return startDate.millisecondsSinceEpoch >= endDate.millisecondsSinceEpoch;
  }

  static bool compairTimeEarly(String startTimeString, String endTimeString) {
    DateTime startDate = DateTime.parse(startTimeString);
    DateTime endDate = DateTime.parse(endTimeString);
    return startDate.isBefore(endDate);
  }

  /**
   *@author:yuchuan
   *@time:2018/11/6 18:10
   *@description:跟当前时间比较，如果晚于当前时间返回true，反之返回false
   *@param:
   *@return:
   */
  static bool compairCurrentTime(String timeString) {
    String timeAppendString = " 00:00:01";
    DateTime date = DateTime.parse(timeString + timeAppendString);
    if (date.millisecondsSinceEpoch >= new DateTime.now().millisecondsSinceEpoch) {
      return false;
    } else {
      return true;
    }
  }

  /**
   *@author:yuchuan
   *@time:2018/11/5 17:27
   *@description:获取当前手机的年份 如2018
   *@param:
   *@return:
   */
  static int getYearInt() {
    return new DateTime.now().year;
  }

  /**
   *@author:yuchuan
   *@time:2018/11/5 17:27
   *@description:获取当前手机的月份 如1
   *@param:
   *@return:
   */
  static int getMothInt() {
    return new DateTime.now().month;
  }

  /**
   *@author:yuchuan
   *@time:2018/11/5 17:27
   *@description:获取当前手机的日 如1
   *@param:
   *@return:
   */
  static int getDayInt() {
    return new DateTime.now().day;
  }

  /**
   *@author:yuchuan
   *@time:2019/10/29 13:19
   *@description:字符串时间戳转化为年月日时分秒
   *@param:
   *@return:
   */
  static String getYMDHM(String timeStr) {
    if (ObjectUtil.isEmpty(timeStr)) {
      return "";
    }
    int milliseconds = int.tryParse(timeStr);
    return DateUtil.formatDateMs(milliseconds, format: DataFormats.y_mo_d_h_m);
  }

  /**
   *@author:yuchuan
   *@time:2020/12/28 14:46
   *@description:获取当前时间的年月日如2020-12-28
   *@param:
   *@return:
   */
  static String getCurrentYMD() {
    return DateUtil.getDateStrByDateTime(
      DateTime.now(),
      format: DateFormat.YEAR_MONTH_DAY,
    );
  }

  /**
   *@author:yuchuan
   *@time:2020/12/28 14:46
   *@description:获取当前时间往前推多少天的年月日如2020-12-28
   *@param:
   *@return:
   */
  static String getBeforeCurrentYMD(int day) {
    if (day < 0) {
      day = 0;
    }
    DateTime dateTime = DateTime.now().subtract(new Duration(days: day));
    return DateUtil.getDateStrByDateTime(
      dateTime,
      format: DateFormat.YEAR_MONTH_DAY,
    );
  }
}
