/// Skills Card - Displays top skills for a profession
import 'package:flutter/material.dart';

class SkillsCard extends StatelessWidget {
  final List skills;
  final Color color;
  
  const SkillsCard({super.key, required this.skills, required this.color});

  List<String> _extractTopSkills(List skills) {
    if (skills.isEmpty) return ['Python', 'ML', 'AI'];

    // Tech keywords mapping for better skill extraction
    final techKeywords = {
      'python',
      'java',
      'javascript',
      'typescript',
      'react',
      'angular',
      'vue',
      'node',
      'django',
      'flask',
      'fastapi',
      'spring',
      'docker',
      'kubernetes',
      'aws',
      'azure',
      'gcp',
      'sql',
      'postgresql',
      'mongodb',
      'redis',
      'git',
      'linux',
      'api',
      'rest',
      'graphql',
      'microservices',
      'jenkins',
      'terraform',
      'ansible',
      'nginx',
      'apache',
      'mysql',
      'oracle',
      'agile',
      'scrum',
      'html',
      'css',
      'sass',
      'webpack',
      'ruby',
      'rails',
      'php',
      'golang',
      'rust',
      'kotlin',
      'swift',
      'flutter',
      'dart',
      'unity',
      'android',
      'ios',
      'leadership',
      'design',
      'figma',
      'sketch',
    };

    final stopWords = {
      'опыт',
      'работы',
      'знание',
      'умение',
      'навык',
      'работать',
      'the',
      'and',
      'or',
      'with',
      'for',
      'from',
      'have',
      'has',
      'will',
      'работа',
      'требуется',
      'необходимо',
      'желательно',
    };

    final validSkills = <String>[];
    final seenSkills = <String>{};

    for (var skill in skills) {
      if (validSkills.length >= 3) break;

      var skillStr = skill.toString().trim();
      if (skillStr.isEmpty) continue;

      final skillLower = skillStr.toLowerCase();

      // Skip if too short or too long
      if (skillLower.length < 2 || skillLower.length > 18) continue;

      // Skip stop words
      if (stopWords.contains(skillLower)) continue;

      // Skip if already added (case-insensitive)
      if (seenSkills.contains(skillLower)) continue;

      // Check if it's a known tech keyword
      final isKnownTech = techKeywords.any((kw) => skillLower.contains(kw));

      if (isKnownTech) {
        // Capitalize properly
        String displaySkill;
        if (skillLower == 'javascript') {
          displaySkill = 'JavaScript';
        } else if (skillLower == 'typescript') {
          displaySkill = 'TypeScript';
        } else if (skillLower == 'fastapi') {
          displaySkill = 'FastAPI';
        } else if (skillLower == 'mongodb') {
          displaySkill = 'MongoDB';
        } else if (skillLower == 'postgresql') {
          displaySkill = 'PostgreSQL';
        } else if (skillLower == 'nodejs' || skillLower == 'node.js') {
          displaySkill = 'Node.js';
        } else {
          // Capitalize first letter
          displaySkill =
              skillStr[0].toUpperCase() + skillStr.substring(1).toLowerCase();
        }

        validSkills.add(displaySkill);
        seenSkills.add(skillLower);
      }
    }

    // If we don't have 3 skills, add defaults
    if (validSkills.isEmpty) {
      return ['Python', 'Docker', 'FastAPI'];
    } else if (validSkills.length < 3) {
      final defaults = ['Docker', 'Git', 'Linux', 'API', 'SQL'];
      for (var def in defaults) {
        if (validSkills.length >= 3) break;
        if (!seenSkills.contains(def.toLowerCase())) {
          validSkills.add(def);
        }
      }
    }

    return validSkills.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    final displaySkills = _extractTopSkills(skills);

    return Container(
      width: 200,
      height: 120,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF7356FF),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7356FF).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Skills displayed as large bold text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: displaySkills.map((skill) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  skill,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          ),
          // "Top skills" label at bottom
          const Text(
            "Top skills",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
