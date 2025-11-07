/// Statistics Section - Displays job statistics including salary, vacancies, and top skills
import 'package:flutter/material.dart';
import 'skills_card.dart';

class StatisticsSection extends StatelessWidget {
  final bool loading;
  final Map<String, dynamic>? jobData;
  
  const StatisticsSection({
    super.key,
    required this.loading,
    required this.jobData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Statistics",
          style: theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: loading || jobData == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      StatCard(
                        value: "${jobData!['average_salary']} ₸",
                        title: "Average salary",
                        color: const Color(0xFF7356FF),
                        icon: Icons.check_circle_outline,
                      ),
                      StatCard(
                        value: "${jobData!['vacancies']}",
                        title: "Vacancies",
                        color: const Color(0xFF57B2FF),
                        icon: Icons.help_outline,
                      ),
                      SkillsCard(
                        skills: (jobData!['skills'] as List).take(3).toList(),
                        color: const Color(0xFFB6FFB0),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String value;
  final String title;
  final Color color;
  final IconData icon;
  
  const StatCard({
    super.key,
    required this.value,
    required this.title,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: Icon(icon, color: Colors.white24, size: 48),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
