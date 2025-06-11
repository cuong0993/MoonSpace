import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moonspace/form/async_text_field.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/helper/validator/validator.dart';

import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ManagerApp extends StatefulWidget {
  const ManagerApp({super.key});

  @override
  State<ManagerApp> createState() => _ManagerAppState();
}

class _ManagerAppState extends State<ManagerApp> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MyWidget();

    // return Scaffold(
    //   body: Form(
    //     key: _formKey,
    //     child: CustomScrollView(
    //       slivers: [
    //         SliverAppBar(
    //           leading: IconButton(
    //             onPressed: () {
    //               context.pop();
    //             },
    //             icon: Icon(Icons.arrow_back),
    //           ),
    //         ),
    //         SliverToBoxAdapter(
    //           child: Padding(
    //             padding: const EdgeInsets.all(16.0),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Text(
    //                       'Hi, Luna',
    //                       style: GoogleFonts.ibmPlexMono(textStyle: context.h4),
    //                     ),
    //                     Container(
    //                       width: 50,
    //                       height: 50,
    //                       decoration: BoxDecoration(
    //                         color: Colors.red,
    //                         borderRadius: BorderRadius.circular(80),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 const SizedBox(height: 16),
    //                 Text(
    //                   'YOUR BALANCE',
    //                   style: GoogleFonts.ibmPlexMono(textStyle: context.h9),
    //                 ),

    //                 const SizedBox(height: 8),

    //                 Divider(),

    //                 const SizedBox(height: 8),

    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Text(
    //                       'YOUR MOST EXPENSES',
    //                       style: GoogleFonts.ibmPlexMono(textStyle: context.h9),
    //                     ),
    //                     Text(
    //                       'SEE ALL',
    //                       style: GoogleFonts.ibmPlexMono(textStyle: context.h9),
    //                     ),
    //                   ],
    //                 ),

    //                 const SizedBox(height: 8),

    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Text(
    //                       'LATEST TRANSACTIONS',
    //                       style: GoogleFonts.ibmPlexMono(textStyle: context.h9),
    //                     ),
    //                     Text(
    //                       'SEE ALL',
    //                       style: GoogleFonts.ibmPlexMono(textStyle: context.h9),
    //                     ),
    //                   ],
    //                 ),

    //                 const SizedBox(height: 8),

    //                 const Divider(height: 1),

    //                 ListTile(
    //                   contentPadding: EdgeInsets.symmetric(horizontal: 4),
    //                   dense: true,
    //                   leading: Container(
    //                     padding: EdgeInsets.all(8),
    //                     decoration: BoxDecoration(
    //                       color: context.cPri,
    //                       borderRadius: BorderRadius.circular(32),
    //                     ),
    //                     child: Icon(Icons.tiktok, color: context.cOnPri),
    //                   ),
    //                   title: Text(
    //                     'Movie Tickets',
    //                     style: GoogleFonts.ibmPlexMono(textStyle: context.h8),
    //                   ),
    //                   subtitle: Text(
    //                     '28 Apr',
    //                     style: GoogleFonts.ibmPlexMono(textStyle: context.h9),
    //                   ),
    //                   trailing: Text(
    //                     '\$12.5',
    //                     style: GoogleFonts.ibmPlexMono(textStyle: context.h4),
    //                   ),
    //                   onTap: () {},
    //                 ),

    //                 const SizedBox(height: 16),

    //                 ListTile(
    //                   contentPadding: EdgeInsets.zero,
    //                   dense: true,
    //                   title: Text(
    //                     'Payment',
    //                     style: GoogleFonts.ibmPlexMono(textStyle: context.h4),
    //                   ),
    //                   subtitle: Text(
    //                     'Information',
    //                     style: GoogleFonts.ibmPlexMono(textStyle: context.h4),
    //                   ),
    //                   trailing: Icon(Icons.card_membership_sharp, size: 42),
    //                 ),

    //                 const SizedBox(height: 8),

    //                 AsyncTextFormField(
    //                   valueParser: (value) => value,
    //                   valueFormatter: (value) => value,
    //                   asyncValidator: (v) async {
    //                     return null;
    //                   },
    //                   inputFormatters: [
    //                     MaskTextInputFormatter(mask: "####-####-####-####"),
    //                   ],
    //                   initialValue: "0987-1234-5678-9012",
    //                   suffix: [Icon(Icons.view_in_ar_sharp)],
    //                   decoration: (asyncText, textCon) {
    //                     return InputDecoration(
    //                       labelText: 'CARD NUMBER',
    //                       hintText: "0987-1234-5678-9012",
    //                     );
    //                   },
    //                 ),

    //                 AsyncTextFormField(
    //                   valueParser: (value) => value,
    //                   valueFormatter: (value) => value,
    //                   asyncValidator: (v) async {
    //                     return v.isEmpty ? null : "Name cannot be empty";
    //                   },
    //                   decoration: (asyncText, textCon) {
    //                     return InputDecoration(labelText: 'NAME ON CARD');
    //                   },
    //                 ),

    //                 AsyncTextFormField<DateTime>(
    //                   valueParser: (value) {
    //                     return DateTime.tryParse(value);
    //                   },
    //                   valueFormatter: (value) {
    //                     return DateFormat('MMM yyyy').format(value);
    //                   },
    //                   asyncValidator: (v) async {
    //                     return null;
    //                   },
    //                   onTap: (controller, onChanged) async {
    //                     FocusScope.of(context).requestFocus(FocusNode());
    //                     final date = await showDatePicker(
    //                       context: context,
    //                       firstDate: DateTime(2024),
    //                       lastDate: DateTime(2025),
    //                     );
    //                     if (date != null) {
    //                       // Store full datetime string as the actual value
    //                       controller.text = DateFormat('MMM yyyy').format(date);

    //                       // // Update display text
    //                       // controller.value = TextEditingValue(
    //                       //   text: DateFormat('MMM yyyy').format(date),
    //                       //   selection: TextSelection.collapsed(
    //                       //     offset: DateFormat('MMM yyyy').format(date).length,
    //                       //   ),
    //                       // );

    //                       onChanged(date.toString());
    //                     }
    //                   },
    //                   inputFormatters: [
    //                     TextInputFormatter.withFunction((
    //                       TextEditingValue oldValue,
    //                       TextEditingValue newValue,
    //                     ) {
    //                       return TextEditingValue(
    //                         text: newValue.text.toUpperCase(),
    //                         selection: newValue.selection,
    //                       );
    //                     }),
    //                   ],
    //                   onChanged: (value) {
    //                     print("onChanged: " + value);
    //                   },
    //                   maxLines: 1,
    //                   decoration: (asyncText, textCon) {
    //                     return InputDecoration(
    //                       labelText: 'EXPIRY DATE',
    //                       helperText: '',
    //                     );
    //                   },
    //                 ),

    //                 Row(
    //                   children: [
    //                     Expanded(
    //                       child: AsyncTextFormField<DateTime>(
    //                         valueParser: (value) => DateTime.tryParse(value),
    //                         valueFormatter: (value) =>
    //                             DateFormat('MMM yyyy').format(value).toString(),
    //                         asyncValidator: (v) async {
    //                           return null;
    //                         },
    //                         onTap: (controller, onChanged) =>
    //                             AsyncText.datetimeSelect(controller, context),
    //                         maxLines: 1,
    //                         decoration: (asyncText, textCon) {
    //                           return InputDecoration(
    //                             labelText: 'EXPIRY DATE',
    //                             helperText: '',
    //                           );
    //                         },
    //                       ),
    //                     ),
    //                     Expanded(
    //                       child: AsyncTextFormField(
    //                         valueParser: (value) => value,
    //                         valueFormatter: (value) => value,
    //                         asyncValidator: (String v) async {
    //                           if (!isNumeric(v)) {
    //                             return "Not numeric";
    //                           }
    //                           if (v.length != 3) {
    //                             return "Length not 3";
    //                           }
    //                           return null;
    //                         },
    //                         keyboardType: TextInputType.number,
    //                         maxLength: 3,
    //                         password: true,
    //                         decoration: (asyncText, textCon) {
    //                           return InputDecoration(
    //                             labelText: 'CVV',
    //                             helperText: '',
    //                           );
    //                         },
    //                       ),
    //                     ),
    //                   ],
    //                 ),

    //                 // Integer example
    //                 AsyncTextFormField<int>(
    //                   valueParser: (String value) => int.tryParse(value),
    //                   valueFormatter: (int value) => value.toString(),
    //                   asyncValidator: (int value) async {
    //                     return value > 0 ? null : 'Must be positive';
    //                   },
    //                   decoration: (asyncText, textCon) {
    //                     return InputDecoration(
    //                       labelText: 'Int',
    //                       helperText: 'help',
    //                     );
    //                   },
    //                 ),

    //                 // Double example
    //                 AsyncTextFormField<double>(
    //                   valueParser: (String value) => double.tryParse(value),
    //                   valueFormatter: (double value) =>
    //                       value.toStringAsFixed(2),
    //                   inputFormatters: AsyncText.negativeDoubleFormatter,
    //                   keyboardType: AsyncText.negativeDouble,
    //                   asyncValidator: (double value) async {
    //                     print("validate : " + value.toString());

    //                     return value >= 0 ? null : 'Must be non-negative';
    //                   },
    //                   onChanged: (value) {
    //                     print("changed : " + value);
    //                   },
    //                   decoration: (asyncText, textCon) {
    //                     return InputDecoration(
    //                       labelText: 'Double',
    //                       helperText: 'help',
    //                     );
    //                   },
    //                 ),

    //                 // DateTime example
    //                 AsyncTextFormField<DateTime>(
    //                   valueParser: (String value) {
    //                     try {
    //                       return DateTime.parse(value);
    //                     } catch (_) {
    //                       return null;
    //                     }
    //                   },
    //                   valueFormatter: (DateTime value) =>
    //                       value.toIso8601String(),
    //                   asyncValidator: (DateTime value) async {
    //                     return value.isAfter(DateTime.now())
    //                         ? null
    //                         : 'Must be future date';
    //                   },
    //                   decoration: (asyncText, textCon) {
    //                     return InputDecoration(
    //                       labelText: 'Datetime',
    //                       helperText: '',
    //                     );
    //                   },
    //                 ),

    //                 const SizedBox(height: 16),

    //                 FilledButton(
    //                   onPressed: () {
    //                     // Validate returns true if the form is valid, or false otherwise.
    //                     if (_formKey.currentState!.validate()) {
    //                       // If the form is valid, display a snackbar. In the real world,
    //                       // you'd often call a server or save the information in a database.
    //                       ScaffoldMessenger.of(context).showSnackBar(
    //                         const SnackBar(content: Text('Processing Data')),
    //                       );
    //                     }
    //                   },
    //                   child: Center(
    //                     child: Padding(
    //                       padding: const EdgeInsets.all(4.0),
    //                       child: Text(
    //                         'SAVE CHANGES',
    //                         style: context.h7.c(context.cOnPri).w3,
    //                       ),
    //                     ),
    //                   ),
    //                 ),

    //                 const SizedBox(height: 8),

    //                 OutlinedButton(
    //                   onPressed: () {},
    //                   child: Center(
    //                     child: Padding(
    //                       padding: const EdgeInsets.all(4.0),
    //                       child: Text(
    //                         'EDIT PAYMENT INFO',
    //                         style: context.h7.w3,
    //                       ),
    //                     ),
    //                   ),
    //                 ),

    //                 const SizedBox(height: 100),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              key: _emailKey,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Enter email';
                return null;
              },
            ),
            AsyncTextFormField(
              asyncValidator: (value) async {
                // Check against server or do other async operations
                await Future.delayed(Duration(seconds: 1));
                // Throw error if validation fails
                if (Random().nextBool()) {
                  throw 'Server validation failed';
                }
              },
              validator: (value) {
                if (value.isEmpty) return 'Enter email';
                return null;
              },
              valueParser: (value) => value,
              valueFormatter: (value) => value,
            ),
            TextFormField(
              key: _passwordKey,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.length < 6) return 'Min 6 chars';
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  print('Form is valid!');
                } else {
                  print('Form has errors.');
                }
              },
              child: Text('Submit'),
            ),
            ElevatedButton(
              onPressed: () {
                // Only validate the email field
                final isValid = _emailKey.currentState?.validate();
                print('Email valid? $isValid');
              },
              child: Text('Validate Email Only'),
            ),
          ],
        ),
      ),
    );
  }
}
