import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/job_card.dart';

class VacanciesPage extends StatefulWidget {
  final String job;
  final String? city;

  const VacanciesPage({super.key, required this.job, this.city});

  @override
  State<VacanciesPage> createState() => _VacanciesPageState();
}

class _VacanciesPageState extends State<VacanciesPage> {
  List<dynamic> _jobs = [];
  bool _isLoading = true;
  String? _error;
  final ScrollController _scrollController = ScrollController();
  int _page = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadJobs();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadJobs() async {
    if (!_hasMore || _isLoadingMore) return;

    setState(() {
      _isLoading = _page == 0;
      _isLoadingMore = true;
      if (_page == 0) _error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = 'vacancies_${widget.job}_page_${_page}';
      final cache = prefs.getString(cacheKey);
      
      List<dynamic> jobs;
      
      if (cache != null) {
        final cached = json.decode(cache);
        jobs = List<Map<String, dynamic>>.from(cached);
      } else {
        final response = await http.get(Uri.parse(
          'http://127.0.0.1:8000/api/jobs/featured?job=${Uri.encodeComponent(widget.job)}&page=$_page&per_page=10',
        ));

        if (response.statusCode != 200) {
          throw Exception('Failed to load jobs');
        }

        final data = json.decode(response.body);
        jobs = List<Map<String, dynamic>>.from(data['items'] ?? []);
        
        // Cache the results for 5 minutes
        await prefs.setString(
          cacheKey,
          json.encode(jobs),
        );
      }

      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
        _jobs.addAll(jobs);
        _page++;
        _hasMore = jobs.length == 10; // Assuming 10 items per page
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
        _error = 'Failed to load jobs. Please try again.';
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      _loadJobs();
    }
  }

  void _refresh() {
    setState(() {
      _page = 0;
      _jobs = [];
      _hasMore = true;
    });
    _loadJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Vacancies'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _jobs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refresh,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_jobs.isEmpty) {
      return const Center(
        child: Text('No job vacancies found'),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _refresh(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: _jobs.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _jobs.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          
          final job = _jobs[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: JobCard(jobData: job),
          );
        },
      ),
    );
  }
}
