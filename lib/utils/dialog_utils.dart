import 'package:flutter/material.dart';

class DialogUtils {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: Center(
              key: key,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                    backgroundColor: Colors.blue,
                    strokeWidth: 3.0,
                  ),
                ],
              ),
            ));
      },
    );
  }
}
