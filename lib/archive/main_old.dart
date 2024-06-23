import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// import 'page1.dart';
// import 'page2.dart';
// import 'page3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hack the Law | Hackathon 2024',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: Page2(
      //     file: PlatformFile(
      //         name: "test.pdf", bytes: Uint8List.fromList([1, 2, 3]), size: 3)),
      // home: const Page3(pdfText: "pdfText", text: "text"),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final PageController _pageController = PageController();
PlatformFile? file;
String facts = '';
String pdfText = '';

class _MyHomePageState extends State<MyHomePage> {
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Center(
  //         // Center is a layout widget. It takes a single child and positions it
  //         // in the middle of the parent.
  //         child: Container(
  //             width: double.infinity,
  //             height: double.infinity,
  //             decoration: BoxDecoration(
  //               gradient: LinearGradient(
  //                 begin: Alignment.topLeft,
  //                 end: Alignment.bottomRight,
  //                 // colors: [
  //                 //   Theme.of(context).colorScheme.primary,
  //                 //   Theme.of(context).colorScheme.secondary,
  //                 // ],
  //                 colors: [
  //                   Colors.blue.shade900,
  //                   Colors.purpleAccent,
  //                 ],
  //               ),
  //             ),
  //             child: PageView(
  //               controller: _pageController,
  //               onPageChanged: (int page) {
  //                 setState(() {
  //                   _currentPage = page;
  //                 });
  //               },
  //               children: [
  //                 // const Text("Page 1"),
  //                 // const Text("Page 2"),
  //                 const Page1(),
  //                 // Page2(file: file!),
  //                 // Page3(pdfText: pdfText, text: facts),
  //               ],
  //             ))),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: () {
  //         if (_currentPage == 0) {
  //           _pageController.animateToPage(1,
  //               duration: const Duration(milliseconds: 400),
  //               curve: Curves.ease);
  //         } else {
  //           _pageController.animateToPage(0,
  //               duration: const Duration(milliseconds: 400),
  //               curve: Curves.easeInOut);
  //         }
  //       },
  //       child: const Icon(Icons.arrow_forward),
  //     ),
  //   );
  // }

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
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                      });
                    },
                    children: [
                      const Page1(),
                      Page2(file: file),
                      Page3(pdfText: pdfText, text: facts),
                    ],
                  ),
                ))));
  }
}

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Doc-View',
          style: TextStyle(
            fontSize: 50,
            // fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.josefinSans().fontFamily,
            color: Colors.white,
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            PlatformFile? result = (await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf'],
            ))
                ?.files
                .single;

            if (result != null) {
              if (context.mounted) {
                file = result;
                _pageController.animateToPage(1,
                    duration: const Duration(seconds: 5), curve: Curves.ease);
              }
            }
          },
          child: const Text('Pick a file'),
        ),
      ],
    );
  }
}

class Page2 extends StatelessWidget {
  Page2({super.key, required this.file});

  final PlatformFile? file;

  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Uploaded ${file?.name}",
          style: TextStyle(
            fontSize: 30,
            // fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.josefinSans().fontFamily,
            color: Colors.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
              decoration: const InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'Facts of the case',
              ),
              controller: textController),
        ),
        ElevatedButton(
          onPressed: () async {
            // String text = textController.text;
            // String pdfText =
            //     PdfTextExtractor(PdfDocument(inputBytes: file.bytes!))
            //         .extractText();

            pdfText = PdfTextExtractor(PdfDocument(inputBytes: file?.bytes!))
                .extractText();

            facts = textController.text;

            _pageController.animateToPage(2,
                duration: const Duration(seconds: 1), curve: Curves.ease);
          },
          child: const Text("Submit"),
        ),
      ],
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({super.key, required this.pdfText, required this.text});

  final String pdfText;
  final String text;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<http.Response>(
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
        const Duration(seconds: 3),
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
          duration: const Duration(seconds: 1),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: child,
        );
      },
    );
  }
}
