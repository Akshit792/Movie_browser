import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mixin LoadingIndicators {
  Widget getLoadingIndicator() {
    if (Platform.isAndroid) {
      return const SizedBox(
        child: CircularProgressIndicator(
          color: Colors.red,
        ),
        height: 30,
        width: 30,
      );
    }
    return const CupertinoActivityIndicator();
  }
}
