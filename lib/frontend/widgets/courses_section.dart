/// Courses Section - Displays a horizontal list of recommended courses
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'course_detail_modal.dart';

class CoursesSection extends StatefulWidget {
  final String job;
  
  const CoursesSection({super.key, required this.job});

  @override
  State<CoursesSection> createState() => _CoursesSectionState();
}

class _CoursesSectionState extends State<CoursesSection> {
  Future<List<Map<String, dynamic>>>? _coursesFuture;

  @override
  void initState() {
    super.initState();
    _coursesFuture = _loadCourses();
  }

  Future<List<Map<String, dynamic>>> _loadCourses() async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'courses_${widget.job}';
    final cache = prefs.getString(cacheKey);

    // Check cache (1 hour TTL)
    if (cache != null) {
      final cached = json.decode(cache);
      final cacheTime = cached['cacheTime'] as int;
      if (DateTime.now().millisecondsSinceEpoch - cacheTime < 60 * 60 * 1000) {
        return List<Map<String, dynamic>>.from(cached['data']);
      }
    }

    // Fetch from API
    return _fetchCourses(prefs, cacheKey);
  }

  Future<List<Map<String, dynamic>>> _fetchCourses(
    SharedPreferences prefs,
    String cacheKey,
  ) async {
    final url =
        "http://127.0.0.1:8000/api/courses?job=${Uri.encodeComponent(widget.job)}&per_page=4";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final courses = List<Map<String, dynamic>>.from(data['courses'] ?? []);

      // Cache the results
      await prefs.setString(
        cacheKey,
        json.encode({
          'cacheTime': DateTime.now().millisecondsSinceEpoch,
          'data': courses,
        }),
      );

      return courses;
    } else {
      throw Exception('Failed to load courses');
    }
  }

  void _retry() {
    setState(() {
      _coursesFuture = _loadCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Courses",
              style: theme.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 24,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "See all",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: _coursesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  children: [
                    Text(
                      "Failed to load courses",
                      style: TextStyle(color: Colors.red[700]),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _retry,
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            }

            final courses = snapshot.data ?? [];
            if (courses.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Text(
                    "No courses found",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              );
            }

            return SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < courses.length - 1 ? 16 : 0,
                    ),
                    child: CourseCard(courseData: courses[index]),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

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
      return '${(count / 1000).toStringAsFixed(1)}k People';
    }
    return '$count People';
  }

  String _formatDuration(int hours) {
    if (hours == 0) return '10 Hours'; // Default
    if (hours >= 100) {
      return '${hours} Hours';
    }
    return '$hours Hours';
  }

  @override
  Widget build(BuildContext context) {
    final title = courseData['title'] ?? 'Course Title';
    final rating = courseData['rating'] ?? 4.5;
    final learners = courseData['learners_count'] ?? 1000;
    final duration = courseData['duration'] ?? 10;
    final price = courseData['price'] ?? '800';
    final isPaid = courseData['is_paid'] ?? false;
    final color = _getCardColor(courseData.hashCode);

    return GestureDetector(
      onTap: () => showCourseDetailModal(context, courseData),
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  // Price
                  Text(
                    isPaid ? '\$$price' : 'Free',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Stats
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _StatBadge(
                        icon: Icons.star_rounded,
                        text: rating.toString(),
                      ),
                      _StatBadge(text: _formatDuration(duration)),
                      _StatBadge(text: _formatLearners(learners)),
                    ],
                  ),
                ],
              ),
            ),
            // Decorative illustration
            Positioned(
              right: -20,
              top: 60,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData? icon;
  final String text;

  const _StatBadge({this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 12),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
