import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Page3 extends StatelessWidget {
  const Page3({super.key, required this.pdfText, required this.text});

  final String pdfText;
  final String text;

  Future<http.Response> _fetchData() async {
    await Future.delayed(const Duration(seconds: 3));
    return http.post(
      Uri.http('127.0.0.1:8000', '/req'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"username": 'string'}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<http.Response>(
      future: _fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final summary = jsonDecode(snapshot.data!.body)['summary'];
            final similar = jsonDecode(snapshot.data!.body)['similar'];
            return _buildContent(summary, similar);
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error!'));
          }
        }
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      },
    );
  }

  Widget _buildContent(String summary, String similar) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Summary: $summary', style: _textStyle()),
          Text('Similar Text Found: $similar', style: _textStyle()),
        ],
      ),
    );
  }

  TextStyle _textStyle() => GoogleFonts.roboto(
      textStyle: const TextStyle(fontSize: 20, color: Colors.white));
}
