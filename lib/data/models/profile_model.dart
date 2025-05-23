class Profile {
  final String id;
  final String name;
  final String phone;
  final String? idCardImage;
  final String? selfieWithIdCard;
  final String? image;

  Profile({
    required this.id,
    required this.name,
    required this.phone,
    this.idCardImage,
    this.selfieWithIdCard,
    this.image,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      idCardImage: json['id_card_image'],
      selfieWithIdCard: json['selfie_with_id_card'],
      image: json['image'],
    );
  }
}
