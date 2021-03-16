import '../utils.dart';

/// custom api response model, preferred way to check api response
class ApiResponse {
  /// returns api status code response
  final RechargeResponse rechargeResponse;

  /// returns response based on caught error or on successful
  final dynamic apiResponse;

  /// return api response message information
  final String message;

  ApiResponse({
    this.rechargeResponse,
    this.apiResponse,
    this.message,
  });

  @override
  String toString() =>
      'ApiResponse(rechargeResponse: $rechargeResponse, apiResponse: $apiResponse, message: $message)';
}
