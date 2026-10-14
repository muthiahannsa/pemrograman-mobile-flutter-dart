
import 'package:flutter/material.dart';

import '../../models/country.dart';
import '../../services/country_service.dart';
import '../widgets/country_card.dart';
import '../widgets/country_stats.dart';
import '../widgets/state_view.dart';

class CountryScreen extends StatefulWidget {
  const CountryScreen({super.key});

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  final CountryService _service = CountryService();
  final TextEditingController _searchController =
      TextEditingController();

  List<Country> _countries = const [];
  bool _isLoading = true;
  String? _errorMessage;
  String _query = '';
  String _selectedRegion = 'Semua';

  // MIDNIGHT NAVY + GOLD THEME
  static const Color _background = Color(0xFF080D18);
  static const Color _surface = Color(0xFF111827);
  static const Color _surfaceLight = Color(0xFF151E2E);
  static const Color _pill = Color(0xFF1C2940);
  static const Color _border = Color(0xFF29364D);

  static const Color _gold = Color(0xFFD4A853);
  static const Color _goldBright = Color(0xFFF0C96A);
  static const Color _goldSoft = Color(0xFFE8D59B);

  static const Color _textPrimary = Color(0xFFF8FAFC);
  static const Color _textSecondary = Color(0xFF9CA9BC);

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadCountries();
  }

  void _onSearchChanged() {
    setState(() {
      _query = _searchController.text.trim().toLowerCase();
    });
  }

  // Memuat data negara dan menangani error API.
  Future<void> _loadCountries() async {
    if (!mounted) return;

    debugPrint('=== MULAI REFRESH NEGARA ===');

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _service
          .fetchCountries()
          .timeout(const Duration(seconds: 12));

      debugPrint(
        '=== API BERHASIL: ${result.length} negara ===',
      );

      if (!mounted) return;

      setState(() {
        _countries = result;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (error, stackTrace) {
      debugPrint('=== API GAGAL: $error ===');
      debugPrint('$stackTrace');

      if (!mounted) return;

      setState(() {
        _errorMessage =
            'Gagal mengambil data negara.\n'
            'Periksa koneksi internet kamu, lalu coba lagi.\n\n'
            'Detail: $error';
        _isLoading = false;
      });
    }
  }

  // Menyaring negara berdasarkan pencarian dan wilayah.
  List<Country> get _filteredCountries {
    return _countries.where((country) {
      final matchesQuery =
          country.name.toLowerCase().contains(_query) ||
          country.capitalLabel.toLowerCase().contains(_query) ||
          country.region.toLowerCase().contains(_query);

      final matchesRegion =
          _selectedRegion == 'Semua' ||
          country.region == _selectedRegion;

      return matchesQuery && matchesRegion;
    }).toList(growable: false);
  }

  // Mendapatkan daftar wilayah yang tersedia.
  List<String> get _regions {
    final regions = _countries
        .map((country) => country.region)
        .where((region) => region.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    return ['Semua', ...regions];
  }

  // Menghitung total populasi seluruh negara.
  int get _totalPopulation => _countries.fold(
        0,
        (sum, country) => sum + country.population,
      );

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredCountries;
    final regions = _regions;

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadCountries,
          color: _goldBright,
          backgroundColor: _surface,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
                sliver: SliverToBoxAdapter(
                  child: _buildHeader(),
                ),
              ),

              // Tampilan loading.
              if (_isLoading)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: StateView(
                    icon: Icons.public_rounded,
                    title: 'Menjelajahi dunia...',
                    message:
                        'Sedang mengambil data negara terbaru dari REST Countries API.',
                    buttonLabel: 'Coba lagi',
                    onPressed: _loadCountries,
                    isLoading: true,
                  ),
                )

              // Tampilan error ketika API gagal.
              else if (_errorMessage != null)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: StateView(
                    icon: Icons.cloud_off_rounded,
                    title: 'Data gagal dimuat',
                    message:
                        '$_errorMessage\nPeriksa koneksi internet, lalu coba lagi.',
                    buttonLabel: 'Coba lagi',
                    onPressed: _loadCountries,
                  ),
                )

              // Tampilan utama jika data berhasil dimuat.
              else ...[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 22, 18, 0),
                  sliver: SliverToBoxAdapter(
                    child: CountryStats(
                      countryCount: _countries.length,
                      regionCount: _countries
                          .map((country) => country.region)
                          .toSet()
                          .length,
                      totalPopulation: _totalPopulation,
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 25, 18, 0),
                  sliver: SliverToBoxAdapter(
                    child: _buildSearch(),
                  ),
                ),

                SliverToBoxAdapter(
                  child: _buildRegionFilters(regions),
                ),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 22, 18, 8),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Negara di dunia',
                            style: TextStyle(
                              color: _textPrimary,
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          '${filtered.length} ditemukan',
                          style: const TextStyle(
                            color: _textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Jika hasil pencarian kosong.
                if (filtered.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: StateView(
                      icon: Icons.search_off_rounded,
                      title: 'Negara tidak ditemukan',
                      message:
                          'Coba kata kunci atau wilayah yang berbeda.',
                      buttonLabel: 'Hapus pencarian',
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _selectedRegion = 'Semua';
                        });
                      },
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                    sliver: SliverList.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return CountryCard(
                          country: filtered[index],
                        );
                      },
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),

      // Tombol refresh di kanan bawah.
      floatingActionButton:
          !_isLoading && _errorMessage == null
              ? FloatingActionButton.small(
                  onPressed: _loadCountries,
                  tooltip: 'Perbarui data',
                  backgroundColor: _gold,
                  foregroundColor: _background,
                  child: const Icon(
                    Icons.refresh_rounded,
                  ),
                )
              : null,
    );
  }

  // Header aplikasi.
  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                _goldBright,
                _gold,
              ],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.public_rounded,
            color: _background,
            size: 25,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Country Explorer',
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Kenali dunia dalam satu tempat',
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: _border,
            ),
          ),
          child: const Icon(
            Icons.explore_outlined,
            color: _gold,
            size: 20,
          ),
        ),
      ],
    );
  }

  // Kolom pencarian negara.
  Widget _buildSearch() {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _border,
        ),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(
          color: _textPrimary,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: 'Cari negara, ibu kota, wilayah...',
          hintStyle: const TextStyle(
            color: _textSecondary,
            fontSize: 12,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: _gold,
          ),
          suffixIcon: _query.isNotEmpty
              ? IconButton(
                  onPressed: _searchController.clear,
                  icon: const Icon(
                    Icons.close_rounded,
                    color: _goldSoft,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
        ),
      ),
    );
  }

  // Filter wilayah.
  Widget _buildRegionFilters(List<String> regions) {
    return SizedBox(
      height: 47,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
        scrollDirection: Axis.horizontal,
        itemCount: regions.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final region = regions[index];
          final selected = _selectedRegion == region;

          return ChoiceChip(
            label: Text(region),
            selected: selected,
            onSelected: (_) {
              setState(() {
                _selectedRegion = region;
              });
            },
            showCheckmark: false,
            labelStyle: TextStyle(
              color: selected ? _background : _textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            backgroundColor: _surfaceLight,
            selectedColor: _gold,
            side: BorderSide(
              color: selected ? _goldBright : _border,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          );
        },
      ),
    );
  }
}
