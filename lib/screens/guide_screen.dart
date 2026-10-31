import 'package:flutter/material.dart';
import '../widgets/tactical_legal_sheet.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'FOOD INTELLIGENCE GUIDE',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 16,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF94A3B8)),
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFF334155)),
            ),
            onSelected: (value) {
              if (value == 'legal') {
                TacticalLegalSheet.show(context, openGrubLegal);
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'legal',
                child: Row(
                  children: [
                    Icon(Icons.shield_outlined, color: Color(0xFF10B981), size: 18),
                    SizedBox(width: 10),
                    Text(
                      'Legal & Advisory',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Intro Box
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF10B981).withValues(alpha: 0.4),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.verified_user_rounded,
                        color: Color(0xFF10B981),
                        size: 22,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'The OpenGrub Manifesto',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'No paywalls. No sponsored products. No calorie shaming. OpenGrub provides pure, open-access intelligence on industrial food processing directly from the global Open Food Facts database.',
                    style: TextStyle(
                      color: Color(0xFFCBD5E1),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // NOVA Classification Section
            _buildSectionHeader('NOVA FOOD CLASSIFICATION SYSTEM'),
            const SizedBox(height: 10),
            _buildNovaCard(
              nova: 1,
              title: 'Unprocessed or Minimally Processed',
              color: const Color(0xFF10B981),
              desc: 'Fresh fruit, vegetables, whole grains, raw meat, eggs, milk, nuts, water. Clean real food with no added industrial substances.',
            ),
            const SizedBox(height: 8),
            _buildNovaCard(
              nova: 2,
              title: 'Processed Culinary Ingredients',
              color: const Color(0xFFEAB308),
              desc: 'Butter, olive oil, lard, sugar, salt, vinegar. Substances pressed or refined directly from nature to cook meals.',
            ),
            const SizedBox(height: 8),
            _buildNovaCard(
              nova: 3,
              title: 'Processed Foods',
              color: const Color(0xFFF97316),
              desc: 'Freshly baked breads, canned vegetables with salt, cured meats, cheeses. Simple foods combined with culinary ingredients to extend shelf life.',
            ),
            const SizedBox(height: 8),
            _buildNovaCard(
              nova: 4,
              title: 'Ultra-Processed Foods (UPFs)',
              color: const Color(0xFFEF4444),
              desc: 'Industrial formulations made mostly from extracted substances (seed oils, high fructose corn syrup, isolates) and synthesized flavorings, colors, and emulsifiers.',
            ),
            const SizedBox(height: 24),

            // Seed Oils Section
            _buildSectionHeader('WHY WE FLAG SEED OILS'),
            const SizedBox(height: 10),
            _buildFactCard(
              icon: Icons.opacity_rounded,
              iconColor: const Color(0xFFF59E0B),
              title: 'Industrial Refined Seed Oils',
              content: 'Canola, soybean, corn, cottonseed, and palm oils undergo high-heat chemical solvent extraction (often with hexane) and bleaching. They are high in unstable omega-6 linoleic acid and frequently oxidized in commercial frying.',
            ),
            const SizedBox(height: 12),

            // Artificial Dyes Section
            _buildSectionHeader('SYNTHETIC PETROLEUM DYES'),
            const SizedBox(height: 10),
            _buildFactCard(
              icon: Icons.palette_rounded,
              iconColor: const Color(0xFFEF4444),
              title: 'Red 40, Yellow 5 & Blue 1',
              content: 'Synthetic dyes derived from petroleum. Banned or required to carry warning labels in the European Union ("may have an adverse effect on activity and attention in children"), yet ubiquitous in US cereals, snacks, and drinks.',
            ),
            const SizedBox(height: 24),
            // Legal & Medical Disclaimer Card
            InkWell(
              onTap: () => TacticalLegalSheet.show(context, openGrubLegal),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shield_outlined, color: Color(0xFFF59E0B), size: 22),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About & Safety Advisory',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Open Food Facts attribution, terms, and health disclaimers',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF94A3B8),
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildNovaCard({
    required int nova,
    required String title,
    required Color color,
    required String desc,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'NOVA $nova',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 12,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFactCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
