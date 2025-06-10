import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moonspace/form/async_text_field.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';

class ManagerApp extends StatelessWidget {
  const ManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
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
                    leading: Icon(Icons.tiktok),
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

                  const SizedBox(height: 16),

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

                  AsyncTextFormField(
                    asyncValidator: (v) async {
                      return "";
                    },
                  ),

                  AsyncTextFormField(
                    asyncValidator: (v) async {
                      return "";
                    },
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: AsyncTextFormField(
                          asyncValidator: (v) async {
                            return "";
                          },
                        ),
                      ),
                      Expanded(
                        child: AsyncTextFormField(
                          asyncValidator: (v) async {
                            return "";
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  FilledButton(
                    onPressed: () {},
                    child: Center(child: const Text('SAVE CHANGES')),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
