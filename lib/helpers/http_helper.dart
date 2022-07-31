import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void handleHttpError({
  required BuildContext context,
  required Object err
}) {
  String message = 'Terjadi kesalahan';
  if (err is DioError) message = err.response?.data['message'] ?? message;
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}