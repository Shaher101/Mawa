import 'package:flutter/material.dart';
import 'check_your_email_screen.dart';

// ============================================================
// TODO (Backend Team): ربط الـ API الخاص بـ Forgot Password
//
// [1] إرسال كود إعادة تعيين كلمة المرور:
//     POST /api/auth/forgot-password
//     Body: { "email": "user@example.com" }
//     Response:
//       - نجاح:  { "success": true, "message": "Reset code sent" }
//       - فشل:   { "success": false, "message": "Email not registered" }
//
// بعد ما الـ Backend يخلص، ابحث عن كومنت "TODO: API_CALL"
// واستبدل الـ dummy logic بالـ HTTP request الحقيقي
// ============================================================

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  bool isLoading = false;

  // قائمة إيميلات وهمية للاختبار — هتتشال لما الـ API يتربط

  bool isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  // ============================================================
  // TODO: API_CALL [1] — إرسال كود إعادة تعيين كلمة المرور
  // استبدل الـ dummy logic بـ:
  //
  // final response = await http.post(
  //   Uri.parse('https://your-api.com/api/auth/forgot-password'),
  //   headers: {'Content-Type': 'application/json'},
  //   body: jsonEncode({
  //     'email': emailController.text.trim(),
  //   }),
  // );
  // final data = jsonDecode(response.body);
  // if (data['success']) {
  //   Navigator.push(context, MaterialPageRoute(
  //     builder: (_) => CheckYourEmailScreen(email: emailController.text.trim()),
  //   ));
  // } else {
  //   _showError(data['message']);
  // }
  // ============================================================
  Future<void> _sendResetCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    // TODO: API_CALL [1] — استبدل الـ dummy logic ده بالـ API call الحقيقي
    await Future.delayed(const Duration(seconds: 1)); // dummy delay

    final email = emailController.text.trim();

    // Dummy vlidation — هتتشال لما الـ API يتربط

    setState(() => isLoading = false);

    // ✅ روح لشاشة إدخال الـ OTP / Verification Code
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CheckYourEmailScreen(email: email)),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  // ✅ نفس الـ Logo Widget اللي في SignInScreen
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

                        // 🔙 Back Arrow — سهم بس بدون نص زي الصورة
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

                        // 🔑 Title — مطابق للصورة
                        Center(
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.015),

                        // Subtitle — مطابق للصورة
                        Center(
                          child: Text(
                            "Enter your email address and we'll send\nyou a verification code to reset your\npassword.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: subtitleFontSize,
                              height: 1.6,
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.045),

                        // ── Email Label ──
                        Text(
                          "Email Address",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: labelFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.01),

                        // ── Email Field ──
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.black),
                          decoration: _inputDecoration(
                            "your.email@example.com",
                            screenHeight,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email required";
                            }
                            if (!isValidEmail(value)) {
                              return "Invalid email format";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: screenHeight * 0.03),

                        // ── Send Reset Code Button — مطابق للصورة ──
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _sendResetCode,
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
                                    "Send Reset Code",
                                    style: TextStyle(
                                      fontSize: buttonFontSize,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.03),

                        // ── Back to Sign In — مطابق للصورة ──
                        Center(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              "Back to Sign In",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: subtitleFontSize,
                                fontWeight: FontWeight.w500,
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
      hintStyle: TextStyle(color: Colors.grey[500]),
      filled: true,
      fillColor: Colors.white,
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
