// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ChattingScreen extends StatelessWidget {
//   ChattingScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: Colors.teal,
//         titleSpacing: 0,
//         title: Row(
//           children: [
//             CircleAvatar(
//               radius: 20,
//               backgroundImage: NetworkImage(
//                 "https://i.pravatar.cc/150?img=3", // صورة وهمية للعميل
//               ),
//             ),
//             const SizedBox(width: 10),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "محمد اليوسف",
//                   style: GoogleFonts.cairo(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//                 Text(
//                   "متصل الآن",
//                   style: GoogleFonts.cairo(fontSize: 12, color: Colors.white70),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.call, color: Colors.white),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: const Icon(Icons.videocam, color: Colors.white),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // قائمة الرسائل
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.all(12),
//               children: [
//                 _buildMessage("مرحبا أستاذ، حابب احجز موعد", false),
//                 _buildMessage("أهلا وسهلا، فيك بكرا الساعة 4؟", true),
//                 _buildMessage("تمام، شكرا كتير 🙏", false),
//                 _buildMessage("على راسي 🌹", true),
//               ],
//             ),
//           ),
//           // حقل الإدخال
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//             color: Colors.white,
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(
//                     Icons.add_circle_outline,
//                     color: Colors.teal,
//                   ),
//                   onPressed: () {},
//                 ),
//                 Expanded(
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: "اكتب رسالتك...",
//                       hintStyle: GoogleFonts.cairo(),
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send, color: Colors.teal),
//                   onPressed: () {},
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessage(String text, bool isMe) {
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 4),
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//         decoration: BoxDecoration(
//           color: isMe ? Colors.teal : Colors.grey[300],
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(14),
//             topRight: const Radius.circular(14),
//             bottomLeft:
//                 isMe ? const Radius.circular(14) : const Radius.circular(0),
//             bottomRight:
//                 isMe ? const Radius.circular(0) : const Radius.circular(14),
//           ),
//         ),
//         child: Text(
//           text,
//           style: GoogleFonts.cairo(
//             fontSize: 14,
//             color: isMe ? Colors.white : Colors.black87,
//           ),
//         ),
//       ),
//     );
//   }
// }
