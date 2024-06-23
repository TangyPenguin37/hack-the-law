import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../page3.dart';

class Page2 extends StatelessWidget {
  Page2({super.key, required this.file});

  final PlatformFile? file;

  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Uploaded ${file.name}"),
      //   backgroundColor: Colors.deepPurple,
      //   foregroundColor: Colors.white,
      // ),
      // appBar: AppBar(
      //   // TRY THIS: Try changing the color here to a specific color (to
      //   // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
      //   // change color while the other colors stay the same.
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(widget.title),
      // ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // colors: [
              //   Theme.of(context).colorScheme.primary,
              //   Theme.of(context).colorScheme.secondary,
              // ],
              colors: [
                Colors.blue.shade900,
                Colors.purpleAccent,
              ],
            ),
          ),
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            //
            // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
            // action in the IDE, or press "p" in the console), to see the
            // wireframe for each widget.
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
                  String text = textController.text;
                  String pdfText =
                      PdfTextExtractor(PdfDocument(inputBytes: file?.bytes!))
                          .extractText();

                  Navigator.of(context).push(_createRoute(pdfText, text));
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Help',
        child: const Icon(Icons.help),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Route _createRoute(String pdfText, String text) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        Page3(pdfText: pdfText, text: text),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
