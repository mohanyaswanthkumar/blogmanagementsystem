import 'package:flutter/material.dart';
import '../models/blog.dart';
import '../services/api_service.dart';
import '../widgets/blog_card.dart';

class MyBlogsPage extends StatefulWidget {
  const MyBlogsPage({Key? key}) : super(key: key);

  @override
  _MyBlogsPageState createState() => _MyBlogsPageState();
}

class _MyBlogsPageState extends State<MyBlogsPage> {
  List<Blog> myBlogs = [];

  @override
  void initState() {
    super.initState();
    fetchMyBlogs();
  }

  Future<void> fetchMyBlogs() async {
    var fetchedBlogs = await ApiService.fetchMyBlogs();
    setState(() {
      myBlogs = fetchedBlogs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Blogs"),
      ),
      body: ListView.builder(
        itemCount: myBlogs.length,
        itemBuilder: (context, index) {
          return BlogCard(blog: myBlogs[index]);
        },
      ),
    );
  }
}
