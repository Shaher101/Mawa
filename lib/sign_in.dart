import 'package:flutter/material.dart';
import 'forgot_password_screen.dart';
import 'complete_profile_screen.dart';
import 'login_screen.dart';
import 'home_screen.dart';

// ============================================================
// TODO (Backend Team): ربط الـ API الخاص بالـ Login
//
// [1] التحقق من الإيميل والباسورد:
//     POST /api/auth/login
//     Body: { "email": "user@example.com", "password": "123456" }
//     Response:
//       - نجاح:  { "success": true, "token": "JWT_TOKEN", "user": {...} }
//       - فشل:   { "success": false, "message": "Invalid credentials" }
//
// بعد ما الـ Backend يخلص، ابحث عن كومنت "TODO: API_CALL"
// واستبدل الـ dummy logic بالـ HTTP request الحقيقي
// ============================================================

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool _obscurePassword = true;

  // ✅ Dummy: أي باسورد من 6 حروف بيشتغل — هيتشال لما الـ API يتربط
  final int _minPasswordLength = 6;

  bool isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  // ============================================================
  // TODO: API_CALL [1] — استبدل الـ dummy logic بـ:
  //
  // final response = await http.post(
  //   Uri.parse('https://your-api.com/api/auth/login'),
  //   headers: {'Content-Type': 'application/json'},
  //   body: jsonEncode({
  //     'email': emailController.text.trim(),
  //     'password': passwordController.text,
  //   }),
  // );
  // final data = jsonDecode(response.body);
  // if (data['success']) {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('token', data['token']);
  //   _goToHome(data['user']);
  // } else {
  //   _showError(data['message']);
  // }
  // ============================================================
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    // dummy delay لمحاكاة الـ API
    await Future.delayed(const Duration(seconds: 1));

    setState(() => isLoading = false);

    if (!mounted) return;

    // ✅ Dummy mode: أي إيميل valid + باسورد 6 حروف بيدخل
    _goToHome(emailController.text.trim());
  }

  void _goToHome(String email) {
    // ✅ بيبعت الإيميل كـ userName مؤقتاً
    // لما الـ API يتربط، هتبعت الـ full_name من الـ response بدله
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          userName: email,
          userEmail: email,
          // باقي البيانات هتيجي من الـ API response
          // userPhone: data['phone'],
          // userUniversity: data['university'],
          // userStudentId: data['student_id'],
          // userGender: data['gender'],
          // userDateOfBirth: data['date_of_birth'],
        ),
      ),
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
    passwordController.dispose();
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
        ? screenWidth * 0.048
        : screenWidth * 0.055;
    final double subtitleFontSize = isSmall
        ? screenWidth * 0.032
        : screenWidth * 0.037;
    final double labelFontSize = isSmall
        ? screenWidth * 0.034
        : screenWidth * 0.04;
    final double buttonFontSize = isSmall
        ? screenWidth * 0.038
        : screenWidth * 0.045;
    final double topSpacing = isSmall
        ? screenHeight * 0.04
        : screenHeight * 0.07;
    final double sectionSpacing = isSmall
        ? screenHeight * 0.02
        : screenHeight * 0.025;
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

                        // Logo
                        Center(child: _buildLogo(screenWidth)),

                        SizedBox(height: screenHeight * 0.03),

                        // Welcome
                        Center(
                          child: Text(
                            "Welcome Back!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.008),

                        Center(
                          child: Text(
                            "Sign in to continue",
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: subtitleFontSize,
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.045),

                        // ── Email ──
                        Text(
                          "Email Address",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: labelFontSize,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.black),
                          decoration: _inputDecoration(
                            "your.email@university.edu",
                            screenHeight,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Email required";
                            }
                            if (!isValidEmail(value.trim())) {
                              return "Invalid email format";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: sectionSpacing),

                        // ── Password ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Password",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: labelFontSize,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: labelFontSize * 0.9,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        TextFormField(
                          controller: passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(color: Colors.black),
                          decoration:
                              _inputDecoration(
                                "Enter your password",
                                screenHeight,
                              ).copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    );
                                  },
                                ),
                              ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password required";
                            }
                            if (value.length < _minPasswordLength) {
                              return "Min $_minPasswordLength characters";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: screenHeight * 0.04),

                        // ── Sign In Button ──
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _login,
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
                                    "Sign In",
                                    style: TextStyle(
                                      fontSize: buttonFontSize,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.025),

                        // ── Divider ──
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(color: Color(0x8affffff)),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'or',
                                style: TextStyle(color: Colors.white60),
                              ),
                            ),
                            const Expanded(
                              child: Divider(color: Colors.white54),
                            ),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.025),

                        // ── Google Button ──
                        Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CompleteProfileScreen(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: buttonVerticalPadding,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.g_mobiledata,
                                    color: Colors.red,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Continue with Google',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: buttonFontSize,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.04),

                        // ── Don't have an account? ──
                        Center(
                          child: Text.rich(
                            TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: subtitleFontSize,
                              ),
                              children: [
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Sign up",
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: subtitleFontSize,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
