import "package:flutter/material.dart";

void showLazyBar(BuildContext context, String text) => ScaffoldMessenger.of(context)
    .showSnackBar(SnackBar(content: Text(text), behavior: SnackBarBehavior.floating));
