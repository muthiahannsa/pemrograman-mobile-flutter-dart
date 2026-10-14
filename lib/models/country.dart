
class Country {
  const Country({
    required this.name,
    required this.officialName,
    required this.flagUrl,
    required this.capitals,
    required this.population,
    required this.region,
    required this.subregion,
    required this.currencies,
  });

  final String name;
  final String officialName;
  final String flagUrl;
  final List<String> capitals;
  final int population;
  final String region;
  final String subregion;
  final List<String> currencies;

  factory Country.fromJson(Map<String, dynamic> json) {
    final countryName = json['name'];
    final countryCode = json['alpha2Code']?.toString() ?? '';

    final parsedCapitals = switch (json['capital']) {
      String value => <String>[value],
      List<dynamic> values => values.whereType<String>().toList(),
      _ => <String>[],
    };

    final currencyData = json['currencies'];
    final parsedCurrencies = <String>[];

    if (currencyData is List) {
      for (final item in currencyData) {
        if (item is Map<String, dynamic>) {
          final currencyName = item['name'];
          if (currencyName is String && currencyName.isNotEmpty) {
            parsedCurrencies.add(currencyName);
          }
        }
      }
    } else if (currencyData is Map) {
      for (final item in currencyData.values) {
        if (item is Map && item['name'] is String) {
          parsedCurrencies.add(item['name'] as String);
        }
      }
    }

    return Country(
      name: countryName is String
          ? countryName
          : 'Nama tidak tersedia',
      officialName: json['officialName']?.toString() ??
          (countryName is String
              ? countryName
              : 'Nama resmi tidak tersedia'),
      flagUrl: countryCode.isEmpty
          ? ''
          : 'https://countries.dev/flags/${countryCode.toLowerCase()}.svg',
      capitals: List<String>.unmodifiable(parsedCapitals),
      population: (json['population'] as num?)?.toInt() ?? 0,
      region: json['region']?.toString() ?? 'Tidak diketahui',
      subregion: json['subregion']?.toString() ?? 'Tidak diketahui',
      currencies: List<String>.unmodifiable(parsedCurrencies),
    );
  }

  String get capitalLabel =>
      capitals.isEmpty ? 'Tidak tersedia' : capitals.join(', ');

  String get currencyLabel =>
      currencies.isEmpty ? 'Tidak tersedia' : currencies.join(', ');
}