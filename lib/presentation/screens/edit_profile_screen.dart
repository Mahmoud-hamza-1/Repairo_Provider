// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:repairo_provider/business_logic/ProfileCubit/edit_profile_cubit.dart';
// import 'package:repairo_provider/business_logic/ProfileCubit/edit_profile_state.dart';

// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({super.key});

//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final _nameController = TextEditingController();
//   final _locationController = TextEditingController();
//   File? _imageFile;

//   final Map<String, List<String>> syriaProvinces = {
//     'دمشق': ['المالكي', 'برزة', 'المزة', 'ركن الدين'],
//     'ريف دمشق': ['دوما', 'جرمانا', 'التل'],
//     'حمص': ['الوعر', 'بابا عمرو', 'القصير'],
//     'حلب': ['الأعظمية', 'صلاح الدين', 'السكري'],
//   };

//   String? selectedProvince;
//   List<String> selectedCities = [];

//   void _toggleCity(String city) {
//     setState(() {
//       if (selectedCities.contains(city)) {
//         selectedCities.remove(city);
//       } else {
//         selectedCities.add(city);
//       }
//     });
//   }

//   void _saveProfile() {
//     context.read<EditProfileCubit>().updateProfile(
//       name: _nameController.text,
//       image: _imageFile,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cityOptions =
//         selectedProvince != null ? syriaProvinces[selectedProvince!]! : [];

//     return BlocListener<EditProfileCubit, EditProfileState>(
//       listener: (context, state) {
//         if (state is EditProfileLoading) {
//           showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (_) => const Center(child: CircularProgressIndicator()),
//           );
//         } else if (state is EditProfileSuccess) {
//           Navigator.pop(context);
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("تم حفظ التعديلات بنجاح")),
//           );
//         } else if (state is EditProfileError) {
//           Navigator.pop(context);
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text(state.message)));
//         }
//       },
//       child: Scaffold(
//         backgroundColor: const Color.fromRGBO(246, 247, 249, 1),
//         appBar: AppBar(
//           backgroundColor: const Color.fromRGBO(95, 96, 185, 1),
//           title: const Text('تعديل البروفايل'),
//           centerTitle: true,
//           leading: const BackButton(color: Colors.white),
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Stack(
//                   alignment: Alignment.bottomRight,
//                   children: [
//                     CircleAvatar(
//                       radius: 45,
//                       backgroundImage:
//                           _imageFile != null
//                               ? FileImage(_imageFile!)
//                               : const AssetImage('assets/images/avatar.jpg')
//                                   as ImageProvider,
//                     ),
//                     GestureDetector(
//                       child: Container(
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Color.fromRGBO(95, 96, 185, 1),
//                         ),
//                         child: const Padding(
//                           padding: EdgeInsets.all(4),
//                           child: Icon(
//                             Icons.edit,
//                             color: Colors.white,
//                             size: 18,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               _buildTextField("الاسم", _nameController),
//               const SizedBox(height: 10),
//               DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   labelText: 'اختر المحافظة',
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(),
//                 ),
//                 value: selectedProvince,
//                 items:
//                     syriaProvinces.keys.map((province) {
//                       return DropdownMenuItem(
//                         value: province,
//                         child: Text(province),
//                       );
//                     }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedProvince = value;
//                     selectedCities.clear();
//                   });
//                 },
//               ),
//               const SizedBox(height: 10),
//               if (selectedProvince != null) ...[
//                 const Text(
//                   "اختر المدن",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 5),
//                 Wrap(
//                   spacing: 8,
//                   children:
//                       cityOptions.map((city) {
//                         final isSelected = selectedCities.contains(city);
//                         return FilterChip(
//                           label: Text(city),
//                           selected: isSelected,
//                           selectedColor: const Color.fromRGBO(120, 121, 202, 1),
//                           onSelected: (_) => _toggleCity(city),
//                           labelStyle: TextStyle(
//                             color: isSelected ? Colors.white : Colors.black,
//                           ),
//                         );
//                       }).toList(),
//                 ),
//               ],
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: _saveProfile,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color.fromRGBO(95, 96, 185, 1),
//                   minimumSize: const Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   "حفظ التعديلات",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(String label, TextEditingController controller) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }
// }
