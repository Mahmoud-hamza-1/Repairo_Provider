class Category {
  final String id;
  final String displayName;

  Category({required this.id, required this.displayName});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'], displayName: json['display_name']);
  }
}
