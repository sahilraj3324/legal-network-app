class City {
  final String state;
  final String city;

  City({
    required this.state,
    required this.city,
  });

  factory City.fromCsv(List<String> csvRow) {
    return City(
      state: csvRow[0].trim(),
      city: csvRow[1].trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'state': state,
      'city': city,
    };
  }

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      state: json['state'] ?? '',
      city: json['city'] ?? '',
    );
  }

  @override
  String toString() {
    return '$city, $state';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is City &&
        other.state == state &&
        other.city == city;
  }

  @override
  int get hashCode => state.hashCode ^ city.hashCode;
} 