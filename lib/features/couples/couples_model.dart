class CoupleModel {
  final String coupleName;
  CoupleModel({
    required this.coupleName,
  });

  CoupleModel copyWith({
    String? coupleName,
  }) {
    return CoupleModel(
      coupleName: coupleName ?? this.coupleName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'coupleName': coupleName,
    };
  }

  factory CoupleModel.fromMap(Map<String, dynamic> map) {
    return CoupleModel(
      coupleName: map['coupleName'] as String,
    );
  }

  @override
  String toString() => 'CoupleModel(coupleName: $coupleName)';

  @override
  bool operator ==(covariant CoupleModel other) {
    if (identical(this, other)) return true;

    return other.coupleName == coupleName;
  }

  @override
  int get hashCode => coupleName.hashCode;
}
