# Country Explorer — Flutter

Aplikasi satu halaman untuk menjelajahi negara menggunakan data live dari [REST Countries API](https://restcountries.com/). API ini dapat digunakan tanpa API key.

## Fitur
- Mengambil nama, nama resmi, bendera, ibu kota, populasi, wilayah, subwilayah, dan mata uang dari API.
- Ringkasan jumlah negara, wilayah, dan populasi berdasarkan data API yang berhasil dimuat.
- Pencarian negara, ibu kota, atau wilayah.
- Filter wilayah.
- Loading, error yang jelas, tombol coba lagi, pull-to-refresh, dan tombol refresh.
- Tampilan dark mode responsif.

## Struktur
```text
lib/
├── main.dart
├── models/country.dart
├── services/country_service.dart
└── ui/
    ├── screens/country_screen.dart
    └── widgets/
        ├── country_card.dart
        ├── country_stats.dart
        └── state_view.dart
```

## Menjalankan
Pastikan Flutter SDK terpasang, lalu jalankan dari folder proyek:

```bash
flutter pub get
flutter run
flutter analyze
```

`http` hanya digunakan di `lib/services/country_service.dart`. Model `Country` immutable dan dibuat melalui `factory Country.fromJson`. Widget menerima data melalui constructor; pengelolaan state berada di `CountryScreen`.
