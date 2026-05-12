import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:repairo_provider/business_logic/SubscriptionCubit/subscription_cubit.dart';
import 'package:repairo_provider/business_logic/SubscriptionCubit/subscription_states.dart';
import 'package:repairo_provider/presentation/widgets/custom_elevated_button.dart';

class PaymentScreen extends StatefulWidget {
  final String? planid;
  final String? paymentmethod;
  final String? amount;
  const PaymentScreen({
    super.key,
    this.planid,
    this.paymentmethod,
    this.amount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with SingleTickerProviderStateMixin {
  final _cardFormKey = GlobalKey<FormState>();
  final _paypalFormKey = GlobalKey<FormState>();

  // Card fields
  final _nameCtrl = TextEditingController();
  final _cardCtrl = TextEditingController();
  final _expCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  bool _saveCard = true;

  // PayPal fields
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  // مبلغ تجريبي
  final double _amount = 49.99;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _cardCtrl.dispose();
    _expCtrl.dispose();
    _cvvCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  InputDecoration _decoration(
    String label, {
    Widget? prefixIcon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: prefixIcon,
      suffixIcon: suffix,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.teal, width: 1.6),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  // String? _validateCardNumber(String? v) {
  //   final digits = v?.replaceAll(' ', '') ?? '';
  //   if (digits.length < 13 || digits.length > 19) return 'رقم البطاقة غير صالح';
  //   // Luhn (مبسّط)
  //   int sum = 0;
  //   bool alt = false;
  //   for (int i = digits.length - 1; i >= 0; i--) {
  //     int n = int.tryParse(digits[i]) ?? 0;
  //     if (alt) {
  //       n *= 2;
  //       if (n > 9) n -= 9;
  //     }
  //     sum += n;
  //     alt = !alt;
  //   }
  //   if (sum % 10 != 0) return 'رقم البطاقة غير صالح';
  //   return null;
  // }

  String? _validateExp(String? v) {
    if (v == null || v.isEmpty) return 'أدخل تاريخ الانتهاء';
    final parts = v.split('/');
    if (parts.length != 2) return 'صيغة غير صحيحة (MM/YY)';
    final mm = int.tryParse(parts[0]) ?? 0;
    final yy = int.tryParse(parts[1]) ?? -1;
    if (mm < 1 || mm > 12) return 'شهر غير صالح';
    // افتراض 20YY
    final now = DateTime.now();
    final year = 2000 + yy;
    final endOfMonth = DateTime(year, mm + 1, 0);
    if (endOfMonth.isBefore(DateTime(now.year, now.month, 1))) {
      return 'البطاقة منتهية';
    }
    return null;
  }

  String? _validateCVV(String? v) {
    if (v == null || v.isEmpty) return 'أدخل CVV';
    if (v.length < 3 || v.length > 4) return 'CVV غير صالح';
    return null;
  }

  void _payWithCard() {
    if (_cardFormKey.currentState?.validate() != true) return;
    context.read<SubscriptionCubit>().subscribeplan(
      planid: widget.planid!,
      paymenttype: "electronic",
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'جاري تنفيذ الدفع بالبطاقة لمبلغ $_amount\$ ...',
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _payWithPayPal() {
    if (_paypalFormKey.currentState?.validate() != true) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تحويل إلى PayPal لمبلغ $_amount\$ ...',
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // RTL
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(
            context,
          ).colorScheme.copyWith(primary: Colors.teal, secondary: Colors.teal),
          textTheme: Theme.of(context).textTheme.apply(
            fontFamily: 'Cairo', // خط Cairo
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('الدفع'),
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            centerTitle: true,
            elevation: 0,
          ),
          body: BlocListener<SubscriptionCubit, SubscriptionPlanStates>(
            listener: (context, state) {
              if (state is SubscriptionPlanLoading) {
                Get.defaultDialog(
                  title: "...جاري التحميل ",
                  titleStyle: const TextStyle(fontFamily: "Cairo"),
                  content: const Column(
                    children: [
                      CircularProgressIndicator(color: Colors.teal),
                      SizedBox(height: 10),
                      Text(
                        "الرجاء الانتظار.",
                        style: TextStyle(fontFamily: "Cairo"),
                      ),
                    ],
                  ),
                  barrierDismissible: false,
                );
              } else if (state is SubscriptionPlanSuccess) {
                Get.back();
                Get.defaultDialog(
                  title: '',
                  titlePadding: const EdgeInsets.all(0),
                  content: Column(
                    children: [
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: SvgPicture.asset(
                          (state).message == "false"
                              ? "assets/images/png/warning.png"
                              : "assets/images/svg/checkc.svg",
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        (state).message == "false"
                            ? "فشلت عملية الدفع "
                            : "تم الدفع بنجاح ",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Cairo",
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  confirm: Padding(
                    padding: const EdgeInsets.only(
                      left: 63,
                      right: 63,
                      bottom: 12,
                    ),
                    child: CustomElevatedButton(
                      text: 'رجوع للرئيسية',
                      onpressed: () {
                        Get.toNamed("mainscreen");
                      },
                    ),
                  ),
                  barrierDismissible: false,
                );
              } else {
                if (Get.isDialogOpen!) {
                  Get.back();
                }
              }

              if (state is SubscriptionPlanError) {
                Get.snackbar(
                  "خطأ",
                  state.message,
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                  titleText: const Text(
                    "خطأ",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Cairo",
                    ),
                  ),
                  messageText: Text(
                    state.message,
                    style: const TextStyle(
                      fontFamily: "Cairo",
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                );
              }
            },
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.teal.shade100),
                    ),
                    child: const TabBar(
                      tabs: [Tab(text: 'بطاقة بنكية'), Tab(text: 'PayPal')],
                      labelColor: Colors.teal,
                      unselectedLabelColor: Colors.black54,
                      indicatorColor: Colors.teal,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        // استبدل الصور بشعاراتك
                        Container(
                          width: 42,
                          height: 28,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white30,
                          ),
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/images/png/visa.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 42,
                          height: 28,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white30,
                          ),
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/images/png/mc.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 42,
                          height: 28,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white30,
                          ),
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/images/png/paypal.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'المبلغ: ${widget.amount}\$',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: TabBarView(
                      children: [_buildCardTab(), _buildPayPalTab()],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Form(
        key: _cardFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // اسم حامل البطاقة
            TextFormField(
              controller: _nameCtrl,
              textInputAction: TextInputAction.next,
              decoration: _decoration(
                'اسم حامل البطاقة',
                prefixIcon: const Icon(Icons.person),
              ),
              validator:
                  (v) =>
                      (v == null || v.trim().length < 3)
                          ? 'أدخل اسمًا صحيحًا'
                          : null,
            ),
            const SizedBox(height: 12),

            // رقم البطاقة - تنسيق 4-4-4-4
            TextFormField(
              controller: _cardCtrl,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _CardNumberFormatter(),
              ],
              decoration: _decoration(
                'رقم البطاقة',
                prefixIcon: const Icon(Icons.credit_card),
              ),
              // validator: _validateCardNumber,
            ),
            const SizedBox(height: 12),

            // MM/YY + CVV
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _expCtrl,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _ExpiryDateFormatter(),
                    ],
                    decoration: _decoration(
                      'تاريخ الانتهاء (MM/YY)',
                      prefixIcon: const Icon(Icons.event),
                    ),
                    validator: _validateExp,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _cvvCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    decoration: _decoration(
                      'CVV',
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    obscureText: true,
                    validator: _validateCVV,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Switch(
                  value: _saveCard,
                  activeColor: Colors.white,
                  activeTrackColor: Colors.teal,
                  onChanged: (v) => setState(() => _saveCard = v),
                ),
                const SizedBox(width: 6),
                const Text('حفظ البطاقة للاستخدام لاحقًا'),
              ],
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.withOpacity(.15)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info, color: Colors.teal),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'يتم تشفير بياناتك وإرسالها بشكل آمن.',
                      style: TextStyle(height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _payWithCard,
                icon: const Icon(Icons.payments),
                label: const Text('ادفع الآن'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayPalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Form(
        key: _paypalFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // شعار PayPal (استبدله بالصورة)
            Container(
              height: 56,
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text('PayPal'),
                  ),
                  const SizedBox(width: 8),
                  const Text('تسجيل الدخول إلى PayPal'),
                ],
              ),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: _decoration(
                'البريد الإلكتروني',
                prefixIcon: const Icon(Icons.alternate_email),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'أدخل البريد الإلكتروني';
                final re = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                if (!re.hasMatch(v)) return 'بريد إلكتروني غير صالح';
                return null;
              },
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _passCtrl,
              obscureText: true,
              decoration: _decoration(
                'كلمة المرور',
                prefixIcon: const Icon(Icons.lock_outline),
              ),
              validator:
                  (v) =>
                      (v == null || v.length < 6) ? 'كلمة المرور قصيرة' : null,
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 52,
              child: OutlinedButton.icon(
                onPressed: _payWithPayPal,
                icon: const Icon(Icons.login),
                label: const Text('تابع إلى PayPal'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.teal,
                  side: const BorderSide(color: Colors.teal, width: 1.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'سيتم تحويلك لإتمام الدفع عبر PayPal بأمان.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// تنسيق رقم البطاقة: يضيف مسافة كل 4 أرقام
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      if ((i + 1) % 4 == 0 && i + 1 != digits.length) buffer.write(' ');
    }
    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

/// تنسيق تاريخ الانتهاء: MM/YY
class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll('/', '');
    if (text.length > 4) text = text.substring(0, 4);
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(text[i]);
    }
    final out = buffer.toString();
    return TextEditingValue(
      text: out,
      selection: TextSelection.collapsed(offset: out.length),
    );
  }
}
