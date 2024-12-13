import 'dart:convert';


class ConfirmLoginModel {
  final String accessToken;
  final String refreshToken;

  ConfirmLoginModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory ConfirmLoginModel.fromJson(Map<String, dynamic> json) {
    return ConfirmLoginModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }
}