import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'verify_phone.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  final String userName;
  // البيانات الإضافية اللي هتتنقل للـ HomeScreen
  final String firstName;
  final String lastName;
  final String phone;
  final String gender;
  final String dob;
  final String governorate;

  const VerifyEmailScreen({
    super.key,
    required this.email,
    required this.userName,
    this.firstName = '',
    this.lastName = '',
    this.phone = '',
    this.gender = '',
    this.dob = '',
    this.governorate = '',
  });

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool isLoading = false;
  bool isResending = false;

  String get _fullCode => _controllers.map((c) => c.text).join();

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  Future<void> _verifyCode() async {
    if (_fullCode.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete 6-digit code'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => isLoading = false);
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VerifyPhoneScreen(
          phoneNumber: widget.phone,
          userName: widget.userName,
          firstName: widget.firstName,
          lastName: widget.lastName,
          email: widget.email,
          phone: widget.phone,
          gender: widget.gender,
          dob: widget.dob,
          governorate: widget.governorate,
        ),
      ),
    );
  }

  Future<void> _resendCode() async {
    setState(() => isResending = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => isResending = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Code resent to ${widget.email}'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) _focusNodes[index + 1].requestFocus();
    if (value.isEmpty && index > 0) _focusNodes[index - 1].requestFocus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final isSmall = h < 680;

    return Scaffold(
      backgroundColor: const Color(0xFF0B2A4A),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: h * 0.02),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: isSmall ? 20 : 24,
                      ),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                    ),
                    SizedBox(height: isSmall ? h * 0.03 : h * 0.06),
                    Text(
                      'Verify Your Email',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmall ? w * 0.055 : w * 0.065,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: h * 0.015),
                    Text(
                      'We sent a code to',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: w * 0.038,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.email,
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: w * 0.038,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(height: isSmall ? h * 0.03 : h * 0.05),
                    Text(
                      'Verification Code',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: w * 0.04,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: h * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6,
                        (i) => SizedBox(
                          width: w * 0.13,
                          child: TextFormField(
                            controller: _controllers[i],
                            focusNode: _focusNodes[i],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (v) => _onChanged(v, i),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: w * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: isSmall ? h * 0.012 : h * 0.018,
                              ),
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
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: isSmall ? h * 0.03 : h * 0.05),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _verifyCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(
                            vertical: isSmall ? h * 0.015 : h * 0.02,
                          ),
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
                                'Verify & Continue',
                                style: TextStyle(
                                  fontSize: w * 0.045,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: h * 0.03),
                    Center(
                      child: GestureDetector(
                        onTap: isResending ? null : _resendCode,
                        child: isResending
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Resend Code',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: w * 0.04,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: h * 0.04),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
