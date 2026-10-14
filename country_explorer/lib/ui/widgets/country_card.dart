import 'package:flutter/material.dart';

import '../../models/country.dart';

class CountryCard extends StatelessWidget {
  const CountryCard({
    required this.country,
    super.key,
  });

  final Country country;

  String _formatPopulation(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final flagUrl = country.flagUrl
        .replaceFirst(
          'https://countries.dev/flags/',
          'https://flagcdn.com/w320/',
        )
        .replaceFirst(RegExp(r'\.svg$'), '.png');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF29364D),
        ),
      ),

      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),

            child: SizedBox(
              width: 76,
              height: 57,

              child: flagUrl.isEmpty
                  ? const ColoredBox(
                      color: Color(0xFF1C2940),
                      child: Icon(
                        Icons.flag_rounded,
                        color: Color(0xFFD4A853),
                      ),
                    )
                  : Image.network(
                      flagUrl,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) {
                        return const ColoredBox(
                          color: Color(0xFF1C2940),
                          child: Icon(
                            Icons.flag_rounded,
                            color: Color(0xFFD4A853),
                          ),
                        );
                      },
                    ),
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  country.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    color: Color(0xFFF8FAFC),
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFFD4A853),
                      size: 13,
                    ),

                    const SizedBox(width: 3),

                    Expanded(
                      child: Text(
                        country.capitalLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          color: Color(0xFF9CA9BC),
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Wrap(
                  spacing: 6,
                  runSpacing: 5,

                  children: [
                    _InfoPill(
                      icon: Icons.groups_2_outlined,
                      text: _formatPopulation(
                        country.population,
                      ),
                    ),

                    _InfoPill(
                      icon: Icons.public_outlined,
                      text: country.region,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 4),

          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFFD4A853),
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 4,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFF1C2940),
        borderRadius: BorderRadius.circular(7),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(
            icon,
            size: 11,
            color: const Color(0xFFF0C96A),
          ),

          const SizedBox(width: 4),

          Text(
            text,

            style: const TextStyle(
              color: Color(0xFFB8C2D1),
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}