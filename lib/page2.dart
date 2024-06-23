import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:file_picker/file_picker.dart';
import 'my_home_page.dart'; // Import for _pageController, pdfText, facts

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
                labelText: 'Please enter the facts of the case',
              ),
              controller: textController),
        ),
        ElevatedButton(
          onPressed: () async {
            pdfText = PdfTextExtractor(PdfDocument(inputBytes: file?.bytes!))
                .extractText();

            facts = textController.text;

            pageController.animateToPage(2,
                duration: const Duration(seconds: 1), curve: Curves.ease);
          },
          child: const Text("Submit"),
        ),
      ],
    );
  }
}
