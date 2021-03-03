import '../utils.dart';

/// custom api response model, preferred way to check api response
class ApiResponse {
  /// returns api status code response
  final RECHARGERESPONSE statusresponse;

  /// returns response based on caught error or on successful
  final dynamic apiResponse;

  /// return api response message information
  final String message;

  ApiResponse({
    this.statusresponse,
    this.apiResponse,
    this.message,
  });

  @override
  String toString() => 'ApiResponse(statusresponse: $statusresponse, apiResponse: $apiResponse, message: $message)';
}
