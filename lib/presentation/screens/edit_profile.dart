import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repairo_provider/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String address;
  final String image;
  const EditProfileScreen({
    super.key,
    required this.name,
    required this.address,
    required this.image,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController namecontroller;
  late final TextEditingController phonecontroller;
  late final TextEditingController addresscontroller;

  File? imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    namecontroller = TextEditingController(text: widget.name);
    addresscontroller = TextEditingController(text: widget.address);
    phonecontroller = TextEditingController(); // أو حط قيمة ابتدائية إذا عندك
  }

  @override
  void dispose() {
    namecontroller.dispose();
    phonecontroller.dispose();
    addresscontroller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );

      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
      } else {
        print('لم يتم اختيار صورة');
      }
    } catch (e) {
      print('حدث خطأ أثناء اختيار الصورة: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6B52AE),
        title: Text('Edit Profile', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundImage:
                      imageFile != null
                          ? FileImage(imageFile!) as ImageProvider
                          :
                          // Image.network(widget.image) as ImageProvider
                          NetworkImage(widget.image) as ImageProvider,

                  // AssetImage('assets/images/jpg/hamdan.jpg'),
                ),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFF6B52AE),
                  child: IconButton(
                    onPressed: _pickImage,
                    icon: Icon(Icons.camera_alt, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            buildTextField(
              Icons.person_outline,
              'Full Name',
              controller: namecontroller,
            ),
            SizedBox(height: 16),
            buildTextField(Icons.mail_outline, 'Email'),
            SizedBox(height: 16),
            buildTextField(
              Icons.phone_outlined,
              'Contact Number',
              controller: phonecontroller,
            ),
            SizedBox(height: 16),
            buildDropdownField('Select Country'),
            SizedBox(height: 16),
            buildTextField(
              Icons.location_on_outlined,
              'Address',
              controller: addresscontroller,
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6B52AE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  Get.defaultDialog(
                    title: "Loading...",
                    content: const Column(
                      children: [
                        CircularProgressIndicator(color: Colors.blueAccent),
                        SizedBox(height: 10),
                        Text("Please wait..."),
                      ],
                    ),
                    barrierDismissible: false,
                  );
                  print("oooooooooooooooooooooo");

                  var request = http.MultipartRequest(
                    'POST',
                    Uri.parse(
                      '${AppConstants.baseUrl}/technician/account/personal-info',
                    ),
                  );
                  request.headers['Authorization'] =
                      'Bearer ${AppConstants.globalAccessToken}';

                  request.fields['name'] = namecontroller.text;
                  request.fields['place'] = addresscontroller.text;

                  if (imageFile != null) {
                    request.files.add(
                      await http.MultipartFile.fromPath(
                        'image',
                        imageFile!.path,
                      ),
                    );
                  }

                  try {
                    var response = await request.send();
                    var body = await response.stream.bytesToString();

                    if (response.statusCode == 200) {
                      print(' تم التحديث بنجاح');
                      print(' الرد: $body');
                      Get.back();
                      Get.offAllNamed('mainscreen');
                    } else {
                      Get.back();
                      //Get.defaultDialog();
                      print(' فشل التحديث: ${response.statusCode}');
                      print(' الرد: $body');
                    }
                  } catch (e) {
                    print(' خطأ أثناء الإرسال: $e');
                  }
                },
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
    IconData icon,
    String hint, {
    String? initialValue,
    TextEditingController? controller,
  }) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Color(0xFFF2F2F2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget buildDropdownField(String hint) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(Icons.arrow_drop_down),
        filled: true,
        fillColor: Color(0xFFF2F2F2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      items:
          [
            'Syria',
            'USA',
            'Germany',
            'UAE',
          ].map((e) => DropdownMenuItem(child: Text(e), value: e)).toList(),
      onChanged: (val) {},
    );
  }
}
