import 'package:flutter/material.dart';
import 'complete_profile_screen.dart';
import 'sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  bool isValidEmail(String email) =>
      RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => isLoading = false);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => CompleteProfileScreen(
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          email: emailController.text.trim(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0B2A4A),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.04),

                    Center(child: _buildLogo(screenWidth)),

                    SizedBox(height: screenHeight * 0.02),

                    Center(
                      child: Text(
                        "Welcome to MA'WA!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.05,
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // ── Full Name ──
                    Text(
                      "Full Name",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: firstNameController,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            decoration: _inputDecoration("First Name"),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Required";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Expanded(
                          child: TextFormField(
                            controller: lastNameController,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            decoration: _inputDecoration("Last Name"),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Required";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // ── Email ──
                    Text(
                      "Email",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration("your.email@university.edu"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email required";
                        }
                        if (!isValidEmail(value)) return "Invalid email";
                        return null;
                      },
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // ── Password ──
                    Text(
                      "Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: _inputDecoration("Enter your password")
                          .copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                                size: 20,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password required";
                        }
                        if (value.length < 6) return "Min 6 characters";
                        return null;
                      },
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // ── Confirm Password ──
                    Text(
                      "Confirm Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: _obscureConfirm,
                      decoration: _inputDecoration("Confirm your password")
                          .copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirm
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                                size: 20,
                              ),
                              onPressed: () => setState(
                                () => _obscureConfirm = !_obscureConfirm,
                              ),
                            ),
                          ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please confirm your password";
                        }
                        if (value != passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // ── Sign Up Button ──
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
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
                                "Create Account",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // ── Divider ──
                    const Row(
                      children: [
                        Expanded(child: Divider(color: Color(0x8affffff))),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "or",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.white54)),
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
                            vertical: screenHeight * 0.018,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.g_mobiledata, color: Colors.red),
                              const SizedBox(width: 8),
                              Text(
                                "Continue with Google",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // ── Sign In ──
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Do you have an account? ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.038,
                            ),
                            children: const [
                              TextSpan(
                                text: "Sign in",
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
                    ),

                    SizedBox(height: screenHeight * 0.04),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(double screenWidth) {
    return Image.asset("images/logo.png", width: screenWidth * 0.35);
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
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
