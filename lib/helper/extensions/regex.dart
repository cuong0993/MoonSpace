// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:moonspace/darkknight/debug_functions.dart';
// import 'package:moonspace/darkknight/extensions/color.dart';
// import 'package:url_launcher/link.dart';

// RegExp signedNumRegex = RegExp(r'(?<!\S)-?\d+(?:\.\d+)?(?!\S)');

// RegExp urlLauncherRegex = RegExp(r'(?:mailto|http|ftp|file|tel|sms|www).*?(?:\s|$)');

// RegExp phoneNumRegex = RegExp(r'\b(\+\d{1,2}\s?)?1?\-?\.?\s?\(?\d{3}\)?[\s.\-]?\d{3}[\s.\-]?\d{4}\b');

// RegExp emailRegex = RegExp(r'([a-zA-Z0-9+._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+)');

// class SuperLink extends StatelessWidget {
//   const SuperLink(this.string, {super.key});

//   final String string;

//   @override
//   Widget build(BuildContext context) {
//     String s = Uri.decodeComponent(string);

//     final url = extractRegex(urlLauncherRegex, s).map(
//       (e) {
//         s = s.replaceAll(e, '');
//         unicorn(e);
//         unicorn(s);
//         return Link(
//           uri: Uri.tryParse(e.trim()),
//           builder: (context, followLink) => ElevatedButton(
//             onPressed: followLink,
//             child: Text(
//               e,
//               style: TextStyle(color: Colors.blue),
//             ),
//           ),
//         );
//       },
//     );

//     final email = extractRegex(emailRegex, s).map(
//       (e) {
//         s = s.replaceAll(e, '');
//         dino(e);
//         dino(s);
//         return Link(
//           uri: Uri.tryParse('mailto:$e'.trim()),
//           builder: (context, followLink) => ElevatedButton(
//             onPressed: followLink,
//             child: Text(
//               e,
//               style: TextStyle(color: Colors.red),
//             ),
//           ),
//         );
//       },
//     );

//     final phone = extractRegex(phoneNumRegex, s).map(
//       (e) {
//         s = s.replaceAll(e, '');
//         lava(e);
//         lava(s);
//         return Link(
//           uri: Uri.tryParse('tel:$e'.trim()),
//           builder: (context, followLink) => ElevatedButton(
//             onPressed: followLink,
//             child: Text(
//               e,
//               style: TextStyle(color: Colors.yellow),
//             ),
//           ),
//         );
//       },
//     );

//     final signedNum = extractRegex(signedNumRegex, s).map(
//       (e) {
//         s = s.replaceAll(e, '');
//         unicorn(e);
//         unicorn(s);
//         return InkWell(
//           onLongPress: () async {
//             Clipboard.setData(ClipboardData(text: e)).then((_) {
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e copied to clipboard")));
//             });
//           },
//           child: Text(
//             e,
//             style: TextStyle(
//               color: HexColor.random(),
//               decoration: TextDecoration.underline,
//             ),
//           ),
//         );
//       },
//     );

//     return RichText(
//       text: TextSpan(
//           style: TextStyle(color: Colors.blue),
//           text: 'Hello : ',
//           children: [
//             ...url,
//             ...signedNum,
//             ...email,
//             ...phone,
//           ].map((e) => WidgetSpan(child: e)).toList()),
//     );
//   }
// }

// List<String> extractRegex(RegExp r, String input) {
//   Iterable<Match> matches = r.allMatches(input);
//   return matches.map((match) => match.group(0)!).toList();
// }

bool isWebsite(String input) {
  final RegExp urlRegex = RegExp(
    r'^((ftp|http|https):\/\/)?(www.)?(?!.*(ftp|http|https|www.))[a-zA-Z0-9_-]+(\.[a-zA-Z]+)+((\/)[\w#]+)*(\/\w+\?[a-zA-Z0-9_]+=\w+(&[a-zA-Z0-9_]+=\w+)*)?\/?$',
    caseSensitive: false,
  );

  return urlRegex.hasMatch(input);
}

// class SuperLinkMyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final text = 'https://flutter.dev smith@example.org?subject=News&body=New%20plugin '
//         '+11 (703) 678 5982 7036785982 +17036785982 +1-555-010-9099 703-678-5982 +55 '
//         '+123-333 123-123-123 4854 545545 4845454515';

//     return MaterialApp(
//       title: 'Flutter RichText Demo',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Flutter RichText Demo'),
//         ),
//         body: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: RichText(
//               text: parseText(text),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   TextSpan parseText(String text) {
//     final List<String> words = text.split(' ');

//     final List<TextSpan> textSpans = words.map((word) {
//       if (word.startsWith('http') || word.startsWith('www.')) {
//         return TextSpan(
//           text: '$word ',
//           style: TextStyle(color: Colors.blue),
//         );
//       } else if (word.contains('@')) {
//         return TextSpan(
//           text: '$word ',
//           style: TextStyle(color: Colors.yellow),
//         );
//       } else if (RegExp(r'^(\+|\d)[\d\s-]+$').hasMatch(word)) {
//         return TextSpan(
//           text: '$word ',
//           style: TextStyle(color: Colors.red),
//         );
//       } else {
//         return TextSpan(
//           text: '$word ',
//         );
//       }
//     }).toList();

//     return TextSpan(children: textSpans);
//   }
// }
