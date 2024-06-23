import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class Page3 extends StatelessWidget {
  const Page3({super.key, required this.pdfText, required this.text});

  final String pdfText;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade900,
              Colors.purpleAccent,
            ],
          ),
        ),
        child: FutureBuilder<http.Response>(
          // future: () async {
          //   return http.post(
          //     Uri.http('127.0.0.1:8000', '/req'),
          //     encoding: Encoding.getByName('utf-8'),
          //     headers: <String, String>{
          //       'Content-Type': 'application/json',
          //     },
          //     body: jsonEncode({"username": 'string'}),
          //   );
          // }(),
          future: Future.delayed(
            const Duration(seconds: 2),
            () {
              return http.post(
                Uri.http('127.0.0.1:8000', '/req'),
                encoding: Encoding.getByName('utf-8'),
                headers: <String, String>{
                  'Content-Type': 'application/json',
                },
                body: jsonEncode({"username": 'string'}),
              );
            },
          ),
          // builder: (context, snapshot) {
          //   if (snapshot.connectionState == ConnectionState.done) {
          //     Map result = jsonDecode(snapshot.data!.body);

          //     return Center(
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: <Widget>[
          //           Text(
          //             'Summary: ${result['summary']}',
          //             style: GoogleFonts.roboto(
          //               textStyle: const TextStyle(
          //                 fontSize: 20,
          //                 color: Colors.white,
          //               ),
          //             ),
          //           ),
          //           Text(
          //             'Similar Text Found: ${result['similar']}',
          //             style: GoogleFonts.roboto(
          //               textStyle: const TextStyle(
          //                 fontSize: 20,
          //                 color: Colors.white,
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     );
          //   } else if (snapshot.hasError) {
          //     return const Center(
          //       child: Text('Error!'),
          //     );
          //   } else {
          //     return const Center(
          //         child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         CircularProgressIndicator(
          //           color: Colors.white,
          //         ),
          //         Padding(padding: EdgeInsets.all(10)),
          //         Text('Loading...', style: TextStyle(color: Colors.white)),
          //       ],
          //     ));
          //   }
          // },

          builder:
              // use AnimatedSwitcher to animate between widgets
              (context, snapshot) {
            Widget child;
            if (snapshot.connectionState == ConnectionState.done) {
              child = Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Summary: ${jsonDecode(snapshot.data!.body)['summary']}',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      'Similar Text Found: ${jsonDecode(snapshot.data!.body)['similar']}',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              child = const Center(
                child: Text('Error!'),
              );
            } else {
              child = const Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.white,
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  Text('Loading...', style: TextStyle(color: Colors.white)),
                ],
              ));
            }

            return AnimatedSwitcher(
              duration: const Duration(seconds: 2),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: child,
            );
          },
        ),
      ),
    ));
  }
}
