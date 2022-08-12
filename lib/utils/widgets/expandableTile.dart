import 'package:flutter/material.dart';

expandableContainer(title, description) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      shadowColor: Colors.grey,
      child: ExpansionTile(
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        expandedAlignment: Alignment.centerLeft,
        title:Text( "$title"),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(description,style: TextStyle(fontSize: 12),),
          ),
        ],

      ),
    ),
  );
}