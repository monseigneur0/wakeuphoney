import 'dart:convert';

import 'package:flutter/foundation.dart';

class ChatGPTMessageModel {
  String role;
  String content;
  ChatGPTMessageModel({
    required this.role,
    required this.content,
  });

  ChatGPTMessageModel copyWith({
    String? role,
    String? content,
  }) {
    return ChatGPTMessageModel(
      role: role ?? this.role,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'role': role,
      'content': content,
    };
  }

  factory ChatGPTMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatGPTMessageModel(
      role: map['role'] as String,
      content: map['content'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatGPTMessageModel.fromJson(String source) =>
      ChatGPTMessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ChatGPTMessageModel(role: $role, content: $content)';

  @override
  bool operator ==(covariant ChatGPTMessageModel other) {
    if (identical(this, other)) return true;

    return other.role == role && other.content == content;
  }

  @override
  int get hashCode => role.hashCode ^ content.hashCode;
}

class ChatCompletionModel {
  String model;
  List<ChatGPTMessageModel> messages;
  bool stream;
  ChatCompletionModel({
    required this.model,
    required this.messages,
    required this.stream,
  });

  ChatCompletionModel copyWith({
    String? model,
    List<ChatGPTMessageModel>? messages,
    bool? stream,
  }) {
    return ChatCompletionModel(
      model: model ?? this.model,
      messages: messages ?? this.messages,
      stream: stream ?? this.stream,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'model': model,
      'messages': messages.map((x) => x.toMap()).toList(),
      'stream': stream,
    };
  }

  factory ChatCompletionModel.fromMap(Map<String, dynamic> map) {
    return ChatCompletionModel(
      model: map['model'] as String,
      messages: List<ChatGPTMessageModel>.from(
        (map['messages'] as List<int>).map<ChatGPTMessageModel>(
          (x) => ChatGPTMessageModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      stream: map['stream'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatCompletionModel.fromJson(String source) =>
      ChatCompletionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ChatCompletionModel(model: $model, messages: $messages, stream: $stream)';

  @override
  bool operator ==(covariant ChatCompletionModel other) {
    if (identical(this, other)) return true;

    return other.model == model &&
        listEquals(other.messages, messages) &&
        other.stream == stream;
  }

  @override
  int get hashCode => model.hashCode ^ messages.hashCode ^ stream.hashCode;
}
