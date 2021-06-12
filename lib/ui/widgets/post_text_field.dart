import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PostTextField extends StatelessWidget {
  final TextEditingController controller;
  const PostTextField({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
      child: TextField(
        controller: controller,
        maxLength: 300,
        minLines: 5,
        maxLines: 15,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        buildCounter: (context,
            {int currentLength, bool isFocused, int maxLength}) {
          return Text(
            "$currentLength/$maxLength",
            style: TextStyle(
              color: Theme.of(context).primaryColorLight.withOpacity(0.60),
              fontWeight: FontWeight.w500,
            ),
          );
        },
        style: TextStyle(
          color: Colors.black.withOpacity(0.70),
          fontWeight: FontWeight.w400,
          fontSize: 18.0,
        ),
        decoration: InputDecoration(
            fillColor: Colors.white.withOpacity(0.8),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            hintText: "Type something here",
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.40),
              fontSize: 20.0,
              fontWeight: FontWeight.w400,
            )),
      ),
    );
  }
}
