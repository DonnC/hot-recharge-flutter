/// hot-recharge api request respond
/// property in [ApiResponse] -> statusresponse
enum RECHARGERESPONSE {
  /// api response successful
  SUCCESS,

  /// error sending bulksms
  ERROR,

  /// internal error occured,
  FAIL,

  /// zesa recharge, pending transaction
  PENDING,

  /// api request success but bulksmsapi returns a custom exception
  API_ERROR,
}
