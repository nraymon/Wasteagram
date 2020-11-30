import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wasteagram/models/post.dart';

Widget semanticTextField(Post post){
  return Semantics(
      label:
      'a number field for number of wasted items in picture',
      focused: false,
      textField: true,
      child: wasteFormField(post));
}

Widget wasteFormField(Post post){
  return Padding(
    padding: EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 5.0),
    child: TextFormField(
      autofocus: false,
      decoration: InputDecoration(
          labelText: 'Number of Waste items',
          border: OutlineInputBorder()),
      keyboardType: TextInputType.number,
      inputFormatters: [
        WhitelistingTextInputFormatter.digitsOnly
      ],
      validator: (value) { return wasteValidation(value); },
      onSaved: (value) async {
        post.wasteQuantity = int.parse(value);
        post.dateTime = Timestamp.now();
      },
    ),
  );
}

String wasteValidation(String value){
  if (value.isEmpty){
    return "Please enter in a number";
  }else{
    return null;
  }
}
