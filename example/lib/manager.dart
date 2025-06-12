import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moonspace/form/async_text_field.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';

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
    return Scaffold(
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hi, Luna',
                          style: GoogleFonts.ibmPlexMono(textStyle: context.h4),
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(80),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'YOUR BALANCE',
                      style: GoogleFonts.ibmPlexMono(textStyle: context.h9),
                    ),

                    const SizedBox(height: 8),

                    Divider(),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'YOUR MOST EXPENSES',
                          style: GoogleFonts.ibmPlexMono(textStyle: context.h9),
                        ),
                        Text(
                          'SEE ALL',
                          style: GoogleFonts.ibmPlexMono(textStyle: context.h9),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'LATEST TRANSACTIONS',
                          style: GoogleFonts.ibmPlexMono(textStyle: context.h9),
                        ),
                        Text(
                          'SEE ALL',
                          style: GoogleFonts.ibmPlexMono(textStyle: context.h9),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    const Divider(height: 1),

                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 4),
                      dense: true,
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: context.cPri,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Icon(Icons.tiktok, color: context.cOnPri),
                      ),
                      title: Text(
                        'Movie Tickets',
                        style: GoogleFonts.ibmPlexMono(textStyle: context.h8),
                      ),
                      subtitle: Text(
                        '28 Apr',
                        style: GoogleFonts.ibmPlexMono(textStyle: context.h9),
                      ),
                      trailing: Text(
                        '\$12.5',
                        style: GoogleFonts.ibmPlexMono(textStyle: context.h4),
                      ),
                      onTap: () {},
                    ),

                    const SizedBox(height: 16),

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      title: Text(
                        'Payment',
                        style: GoogleFonts.ibmPlexMono(textStyle: context.h4),
                      ),
                      subtitle: Text(
                        'Information',
                        style: GoogleFonts.ibmPlexMono(textStyle: context.h4),
                      ),
                      trailing: Icon(Icons.card_membership_sharp, size: 42),
                    ),

                    AsyncTextFormField(
                      valueParser: (value) => value,
                      valueFormatter: (value) => value,
                      validator: (value) {
                        if ("####-####-####-####".length != value.length) {
                          return "Invalid Card Number";
                        }
                        return null;
                      },
                      inputFormatters: [
                        MaskTextInputFormatter(
                          mask: "####-####-####-####",
                          initialText: "0987-1234-5678-9012",
                        ),
                      ],
                      initialValue: "0987-1234-5678-9012",
                      suffix: [Icon(Icons.view_in_ar_sharp)],
                      decoration: (asyncText, textCon) {
                        return InputDecoration(
                          labelText: 'CARD NUMBER',
                          hintText: "0987-1234-5678-9012",
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    AsyncTextFormField(
                      valueParser: (value) => value,
                      valueFormatter: (value) => value,
                      initialValue: "Magic fox",
                      asyncValidator: (value) async {
                        await Future.delayed(Duration(milliseconds: 300));
                        if (!["Magic", "Fox", "Magic fox"].contains(value)) {
                          throw "$value not allowed";
                        }
                      },
                      validator: (value) {
                        return value.isEmpty ? "Name cannot be empty" : null;
                      },
                      decoration: (asyncText, textCon) {
                        return InputDecoration(labelText: 'NAME ON CARD');
                      },
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: AsyncTextFormField<DateTime>(
                            valueParser: (value) =>
                                DateFormat('MMM yyyy').tryParse(value),
                            valueFormatter: (value) =>
                                DateFormat('MMM yyyy').format(value),
                            onTap: (controller, onChanged) async {
                              AsyncText.datetimeSelect(
                                context,
                                controller,
                                onChanged,
                                DateFormat('MMM yyyy'),
                                DateTime(2024),
                                DateTime(2026),
                              );
                            },
                            decoration: (asyncText, textCon) {
                              return InputDecoration(
                                labelText: 'EXPIRY DATE',
                                helperText: '',
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AsyncTextFormField<int>(
                            valueParser: (value) => int.tryParse(value),
                            valueFormatter: (value) => value.toString(),
                            inputFormatters: AsyncText.positiveIntFormatter,
                            validator: (int v) {
                              if (v.toString().length != 3) {
                                return "Length not 3";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            maxLength: 3,
                            password: true,
                            decoration: (asyncText, textCon) {
                              return InputDecoration(
                                labelText: 'CVV',
                                helperText: '',
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    // Double example
                    const SizedBox(height: 8),

                    FilledButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                        }
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            'SAVE CHANGES',
                            style: context.h7.c(context.cOnPri).w3,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    OutlinedButton(
                      onPressed: () {},
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            'EDIT PAYMENT INFO',
                            style: context.h7.w3,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
