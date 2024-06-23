import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'my_home_page.dart'; // Import for pageController, file

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Doc-View',
            style: GoogleFonts.josefinSans(fontSize: 50, color: Colors.white)),
        ElevatedButton(
          onPressed: () async {
            final result = await FilePicker.platform
                .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
            if (result != null && context.mounted) {
              file = result.files.single;
              pageController.animateToPage(1,
                  duration: const Duration(seconds: 1), curve: Curves.ease);
            }
          },
          child: const Text('Pick a file to upload'),
        ),
      ],
    );
  }
}
