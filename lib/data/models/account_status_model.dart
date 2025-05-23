class AccountStatus {
  final String name;
  final String place;
  final String? personalImage;
  final String? identityImage;

  AccountStatus({
    required this.name,
    required this.place,
    this.personalImage,
    this.identityImage,
  });

  factory AccountStatus.fromJson(Map<String, dynamic> json) {
    final media = json['media'] as List<dynamic>;
    String? personal;
    String? identity;

    for (var item in media) {
      if (item['name'] == 'personal_image') personal = item['original_url'];
      if (item['name'] == 'identity_image') identity = item['original_url'];
    }

    return AccountStatus(
      name: json['name'],
      place: json['place'],
      personalImage: personal,
      identityImage: identity,
    );
  }
}
