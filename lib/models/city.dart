class City {
  final String name;
  final String? country;
  final bool isFavorite;

  City({
    required this.name,
    this.country,
    this.isFavorite = false,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'],
      country: json['country'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
      'isFavorite': isFavorite,
    };
  }

  City copyWith({
    String? name,
    String? country,
    bool? isFavorite,
  }) {
    return City(
      name: name ?? this.name,
      country: country ?? this.country,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
