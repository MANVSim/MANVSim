import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimeService {
  static String formatDateTime(DateTime dateTime, BuildContext context) {
    return DateFormat(AppLocalizations.of(context)!.dateTimeFormat)
        .format(dateTime);
  }

  static String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(d.inHours);
    String minutes = twoDigits(d.inMinutes.remainder(60));
    String seconds = twoDigits(d.inSeconds.remainder(60));

    return "$hours:$minutes:$seconds";
  }
}