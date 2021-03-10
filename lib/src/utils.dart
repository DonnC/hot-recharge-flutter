/// hot-recharge api request respond
/// property in [ApiResponse] -> rechargeResponse
enum RechargeResponse {
  /// api response successful
  SUCCESS,

  /// error performing hot-recharge request
  ERROR,

  /// internal api service error occured,
  FAIL,

  /// zesa recharge, pending transaction
  PENDING,

  /// api request success but hot-recharge returns a custom exception code
  API_ERROR,
}

/// used internally when `enableLogger` is set to true
/// used to determine log level
enum LOG_LEVEL {
  DEBUG,
  INFO,
  ERROR,
  WARNING,
  WTF,
  LOG,
}
