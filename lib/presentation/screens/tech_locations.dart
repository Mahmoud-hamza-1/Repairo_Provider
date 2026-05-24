import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repairo_provider/business_logic/TechLocationsCubit/tech_locations_cubit.dart';
import 'package:repairo_provider/business_logic/TechLocationsCubit/tech_locations_states.dart';
import 'package:repairo_provider/core/constants/app_constants.dart';
import 'package:repairo_provider/presentation/widgets/custom_elevated_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Address {
  final String title;
  final String addressLine;
  final LatLng location;

  Address({
    required this.title,
    required this.addressLine,
    required this.location,
  });
}

class TechLocationsScreen extends StatefulWidget {
  final String id;
  const TechLocationsScreen({super.key, required this.id});

  @override
  TechLocationsScreenState createState() => TechLocationsScreenState();
}

class TechLocationsScreenState extends State<TechLocationsScreen> {
  String? activeLocationId;

  Future<void> _loadActiveLocation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      activeLocationId = prefs.getString('active_location_id');
    });
  }

  Future<void> _setActiveLocation(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('active_location_id', id);

    setState(() {
      activeLocationId = id;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadActiveLocation();
    BlocProvider.of<TechLocationsCubit>(context).getLocations(widget.id);
  }

  final MapController _mapController = MapController();

  // final List<Address> _addresses = [
  //   Address(
  //     title: 'مكتب الشركة',
  //     addressLine:
  //         '578, Eslamtower, Al Khail Rd - Dubai - United Arab Emirates',
  //     location: LatLng(25.1972, 55.2744),
  //   ),
  //   Address(
  //     title: 'بيت احمد',
  //     addressLine: '888, H, 17A St - Muhaisnah - Dubai - United Arab Emirates',
  //     location: LatLng(25.2635, 55.3860),
  //   ),
  // ];

  // بيانات النموذج لإضافة عنوان جديد
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController typecontroller = TextEditingController();
  LatLng? _pickedLocation;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    typecontroller.dispose();
    super.dispose();
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lng&format=json',
    );

    final response = await http.get(
      url,
      headers: {
        'User-Agent': 'REPAIRO_PROVIDER', // شرط لازم لـ Nominatim
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['display_name'] ?? "عنوان غير معروف";
    } else {
      return "خطأ في جلب العنوان";
    }
  }

  void _openAddAddressSheet() {
    _nameController.clear();
    _addressController.clear();
    _pickedLocation = null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => DraggableScrollableSheet(
            initialChildSize: 0.75,
            minChildSize: 0.4,
            maxChildSize: 0.95,
            builder:
                (_, controller) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListView(
                      controller: controller,
                      children: [
                        // handle
                        Center(
                          child: Container(
                            width: 60,
                            height: 6,
                            margin: EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),

                        SizedBox(height: 8),

                        // الخريطة (flutter_map)
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 240,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: FlutterMap(
                                  mapController: _mapController,
                                  options: MapOptions(
                                    initialCenter: LatLng(
                                      33.5138,
                                      36.2765,
                                    ), // مركز افتراضي
                                    initialZoom: 15.0,
                                    onLongPress: (tapPos, latlng) async {
                                      setState(() {
                                        _pickedLocation = latlng;
                                      });

                                      String address =
                                          await getAddressFromLatLng(
                                            latlng.latitude,
                                            latlng.longitude,
                                          );
                                      print("العنوان: $address");
                                    },
                                    onTap: (tapPos, latlng) async {
                                      String address =
                                          await getAddressFromLatLng(
                                            latlng.latitude,
                                            latlng.longitude,
                                          );
                                      print("العنوان: $address");

                                      setState(() {
                                        _pickedLocation = latlng;
                                        _addressController.text = address; // صح
                                      });
                                    },
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      subdomains: ['a', 'b', 'c'],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Icon(
                              Icons.location_pin,
                              size: 40,
                              color: Colors.redAccent,
                            ),
                            Positioned(
                              top: 12,
                              left: 12,
                              child: FloatingActionButton(
                                heroTag: "btn1",
                                backgroundColor: Colors.white,
                                mini: true,
                                onPressed: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  String lat = prefs.getString('lat')!;
                                  String lng = prefs.getString('lng')!;

                                  String address = await getAddressFromLatLng(
                                    double.parse(lat),
                                    double.parse(lng),
                                  );
                                  print("العنوان: $address");

                                  setState(() {
                                    _pickedLocation = LatLng(
                                      double.parse(lat),
                                      double.parse(lng),
                                    );
                                    _addressController.text = address; // صح
                                  });

                                  setState(() async {
                                    final latitude = double.parse(
                                      prefs.getString('lat')!,
                                    );
                                    final longitude = double.parse(
                                      prefs.getString('lng')!,
                                    );

                                    _mapController.move(
                                      LatLng(latitude, longitude),
                                      15,
                                    );
                                  });
                                },
                                child: Icon(
                                  Icons.my_location,
                                  color: Colors.teal,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 12),

                        // عنوان الموقع (نص يعرض العنوان المأخوذ من pick أو placeholder)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            _pickedLocation == null
                                ? 'ضع الدبوس بدقة على الخريطة'
                                : 'تم اختيار موقع',
                            style: GoogleFonts.cairo(fontSize: 14),
                          ),
                        ),

                        SizedBox(height: 12),

                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                controller: _addressController,
                                textDirection: TextDirection.rtl,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                    fontFamily: "Cairo",
                                    color: Colors.grey,
                                  ),
                                  hintText: 'اسم الشارع - اسم العمارة',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.teal),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.teal),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.teal),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.teal),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                ),
                                validator:
                                    (v) =>
                                        (v == null || v.trim().isEmpty)
                                            ? 'ادخل تفاصيل العنوان'
                                            : null,
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                controller: typecontroller,
                                textDirection: TextDirection.rtl,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                    fontFamily: "Cairo",
                                    color: Colors.grey,
                                  ),
                                  hintText: 'علامة بارزة',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.teal),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.teal),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.teal),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.teal),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: _nameController,
                                textDirection: TextDirection.rtl,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                    fontFamily: "Cairo",
                                    color: Colors.grey,
                                  ),
                                  hintText: "رقم المنزل / الشقة (اختياري)",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.teal),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.teal),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.teal),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.teal),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                ),
                                validator:
                                    (v) =>
                                        (v == null || v.trim().isEmpty)
                                            ? 'ادخل اسم للموقع'
                                            : null,
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () async {
                                  // if (_formKey.currentState!.validate()) {
                                  //   if (_pickedLocation == null) {
                                  //     // لو ما تم اختيار موقع، نعرض تحذير بسيط
                                  //     ScaffoldMessenger.of(context).showSnackBar(
                                  //       SnackBar(
                                  //           content:
                                  //               Text('الرجاء وضع الدبوس على الخريطة')),
                                  //     );
                                  //     return;
                                  //   }

                                  Get.defaultDialog(
                                    title: "...جاري تسجيل الموقع ",
                                    titleStyle: TextStyle(fontFamily: "Cairo"),
                                    content: const Column(
                                      children: [
                                        CircularProgressIndicator(
                                          color: Colors.teal,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "الرجاء الانتظار.",
                                          style: TextStyle(fontFamily: "Cairo"),
                                        ),
                                      ],
                                    ),
                                    barrierDismissible: false,
                                  );
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  final url = Uri.parse(
                                    '${AppConstants.baseUrl}/technician/saved-location',
                                  );
                                  var token = prefs.getString('auth_token');
                                  final response = await http.post(
                                    url,
                                    headers: {
                                      'Authorization': 'Bearer $token',
                                      'Content-Type': 'application/json',
                                    },
                                    body: jsonEncode({
                                      'address': _addressController.text,
                                      'lat': '${_pickedLocation!.latitude}',
                                      'lng': '${_pickedLocation!.longitude}',
                                      'type': typecontroller.text,
                                    }),
                                  );

                                  if (response.statusCode == 200) {
                                    Get.back();
                                    Get.defaultDialog(
                                      title: '',
                                      titlePadding: EdgeInsets.zero,
                                      content: Column(
                                        children: [
                                          SizedBox(
                                            width: 48,
                                            height: 48,
                                            child: Image.asset(
                                              "assets/images/png/locations.png",
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "تم تسجيل موقعك  ",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontFamily: "Cairo",
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      confirm: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 60,
                                          vertical: 12,
                                        ),
                                        child: CustomElevatedButton(
                                          text: 'موافق',
                                          onpressed:
                                              () =>
                                                  Get.offAllNamed("mainscreen"),
                                        ),
                                      ),
                                      barrierDismissible: false,
                                    );
                                  } else {
                                    Get.back();
                                    Get.defaultDialog(
                                      title: '',
                                      titlePadding: EdgeInsets.zero,
                                      content: Column(
                                        children: [
                                          SizedBox(
                                            width: 48,
                                            height: 48,
                                            child: Image.asset(
                                              "assets/images/png/locationf.png",
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "عذراً, لم يتم تسجيل الموقع \n  حصلت مشكلة",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontFamily: "Cairo",
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      confirm: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 60,
                                          vertical: 12,
                                        ),
                                        child: CustomElevatedButton(
                                          text: 'موافق',
                                          onpressed: () {
                                            Get.back();
                                          },
                                        ),
                                      ),
                                      barrierDismissible: false,
                                    );

                                    print(
                                      'Failed to get user info: ${response.statusCode}',
                                    );
                                    throw Exception('logout failed');

                                    // Navigator.of(context).pop();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: Text(
                                  'حفظ العنوان',
                                  style: GoogleFonts.cairo(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ),
    );
  }

  void _openMapEdit(Address address) {
    // يمكنك فتح نفس ال bottom sheet مع تحديد الموقع الحالي
    _pickedLocation = address.location;
    _nameController.text = address.title;
    _addressController.text = address.addressLine;
    _openAddAddressSheet();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          iconTheme: IconThemeData(color: Colors.black87),
          title: Text(
            'إدارة العناوين',
            style: GoogleFonts.cairo(color: Colors.black87),
          ),
          actions: [
            TextButton.icon(
              onPressed: _openAddAddressSheet,
              icon: Icon(Icons.add, color: Colors.teal),
              label: Text(
                'إضافة عنوان ',
                style: GoogleFonts.cairo(color: Colors.teal),
              ),
            ),
          ],
        ),
        body: BlocBuilder<TechLocationsCubit, TechLocationsStates>(
          builder: (context, state) {
            if (state is TechLocationsLoaded) {
              final addresses = (state).locations;
              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      itemCount: addresses.length,
                      separatorBuilder: (_, __) => Divider(height: 1),
                      itemBuilder: (context, index) {
                        final a = addresses[index];
                        return ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Container(
                              color: Colors.grey.shade300,
                              child: ListTile(
                                leading: Radio<String>(
                                  value: a.id!,
                                  groupValue: activeLocationId,
                                  onChanged: (value) async {
                                    if (value != null) {
                                      _setActiveLocation(value);
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.setString('lat', a.lat!);
                                      await prefs.setString('lng', a.lng!);
                                      await prefs.setString(
                                        'user_current_location',
                                        a.address!,
                                      );

                                      Get.defaultDialog(
                                        title: "...جاري تغيير الموقع ",
                                        titleStyle: TextStyle(
                                          fontFamily: "Cairo",
                                        ),
                                        content: const Column(
                                          children: [
                                            CircularProgressIndicator(
                                              color: Colors.teal,
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              "الرجاء الانتظار.",
                                              style: TextStyle(
                                                fontFamily: "Cairo",
                                              ),
                                            ),
                                          ],
                                        ),
                                        barrierDismissible: false,
                                      );

                                      final url = Uri.parse(
                                        '${AppConstants.baseUrl}/technician/location',
                                      );
                                      var token = prefs.getString('auth_token');
                                      final response = await http.post(
                                        url,
                                        headers: {
                                          'Authorization': 'Bearer $token',
                                          'Content-Type': 'application/json',
                                        },
                                        body: jsonEncode({
                                          'lat': '${a.lat}',
                                          'lng': '${a.lng}',
                                          'is_available': "1",
                                        }),
                                      );
                                      if (response.statusCode == 200) {
                                        print("tech location doneeeeeee");
                                      } else {
                                        print("tech location failed");
                                      }

                                      Future.delayed(
                                        const Duration(seconds: 4),
                                        () {
                                          if (Get.isDialogOpen!) {
                                            Get.back(); // بيسكر الديالوج
                                            // إذا بدك مباشرة يروح على الشاشة الرئيسية
                                            // Get.offAllNamed("mainscreen");
                                            Get.defaultDialog(
                                              title: '',
                                              titlePadding: EdgeInsets.zero,
                                              content: Column(
                                                children: [
                                                  SizedBox(
                                                    width: 48,
                                                    height: 48,
                                                    child: Image.asset(
                                                      "assets/images/png/locations.png",
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  const Text(
                                                    "تم تسجيل موقعك",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: "Cairo",
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              confirm: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 60,
                                                      vertical: 12,
                                                    ),
                                                child: CustomElevatedButton(
                                                  text: 'موافق',
                                                  onpressed:
                                                      () => Get.offAllNamed(
                                                        "mainscreen",
                                                      ),
                                                ),
                                              ),
                                              barrierDismissible: false,
                                            );
                                          }
                                        },
                                      );
                                    }
                                  },
                                  activeColor: Colors.teal,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                trailing: CircleAvatar(
                                  backgroundColor: Colors.teal.shade200,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.delete_forever_rounded,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () async {
                                      Get.defaultDialog(
                                        title: "...جاري الحذف ",
                                        titleStyle: TextStyle(
                                          fontFamily: "Cairo",
                                        ),
                                        content: const Column(
                                          children: [
                                            CircularProgressIndicator(
                                              color: Colors.teal,
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              "الرجاء الانتظار.",
                                              style: TextStyle(
                                                fontFamily: "Cairo",
                                              ),
                                            ),
                                          ],
                                        ),
                                        barrierDismissible: false,
                                      );
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      final url = Uri.parse(
                                        '${AppConstants.baseUrl}/user/saved-location/${a.id}',
                                      );
                                      var token = prefs.getString('auth_token');
                                      final response = await http.delete(
                                        url,
                                        headers: {
                                          'Authorization': 'Bearer $token',
                                          'Content-Type': 'application/json',
                                        },
                                      );

                                      if (response.statusCode == 200) {
                                        Get.back();
                                        Get.defaultDialog(
                                          title: '',
                                          titlePadding: EdgeInsets.zero,
                                          content: Column(
                                            children: [
                                              SizedBox(
                                                width: 48,
                                                height: 48,
                                                child: Image.asset(
                                                  "assets/images/png/delete.png",
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                "تم حذف الموقع بنجاح",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontFamily: "Cairo",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          confirm: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 60,
                                              vertical: 12,
                                            ),
                                            child: CustomElevatedButton(
                                              text: 'موافق',
                                              onpressed:
                                                  () => Get.offAllNamed(
                                                    "mainscreen",
                                                  ),
                                            ),
                                          ),
                                          barrierDismissible: false,
                                        );
                                      } else {
                                        Get.back();
                                        Get.defaultDialog(
                                          title: '',
                                          titlePadding: EdgeInsets.zero,
                                          content: Column(
                                            children: [
                                              SizedBox(
                                                width: 48,
                                                height: 48,
                                                child: Image.asset(
                                                  "assets/images/png/deleteerror.png",
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                "عذراً, لم يتم حذف الطلب \n  حصلت مشكلة",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontFamily: "Cairo",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          confirm: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 60,
                                              vertical: 12,
                                            ),
                                            child: CustomElevatedButton(
                                              text: 'موافق',
                                              onpressed: () {
                                                Get.back();
                                              },
                                            ),
                                          ),
                                          barrierDismissible: false,
                                        );

                                        print(
                                          'Failed to get user info: ${response.statusCode}',
                                        );
                                        throw Exception('logout failed');
                                      }
                                    },
                                  ),
                                ),
                                title: Text(
                                  a.type!,
                                  style: GoogleFonts.cairo(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  a.address!,
                                  style: GoogleFonts.cairo(),
                                ),
                                onTap: () async {
                                  // إذا حابب تعيين الموقع بمجرد الضغط
                                  _setActiveLocation(a.id!);
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString('lat', a.lat!);
                                  await prefs.setString('lng', a.lng!);
                                  await prefs.setString(
                                    'user_current_location',
                                    a.address!,
                                  );
                                  Get.defaultDialog(
                                    title: "...جاري تغيير الموقع ",
                                    titleStyle: TextStyle(fontFamily: "Cairo"),
                                    content: const Column(
                                      children: [
                                        CircularProgressIndicator(
                                          color: Colors.teal,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "الرجاء الانتظار.",
                                          style: TextStyle(fontFamily: "Cairo"),
                                        ),
                                      ],
                                    ),
                                    barrierDismissible: false,
                                  );

                                  Future.delayed(const Duration(seconds: 3), () {
                                    if (Get.isDialogOpen!) {
                                      Get.back(); // بيسكر الديالوج
                                      // إذا بدك مباشرة يروح على الشاشة الرئيسية
                                      // Get.offAllNamed("mainscreen");
                                      Get.defaultDialog(
                                        title: '',
                                        titlePadding: EdgeInsets.zero,
                                        content: Column(
                                          children: [
                                            SizedBox(
                                              width: 48,
                                              height: 48,
                                              child: Image.asset(
                                                "assets/images/png/locations.png",
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                              "تم تسجيل موقعك",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: "Cairo",
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        confirm: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 60,
                                            vertical: 12,
                                          ),
                                          child: CustomElevatedButton(
                                            text: 'موافق',
                                            onpressed:
                                                () => Get.offAllNamed(
                                                  "mainscreen",
                                                ),
                                          ),
                                        ),
                                        barrierDismissible: false,
                                      );
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (state is TechLocationsFailed) {
              return Center(
                child: Text(
                  "تعذر جلب العناوين",
                  style: TextStyle(fontFamily: "Cairo"),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(color: Colors.teal),
              );
            }
          },
        ),
      ),
    );
  }
}
