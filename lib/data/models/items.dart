class Items {
  late int item_id;
  late String title;
  late String description;
  late String category;
  late String image;
  late double price;

  Items.fromjson(Map<String, dynamic> json) {
    item_id = json['id'];
    title = json['title'];
    description = json['description'];
    category = json['category'];
    price = (json['price'] as num).toDouble();
    image = json['image'];
  }
}
