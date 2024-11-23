class Blog {
  final String title;
  final String content;
  final String imageUrl;

  Blog({required this.title, required this.content, required this.imageUrl});

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      title: json['title'],
      content: json['content'],
      imageUrl: json['image'] ?? '',  // Handle missing image URL by providing a default empty string
    );
  }
}
