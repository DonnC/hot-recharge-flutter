import 'dart:convert';

import 'index.dart';

/// data bundles response
class DataBundles {
  final int replyCode;
  final List<BundleProduct> bundles;
  final String agentReference;

  DataBundles({
    this.replyCode,
    this.bundles,
    this.agentReference,
  });

  Map<String, dynamic> toMap() {
    return {
      'ReplyCode': replyCode,
      'Bundles': bundles?.map((x) => x.toMap())?.toList(),
      'AgentReference': agentReference,
    };
  }

  factory DataBundles.fromMap(Map<String, dynamic> map) {
    return DataBundles(
      replyCode: map['ReplyCode'] ?? 0,
      bundles: List<BundleProduct>.from(
        map['Bundles']
                ?.map((x) => BundleProduct.fromMap(x) ?? BundleProduct()) ??
            const [],
      ),
      agentReference: map['AgentReference'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'DataBundles(replyCode: $replyCode, bundles: $bundles, agentReference: $agentReference)';
}
