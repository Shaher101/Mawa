import 'package:flutter/material.dart';
import 'home_screen.dart';

class VerifyPhoneScreen extends StatefulWidget {
  final String phoneNumber;
  // البيانات الكاملة اللي هتتحول للـ HomeScreen
  final String userName;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String gender;
  final String dob;
  final String governorate;

  const VerifyPhoneScreen({
    super.key,
    required this.phoneNumber,
    this.userName = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.gender = '',
    this.dob = '',
    this.governorate = '',
  });

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool isLoading = false;

  void _onDigitEntered(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0)
      _focusNodes[index - 1].requestFocus();
  }

  String get _otpCode => _controllers.map((c) => c.text).join();

  Future<void> _verifyPhone() async {
    if (_otpCode.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the 6-digit code'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => isLoading = false);
    if (!mounted) return;

    // ── بعت كل البيانات لـ HomeScreen ──
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          userName: widget.userName.isNotEmpty
              ? widget.userName
              : '${widget.firstName} ${widget.lastName}'.trim(),
          userEmail: widget.email,
          userPhone: widget.phone,
          userGender: widget.gender,
          userDateOfBirth: widget.dob,
          userUniversity: widget.governorate, // مؤقتاً لحد ما يضاف حقل الجامعة
        ),
      ),
      (route) => false,
    );
  }

  void _resendSMS() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code resent successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0B2A4A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: h * 0.02),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    padding: EdgeInsets.zero,
                  ),
                ),
                SizedBox(height: h * 0.06),
                Image.asset('images/logo.png', width: w * 0.3),
                SizedBox(height: h * 0.05),
                Text(
                  'Verify Your Phone',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: w * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: h * 0.015),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'We sent a verification code to ',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: w * 0.035,
                    ),
                    children: [
                      TextSpan(
                        text: widget.phoneNumber.isNotEmpty
                            ? widget.phoneNumber
                            : widget.phone,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: h * 0.01),
                Text(
                  'Enter the 6-digit code sent via SMS',
                  style: TextStyle(color: Colors.white54, fontSize: w * 0.032),
                ),
                SizedBox(height: h * 0.04),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Verification Code',
                    style: TextStyle(color: Colors.white, fontSize: w * 0.04),
                  ),
                ),
                SizedBox(height: h * 0.015),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    6,
                    (i) => SizedBox(
                      width: w * 0.13,
                      child: TextField(
                        controller: _controllers[i],
                        focusNode: _focusNodes[i],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: TextStyle(
                          fontSize: w * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.orange,
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: h * 0.018,
                          ),
                        ),
                        onChanged: (v) => _onDigitEntered(v, i),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: h * 0.04),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _verifyPhone,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: h * 0.02),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Verify Phone',
                            style: TextStyle(
                              fontSize: w * 0.045,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: h * 0.025),
                GestureDetector(
                  onTap: _resendSMS,
                  child: RichText(
                    text: TextSpan(
                      text: "Didn't receive a code? ",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: w * 0.035,
                      ),
                      children: const [
                        TextSpan(
                          text: 'Resend SMS',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: h * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
