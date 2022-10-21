import 'dart:convert';

class Thumbnails {
  const Thumbnails({
    this.xs = "",
    this.s = "",
    this.m = "",
    this.l = "",
    this.xl = "",
    this.xxl = "",
  });

  /// Very small thumbnail (in size).
  final String xs;

  /// Small thumbnail (in size).
  final String s;

  /// Medium thumbnail (in size).
  final String m;

  /// Large thumbnail (in size).
  final String l;

  /// Very Large thumbnail (in size).
  final String xl;

  /// Largest thumbnail (in size).
  final String xxl;

  factory Thumbnails.empty() {
    return const Thumbnails();
  }

  Thumbnails copyWith({
    String? xs,
    String? s,
    String? m,
    String? l,
    String? xl,
    String? xxl,
  }) {
    return Thumbnails(
      xs: xs ?? this.xs,
      s: s ?? this.s,
      m: m ?? this.m,
      l: l ?? this.l,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "xs": xs,
      "s": s,
      "m": m,
      "l": l,
      "xl": xl,
      "xxl": xxl,
    };
  }

  factory Thumbnails.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return const Thumbnails();
    }

    return Thumbnails(
      xs: map["xs"] ?? "",
      s: map["s"] ?? "",
      m: map["m"] ?? "",
      l: map["l"] ?? "",
      xl: map["xl"] ?? "",
      xxl: map["xxl"] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory Thumbnails.fromJson(String source) =>
      Thumbnails.fromMap(json.decode(source));

  @override
  String toString() {
    return "Thumbnails(xs: $xs, s: $s, m: $m, l: $l, xl: $xl, xxl: $xxl)";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Thumbnails &&
        other.xs == xs &&
        other.s == s &&
        other.m == m &&
        other.l == l &&
        other.xl == xl &&
        other.xxl == xxl;
  }

  @override
  int get hashCode {
    return xs.hashCode ^
        s.hashCode ^
        m.hashCode ^
        l.hashCode ^
        xl.hashCode ^
        xxl.hashCode;
  }
}
