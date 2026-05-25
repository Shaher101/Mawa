import 'package:flutter/material.dart';

// ============================================================
// TODO (Backend Team): ربط الـ API الخاص بـ Reset Password
//
// [1] إعادة تعيين كلمة المرور:
//     POST /api/auth/reset-password
//     Body: {
//       "email": "user@example.com",
//       "reset_token": "xxx",
//       "new_password": "newPass123"
//     }
//     Response:
//       - نجاح:  { "success": true, "message": "Password reset successfully" }
//       - فشل:   { "success": false, "message": "Invalid or expired token" }
//
// بعد ما الـ Backend يخلص، ابحث عن كومنت "TODO: API_CALL"
// واستبدل الـ dummy logic بالـ HTTP request الحقيقي
// ============================================================

class CreateNewPasswordScreen extends StatefulWidget {
  final String email;
  final String? resetToken; // هيتبعت من الـ API بعد التحقق من الكود

  const CreateNewPasswordScreen({
    super.key,
    required this.email,
    this.resetToken,
  });

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  // ============================================================
  // TODO: API_CALL [1] — إعادة تعيين كلمة المرور
  // استبدل الـ dummy logic بـ:
  //
  // final response = await http.post(
  //   Uri.parse('https://your-api.com/api/auth/reset-password'),
  //   headers: {'Content-Type': 'application/json'},
  //   body: jsonEncode({
  //     'email': widget.email,
  //     'reset_token': widget.resetToken,
  //     'new_password': newPasswordController.text.trim(),
  //   }),
  // );
  // final data = jsonDecode(response.body);
  // if (data['success']) {
  //   _showSuccessAndNavigate();
  // } else {
  //   _showError(data['message']);
  // }
  // ============================================================
  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    // TODO: API_CALL [1] — استبدل الـ dummy logic ده بالـ API call الحقيقي
    await Future.delayed(const Duration(seconds: 1)); // dummy delay

    setState(() => isLoading = false);

    _showSuccessAndNavigate();
  }

  void _showSuccessAndNavigate() {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Password reset successfully!"),
        backgroundColor: Colors.green,
      ),
    );

    // ✅ روح لشاشة تسجيل الدخول وامسح كل الشاشات السابقة
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(builder: (_) => const SignInScreen()),
    //   (route) => false,
    // );

    // مؤقتاً: ارجع لأول شاشة
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
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

                        // 🔒 Title
                        Center(
                          child: Text(
                            "Create New Password",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.015),

                        // Subtitle
                        Center(
                          child: Text(
                            "Your new password must be at least 6 characters",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: subtitleFontSize,
                              height: 1.6,
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.045),

                        // ── New Password Label ──
                        Text(
                          "New Password",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: labelFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.01),

                        // ── New Password Field ──
                        TextFormField(
                          controller: newPasswordController,
                          obscureText: _obscureNew,
                          style: const TextStyle(color: Colors.black),
                          decoration: _inputDecoration(
                            "Enter new password",
                            screenHeight,
                            suffixIcon: GestureDetector(
                              onTap: () =>
                                  setState(() => _obscureNew = !_obscureNew),
                              child: Icon(
                                _obscureNew
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password required";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: screenHeight * 0.025),

                        // ── Confirm Password Label ──
                        Text(
                          "Confirm New Password",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: labelFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.01),

                        // ── Confirm Password Field ──
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: _obscureConfirm,
                          style: const TextStyle(color: Colors.black),
                          decoration: _inputDecoration(
                            "Confirm new password",
                            screenHeight,
                            suffixIcon: GestureDetector(
                              onTap: () => setState(
                                () => _obscureConfirm = !_obscureConfirm,
                              ),
                              child: Icon(
                                _obscureConfirm
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please confirm your password";
                            }
                            if (value != newPasswordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: screenHeight * 0.04),

                        // ── Reset Password Button ──
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _resetPassword,
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
                                    "Reset Password",
                                    style: TextStyle(
                                      fontSize: buttonFontSize,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
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

  InputDecoration _inputDecoration(
    String hint,
    double screenHeight, {
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[500]),
      suffixIcon: suffixIcon,
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
