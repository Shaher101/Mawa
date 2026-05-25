import 'dart:async';
import 'package:flutter/material.dart';
import 'sign_in.dart'; // ✅ بدلنا login_screen بـ sign_in_screen

class AppFlowScreen extends StatefulWidget {
  const AppFlowScreen({super.key});

  @override
  State<AppFlowScreen> createState() => _AppFlowScreenState();
}

class _AppFlowScreenState extends State<AppFlowScreen> {
  bool showSplash = true;
  PageController controller = PageController();
  int index = 0;

  final List<Map<String, String>> pages = [
    {
      "title": "Find Safe Student Housing",
      "desc":
          "Browse verified listings from trusted property owners near your university",
      "image": "images/logo.png",
    },
    {
      "title": "Match with Suitable Roommates",
      "desc":
          "Connect with compatible roommates based on personality and preferences",
      "image": "images/logo.png",
    },
    {
      "title": "Easy Booking Experience",
      "desc": "Book your place safely in a few simple steps",
      "image": "images/logo.png",
    },
  ];

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      setState(() {
        showSplash = false;
      });
    });
  }

  // ✅ دالة موحدة للـ navigation لـ SignInScreen
  void _goToSignIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 🟦 SPLASH
    if (showSplash) {
      return Scaffold(
        backgroundColor: const Color(0xFF0B2C5D),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("images/logo.png", width: screenWidth * 0.45),
                SizedBox(height: screenHeight * 0.04),
                const CircularProgressIndicator(color: Colors.orange),
              ],
            ),
          ),
        ),
      );
    }

    // 🟦 ONBOARDING
    return Scaffold(
      backgroundColor: const Color(0xFF0B2C5D),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => index = i),
                itemBuilder: (context, i) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          pages[i]["image"]!,
                          width: screenWidth * 0.55,
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        Text(
                          pages[i]["title"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.055,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          pages[i]["desc"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // 🔘 Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pages.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.all(4),
                  width: index == i ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: index == i ? Colors.orange : Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }),
            ),

            SizedBox(height: screenHeight * 0.02),

            // 🔘 Buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: index == pages.length - 1
                  // 🟩 آخر صفحة — Get Started → SignInScreen
                  ? SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _goToSignIn, // ✅ SignInScreen
                        child: Text(
                          "Get Started",
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  // 🟦 باقي الصفحات
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // ✅ Skip → SignInScreen
                        TextButton(
                          onPressed: _goToSignIn,
                          child: Text(
                            "Skip",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                        ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.06,
                            ),
                          ),
                          onPressed: () {
                            controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          },
                          child: Text(
                            "Next",
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),

            SizedBox(height: screenHeight * 0.03),
          ],
        ),
      ),
    );
  }
}
