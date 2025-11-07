/// Featured Jobs Section - Displays a horizontal list of featured job postings
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'job_card.dart';

class FeaturedJobsSection extends StatefulWidget {
  final String jobname;
  final String? city;
  
  const FeaturedJobsSection({super.key, required this.jobname, this.city});

  @override
  State<FeaturedJobsSection> createState() => _FeaturedJobsSectionState();
}

class _FeaturedJobsSectionState extends State<FeaturedJobsSection> {
  Future<List<Map<String, dynamic>>>? _jobsFuture;

  @override
  void initState() {
    super.initState();
    _jobsFuture = _loadJobs();
  }

  Future<List<Map<String, dynamic>>> _loadJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'featured_jobs_${widget.jobname}';
    final cache = prefs.getString(cacheKey);

    // Check cache (5 minutes TTL)
    if (cache != null) {
      final cached = json.decode(cache);
      final cacheTime = cached['cacheTime'] as int;
      if (DateTime.now().millisecondsSinceEpoch - cacheTime < 5 * 60 * 1000) {
        return List<Map<String, dynamic>>.from(cached['data']);
      }
    }

    // Fetch from API
    return _fetchJobs(prefs, cacheKey);
  }

  Future<List<Map<String, dynamic>>> _fetchJobs(
    SharedPreferences prefs,
    String cacheKey,
  ) async {
    // Use new backend API
    final url =
        "http://127.0.0.1:8000/api/jobs/featured?job=${Uri.encodeComponent(widget.jobname)}&per_page=6";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final items = List<Map<String, dynamic>>.from(data['jobs'] ?? []);

      // Cache the results
      await prefs.setString(
        cacheKey,
        json.encode({
          'cacheTime': DateTime.now().millisecondsSinceEpoch,
          'data': items,
        }),
      );

      return items;
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _jobsFuture = _loadJobs();
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
              "Featured Jobs",
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            IconButton(
              onPressed: _refresh,
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh jobs',
              color: const Color(0xFF5271FF),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _jobsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        "Failed to load jobs",
                        style: TextStyle(color: Colors.red[700], fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _refresh,
                        icon: const Icon(Icons.refresh),
                        label: const Text("Refresh"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7356FF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final jobs = snapshot.data ?? [];
              if (jobs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.work_off_outlined, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      const Text(
                        "No jobs found",
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: _refresh,
                        icon: const Icon(Icons.refresh),
                        label: const Text("Refresh"),
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: jobs.map((job) => JobCard(jobData: job)).toList(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
