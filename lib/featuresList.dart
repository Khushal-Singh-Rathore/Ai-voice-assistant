import 'package:flutter/material.dart';

class featuresList extends StatefulWidget {
  final Color color;
  final String heading;
  final String description;
  const featuresList(
      {required this.color,
      required this.heading,
      required this.description,
      super.key});

  @override
  State<featuresList> createState() => featuresListState();
}

class featuresListState extends State<featuresList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: widget.color),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(widget.heading,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        Text(widget.description)
      ]),
    );
  }
}
