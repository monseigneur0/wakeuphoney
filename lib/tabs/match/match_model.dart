class MatchModel {
  final String uid;
  final DateTime time;
  final int vertifynumber;
  MatchModel({
    required this.uid,
    required this.time,
    required this.vertifynumber,
  });

  MatchModel copyWith({
    String? uid,
    DateTime? time,
    int? vertifynumber,
  }) {
    return MatchModel(
      uid: uid ?? this.uid,
      time: time ?? this.time,
      vertifynumber: vertifynumber ?? this.vertifynumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'time': time,
      'vertifynumber': vertifynumber,
    };
  }

  factory MatchModel.fromMap(Map<String, dynamic> map) {
    return MatchModel(
      uid: map['uid'] as String,
      time: map['time'].toDate(),
      vertifynumber: map['vertifynumber'] as int,
    );
  }

  @override
  String toString() => 'MatchModel(uid: $uid, time: $time, vertifynumber: $vertifynumber)';

  @override
  bool operator ==(covariant MatchModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid && other.time == time && other.vertifynumber == vertifynumber;
  }

  @override
  int get hashCode => uid.hashCode ^ time.hashCode ^ vertifynumber.hashCode;
}
