import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:repairo_provider/business_logic/ProfileCubit/profile_cubit.dart';
import 'package:repairo_provider/business_logic/ProfileCubit/profile_states.dart';

class WalletPage extends StatefulWidget {
  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  void initState() {
    BlocProvider.of<ProfileCubit>(context).getUserData('any');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // 🔥 RTL
      child: Scaffold(
        body: BlocBuilder<ProfileCubit, ProfileStates>(
          builder: (context, state) {
            if (state is ProfileSuccess) {
              return Padding(
                padding: const EdgeInsets.only(top: 65, left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // العنوان + الرجوع
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const Icon(Icons.arrow_back_ios_new, size: 24),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "المحفظة",
                          style: TextStyle(
                            fontFamily: "Cairo",
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            // ممكن نفتح ماسح QR
                          },
                          child: Row(
                            children: const [
                              Icon(
                                Icons.qr_code_scanner_outlined,
                                size: 22,
                                color: Colors.teal,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "مسح وشحن",
                                style: TextStyle(
                                  fontFamily: "Cairo",
                                  color: Colors.teal,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // بطاقة الرصيد
                    Container(
                      height: 200,
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.teal, Colors.tealAccent],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "الرصيد الحالي",
                            style: TextStyle(
                              fontFamily: "Cairo",
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${state.userdata.account!.wallet} \$",
                            style: const TextStyle(
                              fontFamily: "Cairo",
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              // Get.to(() => MultiBlocProvider(
                              //       providers: [
                              //         BlocProvider(
                              //           create: (context) => AllbanksCubit(
                              //             BanksRepository(
                              //                 bankWebservices:
                              //                     BankWebservices()),
                              //           ),
                              //         ),
                              //         BlocProvider(
                              //           create: (context) => WalletTopupCubit(
                              //             WalletTopupRequestRepository(
                              //                 WalletTopupRequestWebservice()),
                              //           ),
                              //         ),
                              //       ],
                              //       child: FillWallet(),
                              //     ));
                            },
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.add_circle,
                                  color: Colors.white,
                                  size: 26,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "شحن المحفظة",
                                  style: TextStyle(
                                    fontFamily: "Cairo",
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // قائمة الخيارات
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildListItem(Icons.credit_card, "طرق الدفع"),
                          _divider(),
                          _buildListItem(
                            Icons.access_time,
                            "المعاملات",
                            onTap: () {
                              // print("llllllllllllllllllll");
                              // Get.to(() => MultiBlocProvider(
                              //       providers: [
                              //         BlocProvider(
                              //           create: (context) => AllWalletRequestsCubit(
                              //               AllWalletRequestsRepository(
                              //                   allWalletRequestsWebservice:
                              //                       AllWalletRequestsWebservice())),
                              //         ),
                              //         BlocProvider(
                              //           create: (context) => AllbanksCubit(
                              //               BanksRepository(
                              //                   bankWebservices:
                              //                       BankWebservices())),
                              //         ),
                              //       ],
                              //       child: AllWalletRequestsScreen(),
                              //     ));
                            },
                          ),
                          _divider(),
                          _buildListItem(
                            Icons.savings,
                            "الإكراميات الافتراضية",
                            trailingText: "لا يوجد",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return showLoadingIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget showLoadingIndicator() {
    return const Center(child: CircularProgressIndicator(color: Colors.teal));
  }

  Widget _divider() {
    return Divider(height: 1, color: Colors.grey.shade300);
  }

  Widget _buildListItem(
    IconData icon,
    String title, {
    String? trailingText,
    void Function()? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: "Cairo",
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing:
          trailingText != null
              ? Text(
                trailingText,
                style: const TextStyle(
                  fontFamily: "Cairo",
                  color: Colors.grey,
                  fontSize: 14,
                ),
              )
              : const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
      onTap: onTap,
    );
  }
}
