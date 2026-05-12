import 'package:equatable/equatable.dart';

class SubscriptionPlan extends Equatable {
  final String id;
  final String name;
  final String description;
  final String price;
  final int durationDays;
  final String status;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationDays,
    required this.status,
  });

  // Factory constructor لتحويل الـ JSON إلى كائن Dart
  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as String,
      durationDays: json['duration_days'] as int,
      status: json['status'] as String,
    );
  }

  @override
  List<Object?> get props => [id, name, price, durationDays, status];
}
