import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repairo_provider/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String address;
  final String image;
  final String phone;
  const EditProfileScreen({
    super.key,
    required this.name,
    required this.address,
    required this.image,
    required this.phone,
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
    phonecontroller = TextEditingController(
      text: widget.phone,
    ); // أو حط قيمة ابتدائية إذا عندك
    // phonecontroller = TextEditingController(
    //   text: "${widget.phone}+",
    // ); // أو حط قيمة ابتدائية إذا عندك
  }

  @override
  void dispose() {
    namecontroller.dispose();
    phonecontroller.dispose();
    addresscontroller.dispose();
    super.dispose();
  }

  // Future<void> _pickImage() async {
  //   try {
  //     final XFile? pickedFile =
  //         await _picker.pickImage(source: ImageSource.camera);

  //     if (pickedFile != null) {
  //       setState(() {
  //         imageFile = File(pickedFile.path);
  //       });
  //     } else {
  //       print('لم يتم اختيار صورة');
  //     }
  //   } catch (e) {
  //     print('حدث خطأ أثناء اختيار الصورة: $e');
  //   }
  // }

  Future<void> _pickImage() async {
    try {
      final source = await showDialog<ImageSource>(
        context: context,
        builder:
            (context) => AlertDialog(
              //shape:ShapeBorder() ,
              title: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  'اختر المصدر',
                  style: TextStyle(fontFamily: "Cairo"),
                ),
              ),
              content: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(Icons.camera_alt),
                      title: Text(
                        'الكاميرا',
                        style: TextStyle(fontFamily: "Cairo"),
                      ),
                      onTap: () => Navigator.pop(context, ImageSource.camera),
                    ),
                    ListTile(
                      leading: Icon(Icons.photo),
                      title: Text(
                        'المعرض',
                        style: TextStyle(fontFamily: "Cairo"),
                      ),
                      onTap: () => Navigator.pop(context, ImageSource.gallery),
                    ),
                  ],
                ),
              ),
            ),
      );

      if (source != null) {
        final XFile? pickedFile = await _picker.pickImage(source: source);

        if (pickedFile != null) {
          setState(() {
            imageFile = File(pickedFile.path);
          });
        } else {
          print('لم يتم اختيار صورة');
        }
      }
    } catch (e) {
      print('حدث خطأ أثناء اختيار الصورة: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Color(0xFF6B52AE),
      //   title: Text(
      //     'Edit Profile',
      //     style: TextStyle(color: Colors.black),
      //   ),
      //   leading: IconButton(
      //     onPressed: () {
      //       Get.back();
      //     },
      //     icon: Icon(
      //       Icons.arrow_back_ios,
      //       color: Colors.black,
      //     ),
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: Icon(
      //         Icons.check,
      //         color: Colors.black,
      //       ),
      //       onPressed: () {},
      //     )
      //   ],
      // ),
      body: SingleChildScrollView(
        // padding: EdgeInsets.only(left: 16, right: 16, top: 32),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 200.h,
                  child: Image.asset(
                    "assets/images/jpg/editprofile.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 80.h),
                // CircleAvatar(
                //   radius: 50,
                //   backgroundImage: imageFile != null
                //       ? FileImage(imageFile!) as ImageProvider
                //       :
                //       // Image.network(widget.image) as ImageProvider
                //       NetworkImage(widget.image) as ImageProvider,

                //   // AssetImage('assets/images/jpg/hamdan.jpg'),
                // ),
                SizedBox(height: 30),
                buildTextField(
                  Icons.person_outline,
                  'الاسم الكامل',
                  controller: namecontroller,
                ),
                SizedBox(height: 16),
                buildTextField(Icons.mail_outline, 'البريد الالكتروني'),
                SizedBox(height: 16),
                buildTextField(
                  Icons.phone_outlined,
                  'رقم التواصل',
                  controller: phonecontroller,
                  phone: true,
                ),
                SizedBox(height: 16),
                // buildDropdownField('Select Country'),
                buildTextField(
                  Icons.location_on_outlined,
                  'العنوان',
                  controller: addresscontroller,
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        Get.defaultDialog(
                          title: "...جاري التحميل",
                          titleStyle: TextStyle(fontFamily: "Cairo"),
                          content: const Column(
                            children: [
                              CircularProgressIndicator(color: Colors.teal),
                              SizedBox(height: 10),
                              Text(
                                "الرجاء الانتظار",
                                style: TextStyle(fontFamily: "Cairo"),
                              ),
                            ],
                          ),
                          barrierDismissible: false,
                        );
                        print("oooooooooooooooooooooo");

                        final prefs = await SharedPreferences.getInstance();
                        var token = prefs.getString('auth_token');
                        var request = http.MultipartRequest(
                          'POST',
                          Uri.parse(
                            '${AppConstants.baseUrl}/technician/profile',
                          ),
                        );
                        request.headers['Authorization'] = 'Bearer $token';

                        request.fields['_method'] = 'put';
                        request.fields['name'] = namecontroller.text;
                        request.fields['address'] = addresscontroller.text;

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
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "تم تعديل ملفك الشخصي",
                                  style: GoogleFonts.cairo(),
                                ),
                              ),
                            );
                            final prefs = await SharedPreferences.getInstance();

                            await prefs.setString(
                              'tech_name',
                              namecontroller.text,
                            );

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
                        'حفظ التغييرات',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: "Cairo",
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 44, left: 12, right: 12),
              child: Column(
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.arrow_back_ios_new_sharp,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              'تعديل الملف الشخصي',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: "Cairo",
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 70.h),
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    child: ClipOval(
                      child:
                          imageFile != null
                              ? Image.file(
                                imageFile!,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                              : CachedNetworkImage(
                                imageUrl: widget.image.replaceFirst(
                                  "127.0.0.1",
                                  AppConstants.baseaddress,
                                ),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) =>
                                        CircularProgressIndicator(),
                                errorWidget:
                                    (context, url, error) => Icon(Icons.error),
                              ),
                    ),
                  ),

                  SizedBox(height: 2.h),
                  TextButton(
                    onPressed: () {
                      _pickImage();
                    },
                    child: Text(
                      "تغيير الصورة",
                      style: TextStyle(
                        fontFamily: "Cairo",
                        color: Colors.black,
                        //fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
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
    bool phone = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          style: TextStyle(fontFamily: "Cairo", fontWeight: FontWeight.bold),
          keyboardType:
              phone == true ? TextInputType.phone : TextInputType.text,
          controller: controller,
          initialValue: initialValue,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey, width: 0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey, width: 0.5),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey, width: 0.5),
            ),
            hintText: hint,
            hintStyle: TextStyle(
              fontFamily: "Cairo",
              fontWeight: FontWeight.normal,
            ),
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: Colors.white30,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey, width: 0.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDropdownField(String hint) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DropdownButtonFormField<String>(
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
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (val) {},
      ),
    );
  }
}
