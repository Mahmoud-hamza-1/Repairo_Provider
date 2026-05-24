// class Statistics {
//   bool? success;
//   String? message;
//   RStatisticsData? data;

//   Statistics({this.success, this.message, this.data});

//   Statistics.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     message = json['message'];
//     data =
//         json['data'] != null
//             ? new RStatisticsData.fromJson(json['data'])
//             : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }

// class RStatisticsData {
//   int? pendingRequests;
//   int? acceptedRequests;
//   int? ongoingRequests;
//   int? completedRequests;
//   int? rejectedRequests;
//   int? canceledRequests;
//   int? totalRequests;
//   int? totalRevenues;

//   RStatisticsData({
//     this.pendingRequests,
//     this.acceptedRequests,
//     this.ongoingRequests,
//     this.completedRequests,
//     this.rejectedRequests,
//     this.canceledRequests,
//     this.totalRequests,
//     this.totalRevenues,
//   });

//   RStatisticsData.fromJson(Map<String, dynamic> json) {
//     pendingRequests = json['pending_requests'];
//     acceptedRequests = json['accepted_requests'];
//     ongoingRequests = json['ongoing_requests'];
//     completedRequests = json['completed_requests'];
//     rejectedRequests = json['rejected_requests'];
//     canceledRequests = json['canceled_requests'];
//     totalRequests = json['total_requests'];
//     totalRevenues = json['total_revenues'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['pending_requests'] = this.pendingRequests;
//     data['accepted_requests'] = this.acceptedRequests;
//     data['ongoing_requests'] = this.ongoingRequests;
//     data['completed_requests'] = this.completedRequests;
//     data['rejected_requests'] = this.rejectedRequests;
//     data['canceled_requests'] = this.canceledRequests;
//     data['total_requests'] = this.totalRequests;
//     data['total_revenues'] = this.totalRevenues;
//     return data;
//   }
// }

class RStatisticsData {
  int pendingRequests;
  int acceptedRequests;
  int ongoingRequests;
  int completedRequests;
  int rejectedRequests;
  int canceledRequests;
  int totalRequests;
  int totalRevenues;

  RStatisticsData({
    required this.pendingRequests,
    required this.acceptedRequests,
    required this.ongoingRequests,
    required this.completedRequests,
    required this.rejectedRequests,
    required this.canceledRequests,
    required this.totalRequests,
    required this.totalRevenues,
  });

  static int _asInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? double.tryParse(value)?.toInt() ?? 0;
    }
    return 0;
  }

  factory RStatisticsData.empty() {
    return RStatisticsData(
      pendingRequests: 0,
      acceptedRequests: 0,
      ongoingRequests: 0,
      completedRequests: 0,
      rejectedRequests: 0,
      canceledRequests: 0,
      totalRequests: 0,
      totalRevenues: 0,
    );
  }

  factory RStatisticsData.fromJson(Map<String, dynamic> json) {
    return RStatisticsData(
      pendingRequests: _asInt(json['pending_requests']),
      acceptedRequests: _asInt(json['accepted_requests']),
      ongoingRequests: _asInt(json['ongoing_requests']),
      completedRequests: _asInt(json['completed_requests']),
      rejectedRequests: _asInt(json['rejected_requests']),
      canceledRequests: _asInt(json['canceled_requests']),
      totalRequests: _asInt(json['total_requests']),
      totalRevenues: _asInt(json['total_revenues']),
    );
  }

  @override
  String toString() {
    return 'Pending: $pendingRequests, Accepted: $acceptedRequests, Ongoing: $ongoingRequests, Completed: $completedRequests, Rejected: $rejectedRequests, Canceled: $canceledRequests, Total Requests: $totalRequests, Total Revenues: $totalRevenues';
  }
}
