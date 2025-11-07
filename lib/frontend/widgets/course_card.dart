import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'course_detail_modal.dart';

class CourseCard extends StatelessWidget {
  final Map<String, dynamic> courseData;

  const CourseCard({super.key, required this.courseData});

  Color _getCardColor(int index) {
    final colors = [
      const Color(0xFF5B9FFF), // Blue
      const Color(0xFFB4E86C), // Green
      const Color(0xFFFF8A65), // Orange
      const Color(0xFFBA68C8), // Purple
    ];
    return colors[index % colors.length];
  }

  String _formatLearners(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    final title = courseData['title'] ?? 'Course Title';
    final rating = courseData['rating'] ?? 4.5;
    final learners = courseData['learners_count'] ?? 1000;
    final isPaid = courseData['is_paid'] ?? false;
    final price = courseData['price'] ?? 'Free';
    final color = _getCardColor(courseData.hashCode);

    return GestureDetector(
      onTap: () => showCourseDetailModal(context, courseData),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    rating.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    isPaid ? '\$$price' : 'Free',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.people, color: Colors.white70, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '${_formatLearners(learners)} learners',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
