import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Page3 extends StatelessWidget {
  const Page3({super.key, required this.pdfText, required this.text});

  final String pdfText;
  final String text;

  Future<http.Response> _fetchData() async {
    await Future.delayed(const Duration(seconds: 3));
    return http.post(
      Uri.http('127.0.0.1:8000', '/analyse'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"facts": text, "file": pdfText}),
    );
  }

  Future delayText() async {
    await Future.delayed(const Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<http.Response>(
      future: _fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final decoded = jsonDecode(utf8.decode(snapshot.data!.bodyBytes));
            return _buildContent("temp", context, decoded);
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error!'));
          }
        }
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 20),
            const Text('Analyzing...', style: TextStyle(color: Colors.white)),
            // show "this may take a while..." after 5 seconds
            FutureBuilder(
                future: delayText(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return const Text('This may take a while...',
                        style: TextStyle(color: Colors.white));
                  }
                  return const SizedBox.shrink();
                })
          ],
        ));
      },
    );
  }

  Widget _buildContent(String summary, BuildContext context, decoded) {
    List<Widget> similarText = [];

    final List<dynamic> similar = decoded["cases"];
    final String summary_witness = decoded["summary_witness"];
    final String summary_nda = decoded["summary_nda"];
    final String cross_compare = decoded["cross_compare"];

    similarText.add(Text('Similar Cases:', style: _textStyle(30)));

    for (var i = 0; i < similar.length; i++) {
      similarText.add(Text(
          (similar[i]["output"] as String)
              .replaceAll("\n\n", "///")
              .replaceAll("\n", " ")
              .replaceAll("///", "\n\n"),
          style: _textStyle(20)));
    }

    similarText.add(
        Text("\n\nSummary of Witness Statement:\n\n", style: _textStyle(30)));

    similarText.add(Text(
        summary_witness
            .replaceAll("\n\n", "///")
            .replaceAll("\n", " ")
            .replaceAll("///", "\n\n"),
        style: _textStyle(20)));

    // similarText.add(MarkdownBody(data: summary_witness));
    // make markdown white
    // similarText.add(MarkdownBody(
    //     data: summary_witness,
    //     styleSheet:
    //         MarkdownStyleSheet(p: _textStyle(20), blockquote: _textStyle(20))));

    similarText.add(Text("\n\nSummary of NDA:\n\n", style: _textStyle(30)));

    similarText.add(Text(
        summary_nda
            .replaceAll("\n\n", "///")
            .replaceAll("\n", " ")
            .replaceAll("///", "\n\n"),
        style: _textStyle(20)));

    similarText.add(Text("\n\nCross Comparison:\n\n", style: _textStyle(30)));

    similarText.add(Text(
        cross_compare
            .replaceAll("\n\n", "///")
            .replaceAll("\n", " ")
            .replaceAll("///", "\n\n"),
        style: _textStyle(20)));

    return Center(
        child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Analysis:', style: _textStyle(40)),
          SizedBox(height: 20),
          SizedBox(
            // set to screen height - 200
            height: MediaQuery.of(context).size.height - 200,
            child: SingleChildScrollView(
              child: Column(children: similarText),
            ),
          )
        ],
      ),
    ));
  }

  TextStyle _textStyle(double fontsize) => GoogleFonts.roboto(
      textStyle: TextStyle(fontSize: fontsize, color: Colors.white));
}
