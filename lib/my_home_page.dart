import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'page1.dart';
import 'page2.dart';
import 'page3.dart';

final PageController pageController = PageController(initialPage: 2);
PlatformFile? file;
String facts = '';
String pdfText = '';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
                  controller: pageController,
                  onPageChanged: (int page) {
                    setState(() {});
                  },
                  children: [
                    const Page1(),
                    Page2(file: file),
                    Page3(pdfText: pdfText, text: facts),
                  ],
                ),
              ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Help'),
                content: const Text(
                    'This app allows you to upload a PDF file and enter the facts of a case. It will then extract the text from the PDF and display it on the next page.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Help',
        child: const Icon(Icons.help),
      ),
    );
  }
}
