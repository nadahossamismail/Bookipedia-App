import 'dart:typed_data';

import 'package:bookipedia/app/app_strings.dart';

class GetFileResponse {
  final Uint8List bytes;
  final String message;
  GetFileResponse({required this.bytes, this.message = AppStrings.success});

  factory GetFileResponse.empty({required message}) =>
      GetFileResponse(message: message, bytes: Uint8List(0));
}
