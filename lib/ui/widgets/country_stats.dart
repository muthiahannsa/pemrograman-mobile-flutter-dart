import 'package:flutter/material.dart';

class CountryStats extends StatelessWidget {
  const CountryStats({
    required this.countryCount,
    required this.regionCount,
    required this.totalPopulation,
    super.key,
  });

  final int countryCount;
  final int regionCount;
  final int totalPopulation;

  String _compactNumber(int value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)} Miliar';
    }

    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)} Juta';
    }

    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            label: 'NEGARA',
            value: '$countryCount',
            icon: Icons.public_rounded,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _StatTile(
            label: 'WILAYAH',
            value: '$regionCount',
            icon: Icons.explore_rounded,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _StatTile(
            label: 'POPULASI',
            value: _compactNumber(totalPopulation),
            icon: Icons.groups_rounded,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),

      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: const Color(0xFF29364D),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Icon(
            icon,
            color: const Color(0xFFD4A853),
            size: 19,
          ),

          const SizedBox(height: 14),

          Text(
            label,

            style: const TextStyle(
              color: Color(0xFFE8D59B),
              fontSize: 9,
              letterSpacing: 0.7,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 5),

          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,

            child: Text(
              value,

              style: const TextStyle(
                color: Color(0xFFF8FAFC),
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}