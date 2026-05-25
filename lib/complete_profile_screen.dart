import 'package:flutter/material.dart';
import 'verify_email_screen.dart';

class CompleteProfileScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;

  const CompleteProfileScreen({
    super.key,
    this.firstName = '',
    this.lastName = '',
    this.email = '',
  });

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  String gender = '';
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? selectedGovernorate;

  bool isEgyptPhone(String phone) =>
      RegExp(r'^01[0-2,5]{1}[0-9]{8}$').hasMatch(phone);

  final List<String> governorates = [
    'Cairo',
    'Giza',
    'Alexandria',
    'Dakahlia',
    'Red Sea',
    'Beheira',
    'Fayoum',
    'Gharbiya',
    'Ismailia',
    'Menofia',
    'Minya',
    'Qaliubiya',
    'New Valley',
    'Suez',
    'Aswan',
    'Assiut',
    'Beni Suef',
    'Port Said',
    'Damietta',
    'Sharkia',
    'South Sinai',
    'Kafr El Sheikh',
    'Matrouh',
    'Luxor',
    'Qena',
    'North Sinai',
    'Sohag',
  ];

  @override
  void dispose() {
    dobController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  void _onComplete() {
    if (gender.isEmpty) {
      _showSnack('Please select your gender', Colors.red);
      return;
    }
    if (dobController.text.isEmpty) {
      _showSnack('Please select your date of birth', Colors.red);
      return;
    }
    if (!isEgyptPhone(phoneController.text)) {
      _showSnack('Invalid Egyptian phone number', Colors.red);
      return;
    }
    if (selectedGovernorate == null) {
      _showSnack('Please select your governorate', Colors.red);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VerifyEmailScreen(
          email: widget.email,
          userName: '${widget.firstName} ${widget.lastName}'.trim(),
          firstName: widget.firstName,
          lastName: widget.lastName,
          phone: phoneController.text.trim(),
          gender: gender,
          dob: dobController.text.trim(),
          governorate: selectedGovernorate ?? '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0D2B55),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.06,
            vertical: size.height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.05),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Complete Your Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.055,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    if (widget.firstName.isNotEmpty)
                      Text(
                        'Hi, ${widget.firstName}! 👋',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    const SizedBox(height: 4),
                    const Text(
                      'Please fill all the information',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.04),

              // Gender
              const Text('Gender', style: TextStyle(color: Colors.white)),
              SizedBox(height: size.height * 0.015),
              Row(
                children: [
                  Expanded(child: _genderButton('Female')),
                  SizedBox(width: size.width * 0.04),
                  Expanded(child: _genderButton('Male')),
                ],
              ),

              SizedBox(height: size.height * 0.03),

              // DOB
              const Text(
                'Date of Birth',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: size.height * 0.01),
              _textField(
                controller: dobController,
                hint: 'dd/mm/yyyy',
                icon: Icons.calendar_today,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                    builder: (ctx, child) => Theme(
                      data: Theme.of(ctx).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Colors.orange,
                          onPrimary: Colors.white,
                        ),
                      ),
                      child: child!,
                    ),
                  );
                  if (picked != null) {
                    dobController.text =
                        '${picked.day}/${picked.month}/${picked.year}';
                  }
                },
              ),

              SizedBox(height: size.height * 0.02),

              // Phone
              const Text('Phone Number', style: TextStyle(color: Colors.white)),
              SizedBox(height: size.height * 0.01),
              _textField(
                controller: phoneController,
                hint: '01xxxxxxxxx',
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: size.height * 0.02),

              // Governorate
              const Text('Governorate', style: TextStyle(color: Colors.white)),
              SizedBox(height: size.height * 0.01),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedGovernorate,
                    hint: const Text('Select your governorate'),
                    isExpanded: true,
                    items: governorates
                        .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                        .toList(),
                    onChanged: (v) => setState(() => selectedGovernorate = v),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.05),

              SizedBox(
                width: double.infinity,
                height: size.height * 0.065,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: _onComplete,
                  child: const Text(
                    'Complete Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  Widget _genderButton(String value) {
    final isSelected = gender == value;
    return GestureDetector(
      onTap: () => setState(() => gender = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.orange : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.white,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                value == 'Female' ? Icons.female : Icons.male,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    TextInputType? keyboardType,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onTap: onTap,
      readOnly: onTap != null,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        suffixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.orange, width: 2),
        ),
      ),
    );
  }
}
