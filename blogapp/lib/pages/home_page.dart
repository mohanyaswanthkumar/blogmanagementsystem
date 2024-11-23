import 'package:flutter/material.dart';
import '../models/blog.dart';
import '../services/api_service.dart';
import '../widgets/blog_card.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Blog> blogs = [];

  @override
  void initState() {
    super.initState();
    fetchBlogs();
  }

  Future<void> fetchBlogs() async {
    var fetchedBlogs = await ApiService.fetchBlogs();
    setState(() {
      blogs = fetchedBlogs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blogs"),
      ),
      body: ListView.builder(
        itemCount: blogs.length,
        itemBuilder: (context, index) {
          return BlogCard(blog: blogs[index]);
        },
      ),
    );
  }
}
