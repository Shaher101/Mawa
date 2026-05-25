import 'package:flutter/material.dart';
import 'create_new_password_screen.dart';

// ============================================================
// TODO (Backend Team): ربط الـ API الخاص بـ Verify OTP Code
//
// [1] التحقق من كود إعادة التعيين:
//     POST /api/auth/verify-reset-code
//     Body: { "email": "user@example.com", "code": "123456" }
//     Response:
//       - نجاح:  { "success": true, "reset_token": "xxx" }
//       - فشل:   { "success": false, "message": "Invalid or expired code" }
//
// [2] إعادة إرسال الكود:
//     POST /api/auth/resend-reset-code
//     Body: { "email": "user@example.com" }
//     Response:
//       - نجاح:  { "success": true, "message": "Code resent" }
//       - فشل:   { "success": false, "message": "Too many requests" }
//
// بعد ما الـ Backend يخلص، ابحث عن كومنت "TODO: API_CALL"
// واستبدل الـ dummy logic بالـ HTTP request الحقيقي
// ============================================================

class CheckYourEmailScreen extends StatefulWidget {
  final String email;

  const CheckYourEmailScreen({super.key, required this.email});

  @override
  State<CheckYourEmailScreen> createState() => _CheckYourEmailScreenState();
}

class _CheckYourEmailScreenState extends State<CheckYourEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final codeController = TextEditingController();

  bool isLoading = false;
  bool isResending = false;

  // ============================================================
  // TODO: API_CALL [1] — التحقق من الكود
  // استبدل الـ dummy logic بـ:
  //
  // final response = await http.post(
  //   Uri.parse('https://your-api.com/api/auth/verify-reset-code'),
  //   headers: {'Content-Type': 'application/json'},
  //   body: jsonEncode({
  //     'email': widget.email,
  //     'code': codeController.text.trim(),
  //   }),
  // );
  // final data = jsonDecode(response.body);
  // if (data['success']) {
  //   Navigator.push(context, MaterialPageRoute(
  //     builder: (_) => CreateNewPasswordScreen(
  //       email: widget.email,
  //       resetToken: data['reset_token'],
  //     ),
  //   ));
  // } else {
  //   _showError(data['message']);
  // }
  // ============================================================
  Future<void> _verifyCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    // TODO: API_CALL [1] — استبدل الـ dummy logic ده بالـ API call الحقيقي
    await Future.delayed(const Duration(seconds: 1)); // dummy delay

    final email = widget.email;

    setState(() => isLoading = false);

    // ✅ روح لشاشة إنشاء كلمة مرور جديدة
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateNewPasswordScreen(
          email: email,
          // resetToken: data['reset_token'], // هيتبعت من الـ API
        ),
      ),
    );
  }

  // ============================================================
  // TODO: API_CALL [2] — إعادة إرسال الكود
  // استبدل الـ dummy logic بـ:
  //
  // final response = await http.post(
  //   Uri.parse('https://your-api.com/api/auth/resend-reset-code'),
  //   headers: {'Content-Type': 'application/json'},
  //   body: jsonEncode({'email': widget.email}),
  // );
  // final data = jsonDecode(response.body);
  // if (data['success']) {
  //   _showSuccess("Code resent successfully");
  // } else {
  //   _showError(data['message']);
  // }
  // ============================================================
  Future<void> _resendCode() async {
    setState(() => isResending = true);

    // TODO: API_CALL [2] — استبدل الـ dummy logic ده بالـ API call الحقيقي
    await Future.delayed(const Duration(seconds: 1)); // dummy delay

    setState(() => isResending = false);

    _showSuccess("Verification code resent successfully");
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  Widget _buildLogo(double screenWidth) {
    return Image.asset("images/logo.png", width: screenWidth * 0.35);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final bool isSmall = screenHeight < 680;

    final double titleFontSize = isSmall
        ? screenWidth * 0.055
        : screenWidth * 0.063;

    final double subtitleFontSize = isSmall
        ? screenWidth * 0.032
        : screenWidth * 0.036;

    final double labelFontSize = isSmall
        ? screenWidth * 0.034
        : screenWidth * 0.04;

    final double buttonFontSize = isSmall
        ? screenWidth * 0.038
        : screenWidth * 0.045;

    final double topSpacing = isSmall
        ? screenHeight * 0.035
        : screenHeight * 0.055;

    final double buttonVerticalPadding = isSmall
        ? screenHeight * 0.015
        : screenHeight * 0.02;

    return Scaffold(
      backgroundColor: const Color(0xFF0B2A4A),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: topSpacing),

                        // 🔙 Back Arrow
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.05),

                        // ✅ Logo
                        Center(child: _buildLogo(screenWidth)),

                        SizedBox(height: screenHeight * 0.035),

                        // 📧 Title
                        Center(
                          child: Text(
                            "Check Your Email",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.015),

                        // Subtitle مع الإيميل باللون البرتقالي
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: subtitleFontSize,
                                height: 1.6,
                              ),
                              children: [
                                const TextSpan(
                                  text: "We sent a verification code to ",
                                ),
                                TextSpan(
                                  text: widget.email,
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.045),

                        // ── Verification Code Label ──
                        Text(
                          "Verification Code",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: labelFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.01),

                        // ── Code Field ──
                        TextFormField(
                          controller: codeController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          style: const TextStyle(
                            color: Colors.black,
                            letterSpacing: 4,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          decoration: _inputDecoration(
                            "Enter 6-digit code",
                            screenHeight,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Verification code required";
                            }
                            if (value.length < 6) {
                              return "Code must be 6 digits";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: screenHeight * 0.03),

                        // ── Verify Code Button ──
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _verifyCode,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              disabledBackgroundColor: Colors.orange.withValues(
                                alpha: 0.6,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: buttonVerticalPadding,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
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
                                    "Verify Code",
                                    style: TextStyle(
                                      fontSize: buttonFontSize,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.025),

                        // ── Wrong email? Go back ──
                        Center(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(fontSize: subtitleFontSize),
                                children: [
                                  const TextSpan(
                                    text: "Wrong email? ",
                                    style: TextStyle(color: Colors.white60),
                                  ),
                                  const TextSpan(
                                    text: "Go back",
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.015),

                        // ── Didn't receive a code? Resend ──
                        Center(
                          child: GestureDetector(
                            onTap: isResending ? null : _resendCode,
                            child: isResending
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      color: Colors.orange,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: subtitleFontSize,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: "Didn't receive a code? ",
                                          style: TextStyle(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: "Resend",
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.04),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, double screenHeight) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey[500],
        letterSpacing: 0,
        fontWeight: FontWeight.normal,
      ),
      filled: true,
      fillColor: Colors.white,
      counterText: "", // إخفاء عداد الأحرف
      contentPadding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: screenHeight * 0.018,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.orange, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }
}
