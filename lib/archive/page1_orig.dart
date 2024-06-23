import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../page2.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
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
                  PlatformFile? result =
                      (await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                      ))?.files.single;

                  if (result != null) {
                    if (context.mounted) {
                      // Navigator.push(
                      //   context,
                      //   CupertinoPageRoute(
                      //       builder: (context) => Page2(file: result)),
                      // );
                      Navigator.of(context).push(_createRoute(result));
                    }
                  }
                },
                child: const Text('Pick a file'),
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

Route _createRoute(PlatformFile file) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Page2(file: file),
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
