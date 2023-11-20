// import 'package:intl/intl.dart';

// String dateMDYYYYHMP(DateTime? d) => d == null ? '-' : DateFormat.yMd().add_jm().format(d);
// String dateMMDYYYYHMSP(DateTime? d) => d == null ? '-' : DateFormat().format(d);

// String dateHMP(DateTime? d) => d == null ? '-' : DateFormat.jm().format(d);
// String dateHM(DateTime? d) => d == null ? '-' : DateFormat.Hm().format(d);

// String dateWMDY(DateTime? d) => d == null ? '-' : DateFormat('EEE, MMM d, ' 'yy').format(d);
// String dateWWMMDYYYY(DateTime? d) => d == null ? '-' : DateFormat.yMMMMEEEEd().format(d);
// String dateMDYYYY(DateTime? d) => d == null ? '-' : DateFormat.yMd().format(d);
// String dateMMDYYYY(DateTime? d) => d == null ? '-' : DateFormat.yMMMMd('en_US').format(d);
// String dateDMMYYYYHMP(DateTime? d) => d == null ? '-' : DateFormat('d MMM, yyyy, h:mm a').format(d);
// String dateDMYY(DateTime? d) => d == null ? '-' : DateFormat('d-M-yy').format(d);

// String dateHMS(DateTime? d) {
//   return '${d?.hour ?? '-'}${d == null ? ' ' : 'H : '}'
//       '${d?.minute ?? '-'}${d == null ? ' ' : 'M : '}'
//       '${d?.second ?? '-'}${d == null ? ' ' : 'S'}';
// }

// String durationMMSS(Duration? duration) {
//   if (duration == null) return '';
//   final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
//   final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
//   return '$minutes:$seconds';
// }
