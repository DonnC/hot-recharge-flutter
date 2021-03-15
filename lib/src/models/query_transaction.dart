import 'dart:convert';

/// query transaction for reconciliation model, get original transaction info sent on the date of the `originalAgentReference`
class QueryTransaction {
  final String replyCode;
  final String replyMsg;
  final String originalAgentReference;
  final Map<String, dynamic> rawReply;
  final String agentReference;

  QueryTransaction({
    this.replyCode,
    this.replyMsg,
    this.originalAgentReference,
    this.rawReply,
    this.agentReference,
  });

  QueryTransaction copyWith({
    int replyCode,
    String replyMsg,
    String originalAgentReference,
    Map<String, dynamic> rawReply,
    String agentReference,
  }) {
    return QueryTransaction(
      replyCode: replyCode ?? this.replyCode,
      replyMsg: replyMsg ?? this.replyMsg,
      originalAgentReference:
          originalAgentReference ?? this.originalAgentReference,
      rawReply: rawReply ?? this.rawReply,
      agentReference: agentReference ?? this.agentReference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ReplyCode': replyCode,
      'ReplyMsg': replyMsg,
      'OriginalAgentReference': originalAgentReference,
      'RawReply': rawReply,
      'AgentReference': agentReference,
    };
  }

  factory QueryTransaction.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return QueryTransaction(
      replyCode: map['ReplyCode'],
      replyMsg: map['ReplyMsg'],
      originalAgentReference: map['OriginalAgentReference'],
      rawReply: Map<String, dynamic>.from(json.decode(map['RawReply'])),
      agentReference: map['AgentReference'],
    );
  }

  String toJson() => json.encode(toMap());

  factory QueryTransaction.fromJson(String source) =>
      QueryTransaction.fromMap(json.decode(source));

  @override
  String toString() {
    return 'QueryTransaction(replyCode: $replyCode, replyMsg: $replyMsg, originalAgentReference: $originalAgentReference, rawReply: $rawReply, agentReference: $agentReference)';
  }
}
