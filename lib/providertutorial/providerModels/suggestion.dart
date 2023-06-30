class Suggestion {
  final String activity, type;

  Suggestion({
    required this.activity,
    required this.type,
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) =>
      Suggestion(activity: json['activity'], type: json['type']);
}
