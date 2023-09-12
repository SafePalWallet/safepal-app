import 'package:intl/intl.dart';

abstract class Time {
  static const int MINUTE = 60;
  static const int HOUR = 60 * MINUTE;
  static const int DAY = 24 * HOUR;

  static DateFormat dateformat = DateFormat('yyyy-MM-dd HH:mm:ss');
  static DateFormat baseDateFormat = DateFormat('yyyy-MM-dd');
  static DateFormat MMddHHmmssFormat = DateFormat('MM-dd HH:mm:ss');
  static DateFormat baseFormat = DateFormat('yyyyMMdd');

  static DateTime getDateTime(int utcSec) {
    return DateTime.fromMillisecondsSinceEpoch(utcSec * 1000, isUtc: true);
  }

  static String formatTimeWithFormatter(int ms, DateFormat dateFormat) {
    return dateFormat.format(DateTime.fromMillisecondsSinceEpoch(ms));
  }

  static String formatUtcFormatter(int millisecondsSinceEpoch){
    return "${dateformat.format(DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch,isUtc: true))} +UTC";
  }

  // timezone: seconds
  static String formatTimeWithTimeZone(int seconds, {int timeZone = 0, bool showTimeZone = false}) {
    seconds += timeZone;
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);
    dateTime.add(Duration(seconds: timeZone));
    if (showTimeZone) {
      String gmtTimeZone;
      if (timeZone == 0) {
        gmtTimeZone = 'UTC+00:00';
      } else {
        int hour = timeZone ~/ 3600;
        String hourStr;
        if (hour.abs() < 10) {
          hourStr = '0${hour.abs()}';
        } else {
          hourStr = '${hour.abs()}';
        }
        gmtTimeZone = 'UTC${timeZone < 0 ? '-' : '+'}$hourStr';
        int min = timeZone % 3600 ~/ 60;
        if (min.abs() < 10) {
          gmtTimeZone += ':0$min';
        } else {
          gmtTimeZone += ':$min';
        }
      }
      return '${dateformat.format(dateTime)} $gmtTimeZone';
    } else {
      dateTime = dateTime.toLocal();
      return dateformat.format(dateTime);
    }
  }

  static String formatTime(int utcSeconds) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(utcSeconds * 1000, isUtc: true);
    dateTime = dateTime.toLocal();
    return dateformat.format(dateTime);
  }

  static String baseFormatTime(int utcSecons) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(utcSecons * 1000, isUtc: true);
    dateTime = dateTime.toLocal();
    return baseDateFormat.format(dateTime);
  }


  static int nowTimeSeconds() {
    DateTime time = DateTime.now();
    return time.millisecondsSinceEpoch ~/ 1000;
  }

  static int nowTimeMilliseconds() {
    DateTime time = DateTime.now();
    return time.millisecondsSinceEpoch;
  }

}