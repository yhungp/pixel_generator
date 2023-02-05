import 'package:flutter/material.dart';

class MatrixCreation extends StatefulWidget {
  const MatrixCreation({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MatrixCreation> createState() => _MatrixCreationState();
}

class _MatrixCreationState extends State<MatrixCreation> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
