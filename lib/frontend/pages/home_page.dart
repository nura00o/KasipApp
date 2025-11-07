/// Home Page - Main dashboard with navigation to different sections
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../bottomnavigation.dart';
import '../widgets/profession_banner.dart';
import '../widgets/statistics_section.dart';
import '../widgets/featured_jobs.dart';
import '../widgets/courses_section.dart';
import 'profile_page.dart';
import 'vacancies_page.dart';
import 'courses_page.dart';

class HomePage extends StatefulWidget {
  final String name;
  final String job;
  final String? city;

  const HomePage({super.key, required this.name, required this.job, this.city});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? jobData;
  bool loading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadJobStats();
  }

  Future<void> _loadJobStats() async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'job_stats_${widget.job}';
    final cache = prefs.getString(cacheKey);
    if (cache != null) {
      final cached = json.decode(cache);
      final cacheTime = cached['cacheTime'] as int;
      if (DateTime.now().millisecondsSinceEpoch - cacheTime < 3600 * 1000) {
        setState(() {
          jobData = cached['data'];
          loading = false;
        });
        return;
      }
    }
    await _fetchJobStats(prefs, cacheKey);
  }

  Future<void> _fetchJobStats(SharedPreferences prefs, String cacheKey) async {
    setState(() => loading = true);
    final uri = Uri.parse(
      "http://127.0.0.1:8000/api/job_stats?job=${Uri.encodeComponent(widget.job)}",
    );
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      await prefs.setString(
        cacheKey,
        json.encode({
          'cacheTime': DateTime.now().millisecondsSinceEpoch,
          'data': data,
        }),
      );
      setState(() {
        jobData = data;
        loading = false;
      });
    } else {
      setState(() => loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки данных: ${res.statusCode}')),
        );
      }
    }
  }

  void _onNavigationTap(int index) {
    if (index == 3) {
      // Navigate to Profile Page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(
            name: widget.name,
            job: widget.job,
          ),
        ),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeader(name: widget.name),
          const SizedBox(height: 20),
          ProfessionBanner(job: widget.job),
          const SizedBox(height: 24),
          StatisticsSection(loading: loading, jobData: jobData),
          const SizedBox(height: 24),
          FeaturedJobsSection(jobname: widget.job, city: widget.city),
          const SizedBox(height: 24),
          CoursesSection(job: widget.job),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2E7FF),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildHomeContent(),
            VacanciesPage(job: widget.job, city: widget.city),
            CoursesPage(job: widget.job),
            // Profile page is handled via navigation
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onNavigationTap,
      ),
    );
  }
}

/// Profile Header - Displays welcome message and user avatar
class ProfileHeader extends StatelessWidget {
  final String name;
  
  const ProfileHeader({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome 👋",
              style: theme.textTheme.titleMedium!.copyWith(
                color: Colors.black54,
              ),
            ),
            Text(
              "$name!",
              style: theme.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
