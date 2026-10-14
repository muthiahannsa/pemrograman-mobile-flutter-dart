
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/country.dart';

class CountryService {
  CountryService({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  static final Uri _endpoint = Uri.parse(
    'https://countries.dev/countries'
    '?fields=name,alpha2Code,capital,population,region,subregion,currencies'
    '&sort=name',
  );

  Future<List<Country>> fetchCountries() async {
    // Parameter unik agar permintaan refresh tidak memakai URL lama.
    final requestUri = _endpoint.replace(
      queryParameters: {
        ..._endpoint.queryParameters,
        '_refresh': DateTime.now()
            .microsecondsSinceEpoch
            .toString(),
      },
    );

    debugPrint('MENGIRIM REQUEST API: $requestUri');

    try {
      final response = await _client
          .get(requestUri)
          .timeout(const Duration(seconds: 12));

      debugPrint('STATUS API: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw CountryServiceException(
          'Server mengembalikan kode ${response.statusCode}.',
        );
      }

      final dynamic decoded = jsonDecode(response.body);

      if (decoded is! List) {
        throw const CountryServiceException(
          'Format data dari API tidak sesuai.',
        );
      }

      final countries = decoded
          .whereType<Map<String, dynamic>>()
          .map(Country.fromJson)
          .toList();

      if (countries.isEmpty) {
        throw const CountryServiceException(
          'API tidak mengirim data negara.',
        );
      }

      countries.sort(
        (a, b) => b.population.compareTo(a.population),
      );

      debugPrint(
        'DATA BERHASIL DIMUAT: ${countries.length} negara',
      );

      return List<Country>.unmodifiable(countries);
    } on TimeoutException {
      debugPrint('ERROR API: REQUEST TIMEOUT');

      throw const CountryServiceException(
        'Permintaan terlalu lama. Periksa koneksi internet.',
      );
    } on CountryServiceException {
      rethrow;
    } catch (error) {
      debugPrint('ERROR API: $error');

      throw CountryServiceException(
        'Tidak dapat mengambil data negara. '
        'Periksa koneksi internet. Detail: $error',
      );
    }
  }

  void dispose() {
    _client.close();
  }
}

class CountryServiceException implements Exception {
  const CountryServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}
