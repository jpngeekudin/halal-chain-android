import 'package:flutter/cupertino.dart';

const ModalBottomSheetShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(10),
    topRight: Radius.circular(10)
  )
);

Widget getModalBottomSheetWrapper({
  required BuildContext context,
  required Widget child,
}) {
  return Container(
    padding: EdgeInsets.only(
      bottom: MediaQuery.of(context).viewInsets.bottom
    ),
    child: child,
  );
}