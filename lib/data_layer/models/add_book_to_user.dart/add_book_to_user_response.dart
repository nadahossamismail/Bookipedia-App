import 'dart:convert';

AddBookToUserResponse addBookToUserResponseFromJson(String str) =>
    AddBookToUserResponse.fromJson(json.decode(str));

class AddBookToUserResponse {
  final String message;

  AddBookToUserResponse({
    required this.message,
  });
  factory AddBookToUserResponse.empty({message}) => AddBookToUserResponse(
        message: message,
      );

  factory AddBookToUserResponse.fromJson(Map<String, dynamic> json) =>
      AddBookToUserResponse(
        message: json["message"],
      );
}
