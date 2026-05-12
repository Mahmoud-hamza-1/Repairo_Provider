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

  factory RStatisticsData.fromJson(Map<String, dynamic> json) {
    return RStatisticsData(
      pendingRequests: json['pending_requests'] ?? 0,
      acceptedRequests: json['accepted_requests'] ?? 0,
      ongoingRequests: json['ongoing_requests'] ?? 0,
      completedRequests: json['completed_requests'] ?? 0,
      rejectedRequests: json['rejected_requests'] ?? 0,
      canceledRequests: json['canceled_requests'] ?? 0,
      totalRequests: json['total_requests'] ?? 0,
      totalRevenues: json['total_revenues'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'Pending: $pendingRequests, Accepted: $acceptedRequests, Ongoing: $ongoingRequests, Completed: $completedRequests, Rejected: $rejectedRequests, Canceled: $canceledRequests, Total Requests: $totalRequests, Total Revenues: $totalRevenues';
  }
}
