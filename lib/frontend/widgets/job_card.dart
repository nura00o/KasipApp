/// Job Card - Displays a single job posting with details
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class JobCard extends StatelessWidget {
  final Map<String, dynamic> jobData;

  const JobCard({super.key, required this.jobData});

  String _formatSalary(Map<String, dynamic>? salary) {
    if (salary == null) return "Salary not specified";

    final from = salary['from'];
    final to = salary['to'];
    final currency = salary['currency'] ?? '';

    final currencySymbol =
        {'RUR': '₽', 'USD': '\$', 'EUR': '€', 'KZT': '₸'}[currency] ?? currency;

    if (from != null && to != null) {
      return '${_formatNumber(from)}-${_formatNumber(to)} $currencySymbol';
    } else if (from != null) {
      return 'from ${_formatNumber(from)} $currencySymbol';
    } else if (to != null) {
      return 'up to ${_formatNumber(to)} $currencySymbol';
    }
    return "Salary not specified";
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    }
    return number.toString();
  }

  List<String> _getTags(Map<String, dynamic> jobData) {
    final tags = <String>[];

    // Add employment type
    final employment = jobData['employment']?['name'];
    if (employment != null && employment.toString().isNotEmpty) {
      tags.add(employment.toString());
    }

    // Add schedule
    final schedule = jobData['schedule']?['name'];
    if (schedule != null && schedule.toString().isNotEmpty) {
      tags.add(schedule.toString());
    }

    // Add experience if available
    final experience = jobData['experience']?['name'];
    if (experience != null && experience.toString().isNotEmpty) {
      tags.add(experience.toString());
    }

    return tags.take(3).toList();
  }

  Color _getCardColor(int index) {
    final colors = [
      const Color(0xFF57B2FF), // Light blue
      const Color(0xFF23395D), // Dark blue
      const Color(0xFF7356FF), // Purple
      const Color(0xFF5271FF), // Blue
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    // Support both old and new API format
    final name = jobData['title'] ?? jobData['name'] ?? 'Unknown Position';
    final company = jobData['company'] ?? jobData['employer']?['name'] ?? 'Unknown Company';
    final area = jobData['location'] ?? jobData['area']?['name'] ?? 'Location not specified';
    final salary = jobData['salary'];
    final snippet = jobData['snippet'] ?? '';
    final url = jobData['url'] ?? jobData['alternate_url'] ?? '';
    final logoUrl = jobData['logo_url'] ?? jobData['employer']?['logo_urls']?['90'];
    final tags = _getTags(jobData);
    final color = _getCardColor(jobData.hashCode);

    return GestureDetector(
      onTap: () async {
        if (url.isNotEmpty) {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
      },
      child: Container(
        width: 300,
        height: 220,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with logo and title
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: logoUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            logoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.business,
                                  color: Colors.grey,
                                  size: 24,
                                ),
                              );
                            },
                          ),
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.business,
                            color: Colors.grey,
                            size: 24,
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                // Title and company
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        company,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Snippet
            if (snippet.isNotEmpty)
              Text(
                snippet,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 11,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            if (snippet.isNotEmpty) const SizedBox(height: 8),
            // Tags
            if (tags.isNotEmpty)
              Flexible(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            const Spacer(),
            // Salary and location
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    _formatSalary(salary is Map<String, dynamic> ? salary : null),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Text(
                    area,
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
