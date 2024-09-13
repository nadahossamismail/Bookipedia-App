import 'package:bookipedia/main.dart';

class ApiEndpoints {
  static const String appBaseUrl = "https://bookipedia-backend.onrender.com";
  static const String signUpEndPoint = "/auth/signup";
  static const String verifyAccountEndPoint = "/auth/confirm-your-account";
  static const String loginEndPoint = "/auth/login";
  static const String forgotPasswordEndPoint = "/auth/forget-password";
  static const String resetPasswordEndPoint = "/auth/reset-password";
  static const String changeEmailEndPoint = "/auth/change-email";
  static const String resetEmailEndPoint = "/auth/change-email";
  static const String updateUserDataEndPoint = "/auth/update-user-data";
  static const String updatePasswordEndPoint = "/auth/update-password";
  static const String resendVerificationEmailEndPoint =
      "/auth/resend-verification-email";
  static const String getAllBooks = "/book";
  static const String addDocument = "/document";
  static const String getAllUserDocuments = "/document";
  static const String deleteDocument = "/document/";
  static const String getDocumentFile = "/document/file/";
  static const String questionOnFile = "/ai/question/";
  static const String fileChat = "/ai/chat/";
  static const String textToSpeech = "/ai/tts";
  static const String addBookToUser = "/book/id/user";
  static const String userBooks = "/book/user";
  static const String removeBookFromUser = "/book/id/user";
  static const String displayBook = "/book/displayed-book/id";
  static const String updateProgressPage = "/progress/id?type=file";
  static const String recentActivity = "/progress/recent-reading";
  static const String recommendedBooks = "/progress/recommendation-books";
}

class ApiHeaders {
  static Map<String, dynamic> tokenHeader = {
    'Authorization': 'Bearer ${preferences.get('token')}'
  };
}
