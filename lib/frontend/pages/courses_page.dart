import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/course_card.dart';

class CoursesPage extends StatefulWidget {
  final String job;

  const CoursesPage({super.key, required this.job});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  List<dynamic> _courses = [];
  bool _isLoading = true;
  String? _error;
  final ScrollController _scrollController = ScrollController();
  int _page = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadCourses();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadCourses() async {
    if (!_hasMore || _isLoadingMore) return;

    setState(() {
      _isLoading = _page == 0;
      _isLoadingMore = true;
      if (_page == 0) _error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = 'courses_${widget.job}_page_${_page}';
      final cache = prefs.getString(cacheKey);
      
      List<dynamic> courses;
      
      if (cache != null) {
        final cached = json.decode(cache);
        courses = List<Map<String, dynamic>>.from(cached);
      } else {
        final response = await http.get(Uri.parse(
          'http://127.0.0.1:8000/api/courses?job=${Uri.encodeComponent(widget.job)}&page=$_page&per_page=10',
        ));

        if (response.statusCode != 200) {
          throw Exception('Failed to load courses');
        }

        final data = json.decode(response.body);
        courses = List<Map<String, dynamic>>.from(data['courses'] ?? []);
        
        // Cache the results for 1 hour
        await prefs.setString(
          cacheKey,
          json.encode(courses),
        );
      }

      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
        _courses.addAll(courses);
        _page++;
        _hasMore = courses.length == 10; // Assuming 10 items per page
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
        _error = 'Failed to load courses. Please try again.';
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      _loadCourses();
    }
  }

  void _refresh() {
    setState(() {
      _page = 0;
      _courses = [];
      _hasMore = true;
    });
    _loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Courses'),
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
    if (_isLoading && _courses.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _courses.isEmpty) {
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

    if (_courses.isEmpty) {
      return const Center(
        child: Text('No courses found'),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _refresh(),
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _courses.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _courses.length) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final course = _courses[index];
          return CourseCard(courseData: course);
        },
      ),
    );
  }
}
