class SubCategory {
  final String id;
  final String displayName;

  SubCategory({required this.id, required this.displayName});

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(id: json['id'], displayName: json['display_name']);
  }
}
