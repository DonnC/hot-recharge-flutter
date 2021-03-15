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
