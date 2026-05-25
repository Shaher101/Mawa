import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoomData {
  String id;
  int numberOfBeds;
  String coolingType;
  bool hasWindow;
  bool hasBalcony;
  bool hasDesk;
  bool hasWardrobe;
  int pricePerBed;
  int securityDepositPerBed;
  List<String> photos;

  RoomData({
    required this.id,
    required this.numberOfBeds,
    required this.coolingType,
    required this.hasWindow,
    required this.hasBalcony,
    required this.hasDesk,
    required this.hasWardrobe,
    required this.pricePerBed,
    required this.securityDepositPerBed,
    required this.photos,
  });
}

class AmenityItem {
  final String id;
  final String name;
  final IconData icon;

  const AmenityItem({required this.id, required this.name, required this.icon});
}

const _primary = Color(0xFF022B60);
const _accent = Color(0xFFFF751F);
const _accentSoft = Color(0xFFFFF1E8);
const _pageBg = Color(0xFFF8F9FB);

const _governorates = [
  'Cairo',
  'Giza',
  'Alexandria',
  'Mansoura',
  'Assiut',
  'Tanta',
  'Zagazig',
  'Ismailia',
];

const _amenities = [
  AmenityItem(id: 'wifi', name: 'WiFi', icon: Icons.wifi_rounded),
  AmenityItem(id: 'tv', name: 'TV', icon: Icons.tv_rounded),
  AmenityItem(id: 'elevator', name: 'Elevator', icon: Icons.apartment_rounded),
  AmenityItem(
    id: 'microwave',
    name: 'Microwave',
    icon: Icons.microwave_rounded,
  ),
  AmenityItem(id: 'freezer', name: 'Deep Freezer', icon: Icons.kitchen_rounded),
  AmenityItem(
    id: 'washer',
    name: 'Washing Machine',
    icon: Icons.local_laundry_service_rounded,
  ),
];

class ListPropertyFormScreen extends StatefulWidget {
  final String userId;
  final VoidCallback? onBack;
  final Function(Map<String, dynamic>)? onComplete;

  const ListPropertyFormScreen({
    super.key,
    required this.userId,
    this.onBack,
    this.onComplete,
  });

  @override
  State<ListPropertyFormScreen> createState() => _ListPropertyFormScreenState();
}

class _ListPropertyFormScreenState extends State<ListPropertyFormScreen> {
  int _currentStep = 0;
  bool _isSubmitting = false;
  bool _isConfirmed = false;
  bool _isOwnerVerified = false;
  String? _idFrontPath;
  String? _idBackPath;
  String? _expandedRoomId;

  final _nationalIdController = TextEditingController();
  final _districtController = TextEditingController();
  final _addressController = TextEditingController();
  final _buildingController = TextEditingController();
  final _floorController = TextEditingController(text: '1');
  final _rulesController = TextEditingController();

  String _governorate = '';
  String _genderPreference = 'male';
  String _religionPreference = 'muslim';
  String _utilitiesBill = 'student';
  String _gasType = 'natural';
  String _waterHeater = 'electric';
  final List<String> _selectedAmenities = [];
  final List<String> _livingRoomPhotos = [];
  final List<String> _bathroomPhotos = [];
  final List<String> _kitchenPhotos = [];
  int _coverPhotoIndex = 0;
  Map<String, String> _errors = {};

  final List<RoomData> _rooms = [
    RoomData(
      id: '1',
      numberOfBeds: 1,
      coolingType: 'fan',
      hasWindow: true,
      hasBalcony: false,
      hasDesk: false,
      hasWardrobe: true,
      pricePerBed: 0,
      securityDepositPerBed: 0,
      photos: [],
    ),
  ];

  final _steps = [
    {'title': 'Location', 'icon': Icons.location_on_rounded},
    {'title': 'Utilities', 'icon': Icons.home_repair_service_rounded},
    {'title': 'Photos', 'icon': Icons.camera_alt_rounded},
    {'title': 'Rooms', 'icon': Icons.bed_rounded},
    {'title': 'Review', 'icon': Icons.check_circle_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _expandedRoomId = _rooms.first.id;
  }

  @override
  void dispose() {
    _nationalIdController.dispose();
    _districtController.dispose();
    _addressController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    _rulesController.dispose();
    super.dispose();
  }

  int get _totalBeds => _rooms.fold(0, (sum, room) => sum + room.numberOfBeds);

  int get _totalMonthlyRent => _rooms.fold(
    0,
    (sum, room) => sum + (room.pricePerBed * room.numberOfBeds),
  );

  int get _totalDeposit => _rooms.fold(
    0,
    (sum, room) => sum + (room.securityDepositPerBed * room.numberOfBeds),
  );

  int get _totalPhotos =>
      _livingRoomPhotos.length + _bathroomPhotos.length + _kitchenPhotos.length;

  bool _isExistingLocalPhoto(String path) => path.isNotEmpty;

  bool _hasAnyUploadedPropertyPhoto() {
    return [
      ..._livingRoomPhotos,
      ..._bathroomPhotos,
      ..._kitchenPhotos,
    ].any(_isExistingLocalPhoto);
  }

  List<TextInputFormatter> _nationalIdInputFormatters() {
    return <TextInputFormatter>[
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(14),
    ];
  }

  bool _validateStep() {
    final errors = <String, String>{};
    if (_currentStep == 0) {
      if (_governorate.isEmpty) {
        errors['governorate'] = 'Governorate is required';
      }
      if (_districtController.text.trim().isEmpty) {
        errors['district'] = 'District is required';
      }
      if (_addressController.text.trim().isEmpty) {
        errors['address'] = 'Address is required';
      }
    }
    if (_currentStep == 3) {
      for (final room in _rooms) {
        if (room.numberOfBeds < 1) {
          errors['rooms'] = 'Each room needs a bed';
        }
        if (room.coolingType.isEmpty) {
          errors['rooms'] = 'Please select a cooling system for each room';
        }
      }
    }
    if (_currentStep == 2 && !_hasAnyUploadedPropertyPhoto()) {
      errors['photos'] = 'Add at least one photo from your device';
    }
    if (_currentStep == 4 && !_isConfirmed) {
      errors['confirm'] = 'Please confirm before submitting';
    }
    setState(() => _errors = errors);
    return errors.isEmpty;
  }

  void _goNext() {
    if (!_validateStep()) return;
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    } else {
      _submit();
    }
  }

  void _goPrev() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      return;
    }
    widget.onBack?.call();
    Navigator.maybePop(context);
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    final data = _buildPayload();
    widget.onComplete?.call(data);
    _showPendingReviewDialog();
  }

  Map<String, dynamic> _buildPayload() {
    final title = _districtController.text.trim().isEmpty
        ? 'Student property'
        : 'Student property in ${_districtController.text.trim()}';
    return {
      'User_ID': widget.userId,
      'Title': title,
      'City': _governorate,
      'District': _districtController.text.trim(),
      'Address': _addressController.text.trim(),
      'Building_Number': _buildingController.text.trim(),
      'Floor': int.tryParse(_floorController.text) ?? 1,
      'pref_gender': _genderPreference,
      'pref_religion': _religionPreference,
      'house_rules': _rulesController.text.trim(),
      'utilitiesBill': _utilitiesBill,
      'gasType': _gasType,
      'waterHeater': _waterHeater,
      'amenities': _selectedAmenities,
      'livingRoomPhotos': _livingRoomPhotos,
      'bathroomPhotos': _bathroomPhotos,
      'kitchenPhotos': _kitchenPhotos,
      'coverPhotoIndex': _coverPhotoIndex,
      'rooms': _rooms
          .map(
            (room) => {
              'numberOfBeds': room.numberOfBeds,
              'coolingType': room.coolingType,
              'features': {
                'hasWindow': room.hasWindow,
                'hasBalcony': room.hasBalcony,
                'hasDesk': room.hasDesk,
                'hasWardrobe': room.hasWardrobe,
              },
              'pricePerBed': room.pricePerBed,
              'securityDepositPerBed': room.securityDepositPerBed,
              'photos': room.photos,
            },
          )
          .toList(),
    };
  }

  void _showPendingReviewDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: _smallIconButton(Icons.close_rounded, () {
                    Navigator.of(context).pop();
                    Navigator.of(this.context).maybePop();
                  }),
                ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 42,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Property Submitted!',
                  style: TextStyle(
                    color: _primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Your property has been successfully submitted for review.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black45, fontSize: 13),
                ),
                const SizedBox(height: 22),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: _accentSoft,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.auto_awesome_rounded,
                              color: _accent,
                              size: 17,
                            ),
                          ),
                          const SizedBox(width: 9),
                          const Text(
                            "What's next?",
                            style: TextStyle(
                              color: _primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _nextStepRow(
                        Icons.schedule_rounded,
                        'Review Process',
                        'Our team will review within 24 hours',
                      ),
                      const SizedBox(height: 12),
                      _nextStepRow(
                        Icons.shield_rounded,
                        'Verification Check',
                        "We'll verify all provided information",
                      ),
                      const SizedBox(height: 12),
                      _nextStepRow(
                        Icons.check_circle_rounded,
                        'Get Notified',
                        "You'll receive a notification once approved",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.shield_rounded, color: Colors.black38, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Your listing is now pending review. We'll notify you once it's approved.",
                          style: TextStyle(color: Colors.black45, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(this.context).maybePop();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black54,
                          side: BorderSide(color: Colors.grey.shade200),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          fixedSize: const Size.fromHeight(46),
                        ),
                        child: const Text('Close'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(this.context).maybePop();
                        },
                        style: _primaryButtonStyle(),
                        icon: const Icon(Icons.home_rounded, size: 17),
                        label: const Text('Dashboard'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _nextStepRow(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: _accentSoft,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: _accent, size: 13),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.black45, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isTablet = size.width >= 700;
    final contentWidth = isTablet ? 680.0 : double.infinity;

    if (!_isOwnerVerified) {
      return _buildOwnerVerificationScreen(contentWidth);
    }

    return Scaffold(
      backgroundColor: _pageBg,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildFormHeader(),
            _buildProgressSteps(isTablet),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentWidth),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      isTablet ? 0 : 20,
                      18,
                      isTablet ? 0 : 20,
                      24,
                    ),
                    child: _buildCurrentStep(isTablet),
                  ),
                ),
              ),
            ),
            _buildBottomBar(contentWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildOwnerVerificationScreen(double contentWidth) {
    return Scaffold(
      backgroundColor: _pageBg,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 30),
              decoration: const BoxDecoration(
                color: _primary,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: _goPrev,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white70,
                      padding: EdgeInsets.zero,
                    ),
                    icon: const Icon(Icons.arrow_back_rounded, size: 20),
                    label: const Text(
                      'Back',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'List Your Property',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Before listing your property, we need to verify your identity.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentWidth),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                    child: Column(
                      children: [
                        _verificationHeroCard(),
                        const SizedBox(height: 24),
                        _verificationBenefit(
                          Icons.verified_user_rounded,
                          'Build Trust',
                          'Verified badge increases student confidence',
                        ),
                        const SizedBox(height: 12),
                        _verificationBenefit(
                          Icons.schedule_rounded,
                          'Faster Approval',
                          'Verified listings get priority review',
                        ),
                        const SizedBox(height: 12),
                        _verificationBenefit(
                          Icons.groups_rounded,
                          'More Students',
                          'Verified owners get more inquiries',
                        ),
                        const SizedBox(height: 26),
                        Row(
                          children: [
                            Expanded(
                              child: _TrustIndicator(
                                icon: Icons.lock_rounded,
                                title: 'Secure & Safe',
                                subtitle: 'Encrypted data',
                              ),
                            ),
                            SizedBox(
                              height: 42,
                              child: VerticalDivider(color: Color(0xFFE5E7EB)),
                            ),
                            Expanded(
                              child: _TrustIndicator(
                                icon: Icons.access_time_rounded,
                                title: 'Fast Review',
                                subtitle: '24-48 hours',
                              ),
                            ),
                            SizedBox(
                              height: 42,
                              child: VerticalDivider(color: Color(0xFFE5E7EB)),
                            ),
                            Expanded(
                              child: _TrustIndicator(
                                icon: Icons.check_circle_rounded,
                                title: 'Verified Badge',
                                subtitle: 'Trust seal',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _verificationBottomBar(contentWidth),
          ],
        ),
      ),
    );
  }

  Widget _verificationHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_accentSoft, Colors.white],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'One-Time Verification',
                  style: TextStyle(
                    color: _primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Secure your account and start listing',
                  style: TextStyle(color: Colors.black45, fontSize: 13),
                ),
              ],
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: const BoxDecoration(
                    color: _accent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shield_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              const Positioned(
                right: -4,
                bottom: -4,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: _primary,
                    size: 17,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _verificationBenefit(IconData icon, String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(radius: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: _accentSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: _accent, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _primary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.black45, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _verificationBottomBar(double maxWidth) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Align(
          alignment: Alignment.center,
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _showVerifyIdentityDialog,
                      style: _primaryButtonStyle(),
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text('Verify Identity'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock_rounded, color: _primary, size: 14),
                        SizedBox(width: 6),
                        Text(
                          'Encrypted & Secure',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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

  void _showVerifyIdentityDialog() {
    _errors = {};
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.50),
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            void submit() {
              final errors = <String, String>{};
              final nationalId = _nationalIdController.text.trim();
              if (nationalId.isEmpty) {
                errors['nationalId'] = 'National ID is required';
              } else if (!RegExp(r'^\d{14}$').hasMatch(nationalId)) {
                errors['nationalId'] = 'National ID must be exactly 14 digits';
              }
              if (_idFrontPath == null ||
                  _idBackPath == null ||
                  !_isExistingLocalPhoto(_idFrontPath!) ||
                  !_isExistingLocalPhoto(_idBackPath!)) {
                errors['idPhotos'] =
                    'Upload front and back photos from your device';
              }
              if (errors.isNotEmpty) {
                setDialogState(() => _errors = errors);
                return;
              }
              Navigator.of(dialogContext).pop();
              setState(() => _isOwnerVerified = true);
            }

            return Dialog(
              insetPadding: const EdgeInsets.all(18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: _smallIconButton(
                          Icons.close_rounded,
                          () => Navigator.of(dialogContext).pop(),
                        ),
                      ),
                      const Text(
                        'Verification Required',
                        style: TextStyle(
                          color: _accent,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: _accentSoft,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shield_rounded,
                          color: _accent,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Verify Your Identity',
                        style: TextStyle(
                          color: _primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Required only once',
                        style: TextStyle(color: Colors.black45, fontSize: 13),
                      ),
                      const SizedBox(height: 22),
                      _inputField(
                        label: 'National ID Number',
                        hint: 'Enter your National ID number',
                        controller: _nationalIdController,
                        keyboardType: TextInputType.number,
                        maxLength: 14,
                        inputFormatters: _nationalIdInputFormatters(),
                        error: _errors['nationalId'],
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _fieldLabel('Upload ID Card'),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _idUploadCard(
                              'Front Side',
                              _idFrontPath,
                              () => _pickIdPhoto(
                                setDialogState,
                                (path) => _idFrontPath = path,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _idUploadCard(
                              'Back Side',
                              _idBackPath,
                              () => _pickIdPhoto(
                                setDialogState,
                                (path) => _idBackPath = path,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_errors['idPhotos'] != null)
                        _errorText(_errors['idPhotos']!),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.lock_rounded, color: _primary, size: 14),
                            SizedBox(width: 6),
                            Text(
                              'Your data is encrypted & secure',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: submit,
                          style: _primaryButtonStyle(),
                          child: const Text('Verify & Continue'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      if (!mounted) return;
      setState(() => _errors = {});
    });
  }

  Future<void> _pickIdPhoto(
    StateSetter setDialogState,
    ValueChanged<String?> setPath,
  ) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null || result.files.isEmpty) return;
    final path = result.files.single.path;
    if (path == null || !mounted) return;
    setDialogState(() {
      setPath(path);
      _errors.remove('idPhotos');
    });
  }

  Widget _idUploadCard(String title, String? path, VoidCallback onTap) {
    final selected = path != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 132,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? _accentSoft : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? _accent : const Color(0xFFDBE4F0),
            width: 2,
          ),
        ),
        child: selected
            ? Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(path),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                              color: _primary.withValues(alpha: 0.08),
                              child: const Icon(
                                Icons.broken_image_rounded,
                                color: Colors.black26,
                              ),
                            ),
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 0,
                    left: 0,
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                      size: 18,
                    ),
                  ),
                  const Positioned(
                    right: 0,
                    top: 0,
                    child: Icon(Icons.close_rounded, color: _accent, size: 18),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: _accentSoft,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: _accent,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      color: _primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Tap to upload',
                    style: TextStyle(color: Colors.black38, fontSize: 11),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildFormHeader() {
    final progress = (_currentStep + 1) / _steps.length;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
      decoration: const BoxDecoration(
        color: _primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: _goPrev,
                icon: const Icon(Icons.chevron_left_rounded),
                color: Colors.white,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.10),
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Add Property',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${_currentStep + 1}/${_steps.length}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 6,
              value: progress,
              color: _accent,
              backgroundColor: Colors.white.withValues(alpha: 0.20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSteps(bool isTablet) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 18),
        child: Row(
          children: List.generate(_steps.length, (index) {
            final isActive = _currentStep >= index;
            final isDone = _currentStep > index;
            return Row(
              children: [
                GestureDetector(
                  onTap: isDone
                      ? () => setState(() => _currentStep = index)
                      : null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isActive ? _accent : Colors.grey.shade100,
                          shape: BoxShape.circle,
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: _accent.withValues(alpha: 0.28),
                                    blurRadius: 14,
                                    offset: const Offset(0, 6),
                                  ),
                                ]
                              : null,
                        ),
                        child: Icon(
                          isDone
                              ? Icons.check_circle_rounded
                              : _steps[index]['icon'] as IconData,
                          color: isActive ? Colors.white : Colors.grey,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        _steps[index]['title'] as String,
                        style: TextStyle(
                          color: isActive ? _accent : Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                if (index < _steps.length - 1)
                  Container(
                    width: isTablet ? 64 : 36,
                    height: 2,
                    margin: const EdgeInsets.fromLTRB(8, 0, 8, 22),
                    color: _currentStep > index
                        ? _accent
                        : Colors.grey.shade200,
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCurrentStep(bool isTablet) {
    switch (_currentStep) {
      case 0:
        return _buildLocationStep(isTablet);
      case 1:
        return _buildUtilitiesStep(isTablet);
      case 2:
        return _buildPhotosStep();
      case 3:
        return _buildRoomsStep(isTablet);
      default:
        return _buildReviewStep(isTablet);
    }
  }

  Widget _buildLocationStep(bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text(
            'Tell students about your property location and preferences.\nThis helps us match the right tenants faster.',
            style: TextStyle(color: Colors.black54, fontSize: 14, height: 1.45),
          ),
        ),
        _sectionCard(
          icon: Icons.location_on_rounded,
          title: 'Where is your property?',
          child: Column(
            children: [
              _dropdownField(
                label: 'Governorate *',
                value: _governorate,
                hint: 'Select governorate',
                items: _governorates,
                error: _errors['governorate'],
                onChanged: (value) =>
                    setState(() => _governorate = value ?? ''),
              ),
              const SizedBox(height: 16),
              _inputField(
                label: 'District / Area *',
                hint: 'e.g., Maadi, Zamalek, Nasr City',
                controller: _districtController,
                error: _errors['district'],
              ),
              const SizedBox(height: 16),
              _inputField(
                label: 'Full Address *',
                hint: 'Example: 15 Ahmed Orabi St, near Metro Market',
                controller: _addressController,
                error: _errors['address'],
              ),
              const SizedBox(height: 16),
              _responsiveGrid(
                isTablet: isTablet,
                children: [
                  _inputField(
                    label: 'Building Number',
                    hint: '123',
                    controller: _buildingController,
                  ),
                  _inputField(
                    label: 'Floor Number',
                    hint: '1',
                    controller: _floorController,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _sectionCard(
          icon: Icons.people_alt_rounded,
          title: 'Who is this property for?',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _fieldLabel('Gender Preference *'),
              const SizedBox(height: 10),
              _segmentedButtons(
                options: [
                  _Option('male', 'Male Only', Icons.person_rounded),
                  _Option('female', 'Female Only', Icons.person_2_rounded),
                ],
                value: _genderPreference,
                onChanged: (value) => setState(() => _genderPreference = value),
              ),
              const SizedBox(height: 18),
              _fieldLabel('Religion Preference'),
              const SizedBox(height: 10),
              _segmentedButtons(
                options: [
                  _Option('muslim', 'Muslim', Icons.star_rounded),
                  _Option('christian', 'Christian', Icons.favorite_rounded),
                ],
                value: _religionPreference,
                onChanged: (value) =>
                    setState(() => _religionPreference = value),
              ),
              const SizedBox(height: 18),
              _inputField(
                label: 'House Rules (Optional)',
                hint: 'No smoking, quiet hours after 11 PM, visitors policy...',
                controller: _rulesController,
                maxLines: 3,
              ),
              const SizedBox(height: 5),
              const Text(
                'Add any specific rules for tenants',
                style: TextStyle(color: Colors.black38, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoomsStep(bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader(
          'Rooms & Pricing',
          'Add room details, beds, pricing, and photos.',
          '2 minutes',
        ),
        _autoSaveIndicator(),
        _responsiveGrid(
          isTablet: true,
          children: [
            _summaryTile('${_rooms.length}', 'Rooms', _primary),
            _summaryTile('$_totalBeds', 'Total Beds', _primary),
            _summaryTile(
              '${_totalMonthlyRent.toString()} EGP',
              'Monthly Rent',
              _accent,
            ),
          ],
        ),
        const SizedBox(height: 18),
        ...List.generate(
          _rooms.length,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _roomCard(_rooms[index], index, isTablet),
          ),
        ),
        _dashedButton(
          icon: Icons.add_rounded,
          label: 'Add Another Room',
          onTap: _addRoom,
        ),
        if (_errors['rooms'] != null) _errorText(_errors['rooms']!),
      ],
    );
  }

  Widget _roomCard(RoomData room, int index, bool isTablet) {
    final expanded = _expandedRoomId == room.id;
    final roomTotal = room.pricePerBed * room.numberOfBeds;
    return Container(
      decoration: _cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () =>
                setState(() => _expandedRoomId = expanded ? null : room.id),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  _iconBubble(Icons.bed_rounded),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Room ${index + 1}',
                          style: const TextStyle(
                            color: _primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 10,
                          runSpacing: 4,
                          children: [
                            _miniMeta(
                              Icons.king_bed_rounded,
                              '${room.numberOfBeds} beds',
                            ),
                            _miniMeta(
                              room.coolingType.contains('ac')
                                  ? Icons.ac_unit_rounded
                                  : Icons.air_rounded,
                              room.coolingType.contains('ac') &&
                                      room.coolingType.contains('fan')
                                  ? 'AC & Fan'
                                  : room.coolingType.contains('ac')
                                      ? 'AC'
                                      : room.coolingType.contains('fan')
                                          ? 'Fan'
                                          : 'No Cooling',
                            ),
                            Text(
                              '$roomTotal EGP',
                              style: const TextStyle(
                                color: _accent,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (_rooms.length > 1)
                    IconButton(
                      onPressed: () => _deleteRoom(room.id),
                      icon: const Icon(Icons.delete_outline_rounded),
                      color: Colors.redAccent,
                    ),
                  AnimatedRotation(
                    turns: expanded ? .25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(top: BorderSide(color: Colors.grey.shade100)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _counterRow(
                    label: 'Number of Beds',
                    value: room.numberOfBeds,
                    onChanged: (value) =>
                        setState(() => room.numberOfBeds = value.clamp(1, 20)),
                  ),
                  const SizedBox(height: 16),
                  _fieldLabel('Cooling System'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _optionButton(
                          option: _Option('ac', 'AC', Icons.ac_unit_rounded),
                          selected: room.coolingType.contains('ac'),
                          onTap: () {
                            setState(() {
                              final hasAc = room.coolingType.contains('ac');
                              final hasFan = room.coolingType.contains('fan');
                              if (hasAc) {
                                room.coolingType = hasFan ? 'fan' : '';
                              } else {
                                room.coolingType = hasFan ? 'ac,fan' : 'ac';
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _optionButton(
                          option: _Option('fan', 'Fan', Icons.air_rounded),
                          selected: room.coolingType.contains('fan'),
                          onTap: () {
                            setState(() {
                              final hasAc = room.coolingType.contains('ac');
                              final hasFan = room.coolingType.contains('fan');
                              if (hasFan) {
                                room.coolingType = hasAc ? 'ac' : '';
                              } else {
                                room.coolingType = hasAc ? 'ac,fan' : 'fan';
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _fieldLabel('Room Features'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 9,
                    runSpacing: 9,
                    children: [
                      _featureChip(
                        'Window',
                        Icons.window_rounded,
                        room.hasWindow,
                        () => setState(() => room.hasWindow = !room.hasWindow),
                      ),
                      _featureChip(
                        'Balcony',
                        Icons.balcony_rounded,
                        room.hasBalcony,
                        () =>
                            setState(() => room.hasBalcony = !room.hasBalcony),
                      ),
                      _featureChip(
                        'Desk',
                        Icons.desktop_windows_rounded,
                        room.hasDesk,
                        () => setState(() => room.hasDesk = !room.hasDesk),
                      ),
                      _featureChip(
                        'Wardrobe',
                        Icons.door_sliding_rounded,
                        room.hasWardrobe,
                        () => setState(
                          () => room.hasWardrobe = !room.hasWardrobe,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pricing',
                          style: TextStyle(
                            color: _primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _responsiveGrid(
                          isTablet: isTablet,
                          children: [
                            _numberInput(
                              label: 'Price per Bed (EGP/month)',
                              value: room.pricePerBed,
                              onChanged: (value) =>
                                  setState(() => room.pricePerBed = value),
                            ),
                            _numberInput(
                              label: 'Security Deposit (EGP)',
                              value: room.securityDepositPerBed,
                              onChanged: (value) => setState(
                                () => room.securityDepositPerBed = value,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Text(
                              'Room Total:',
                              style: TextStyle(color: Colors.black54),
                            ),
                            const Spacer(),
                            Text(
                              '$roomTotal EGP/month',
                              style: const TextStyle(
                                color: _accent,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _fieldLabel('Room Photos'),
                  const SizedBox(height: 10),
                  _photoStrip(
                    photos: room.photos,
                    maxPhotos: 3,
                    onAdd: () => _pickPhotos(room.photos, 3),
                    onRemove: (i) => setState(() => room.photos.removeAt(i)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUtilitiesStep(bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader(
          'Utilities & Amenities',
          'Tell students about bills and what your property offers.',
          '2 minutes',
        ),
        _autoSaveIndicator(),
        const Text(
          'Utilities & Bills',
          style: TextStyle(
            color: _primary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 14),
        _fieldLabel('Electricity & Water Bill'),
        const SizedBox(height: 10),
        _responsiveGrid(
          isTablet: isTablet,
          children: [
            _choiceCard(
              selected: _utilitiesBill == 'student',
              icon: Icons.water_drop_rounded,
              title: 'Student pays',
              subtitle: 'Bills paid monthly by tenants',
              onTap: () => setState(() => _utilitiesBill = 'student'),
            ),
            _choiceCard(
              selected: _utilitiesBill == 'owner',
              icon: Icons.auto_awesome_rounded,
              title: 'Included in rent',
              subtitle: 'Owner covers all utilities',
              onTap: () => setState(() => _utilitiesBill = 'owner'),
            ),
          ],
        ),
        const SizedBox(height: 22),
        _responsiveGrid(
          isTablet: isTablet,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel('Gas Type'),
                const SizedBox(height: 10),
                _segmentedButtons(
                  options: [
                    _Option(
                      'natural',
                      'Natural Gas',
                      Icons.local_fire_department_rounded,
                    ),
                    _Option('cylinder', 'Cylinder', Icons.propane_tank_rounded),
                  ],
                  value: _gasType,
                  onChanged: (value) => setState(() => _gasType = value),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel('Water Heater'),
                const SizedBox(height: 10),
                _segmentedButtons(
                  options: [
                    _Option(
                      'electric',
                      'Electric',
                      Icons.electric_bolt_rounded,
                    ),
                    _Option('gas', 'Gas', Icons.local_fire_department_rounded),
                  ],
                  value: _waterHeater,
                  onChanged: (value) => setState(() => _waterHeater = value),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 28),
        const Text(
          'Amenities',
          style: TextStyle(
            color: _primary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _amenities.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isTablet ? 3 : 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: isTablet ? 2.1 : 1.55,
          ),
          itemBuilder: (context, index) {
            final amenity = _amenities[index];
            final selected = _selectedAmenities.contains(amenity.id);
            return _amenityTile(amenity, selected);
          },
        ),
      ],
    );
  }

  Widget _buildPhotosStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader(
          'Property Photos',
          'Upload clear photos of shared spaces. Bright photos get more views.',
          '3 minutes',
        ),
        _autoSaveIndicator(),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _accentSoft,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.orange.shade100),
          ),
          child: const Row(
            children: [
              Icon(Icons.auto_awesome_rounded, color: _accent),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Properties with clear, well-lit photos are rented faster. The first living room photo will be your cover image.',
                  style: TextStyle(color: _primary, fontSize: 13, height: 1.35),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _photoUploadCard(
          title: 'Living Room',
          icon: Icons.chair_rounded,
          tip: 'Show the main living area, seating, and natural light',
          maxPhotos: 3,
          photos: _livingRoomPhotos,
        ),
        const SizedBox(height: 14),
        _photoUploadCard(
          title: 'Bathroom',
          icon: Icons.shower_rounded,
          tip: 'Include sink, toilet, and shower area',
          maxPhotos: 2,
          photos: _bathroomPhotos,
        ),
        const SizedBox(height: 14),
        _photoUploadCard(
          title: 'Kitchen',
          icon: Icons.soup_kitchen_rounded,
          tip: 'Show appliances, counter space, and storage',
          maxPhotos: 2,
          photos: _kitchenPhotos,
        ),
        if (_errors['photos'] != null) _errorText(_errors['photos']!),
      ],
    );
  }

  Widget _buildReviewStep(bool isTablet) {
    final startingPrice = _rooms.isEmpty ? 0 : _rooms.first.pricePerBed;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: isTablet ? 300 : 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [
                _primary.withValues(alpha: 0.18),
                _accent.withValues(alpha: 0.16),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              const Center(
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: 54,
                  color: Colors.black26,
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.62),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Row(
                  children: [
                    Expanded(
                      child: _glassPill(
                        Icons.location_on_rounded,
                        '${_districtController.text}, $_governorate',
                      ),
                    ),
                    const SizedBox(width: 10),
                    _glassPill(Icons.bed_rounded, '$_totalBeds Beds'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _reviewCard(
          icon: Icons.location_on_rounded,
          title: 'Location',
          children: [
            Text(
              '${_districtController.text}, $_governorate',
              style: const TextStyle(color: Colors.black87, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              _addressController.text,
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              'Building ${_buildingController.text.isEmpty ? '-' : _buildingController.text}, Floor ${_floorController.text}',
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
        _reviewCard(
          icon: Icons.bed_rounded,
          title: 'Rooms & Beds',
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _pill('${_rooms.length} Rooms', _accentSoft, _accent),
                _pill(
                  '$_totalBeds Beds',
                  _primary.withValues(alpha: 0.10),
                  _primary,
                ),
                _pill(
                  '$_totalMonthlyRent EGP/month',
                  Colors.green.shade50,
                  Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Starting from $startingPrice EGP / bed',
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
        _reviewCard(
          icon: Icons.people_alt_rounded,
          title: 'Preferences',
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _pill(
                  _genderPreference == 'male' ? 'Male Only' : 'Female Only',
                  _accentSoft,
                  _accent,
                ),
                _pill(
                  _religionPreference == 'muslim' ? 'Muslim' : 'Christian',
                  _primary.withValues(alpha: 0.10),
                  _primary,
                ),
                if (_rulesController.text.trim().isNotEmpty)
                  _pill(
                    _rulesController.text.trim().length > 28
                        ? '${_rulesController.text.trim().substring(0, 28)}...'
                        : _rulesController.text.trim(),
                    Colors.grey.shade100,
                    Colors.black54,
                  ),
              ],
            ),
          ],
        ),
        _reviewCard(
          icon: Icons.water_drop_rounded,
          title: 'Utilities',
          children: [
            _responsiveGrid(
              isTablet: isTablet,
              children: [
                _utilitySummary(
                  Icons.water_drop_rounded,
                  'Electricity & Water',
                  _utilitiesBill == 'student'
                      ? 'Student pays'
                      : 'Included in rent',
                ),
                _utilitySummary(
                  Icons.local_fire_department_rounded,
                  'Gas Type',
                  _gasType == 'natural' ? 'Natural Gas' : 'Cylinder',
                ),
              ],
            ),
          ],
        ),
        _reviewCard(
          icon: Icons.auto_awesome_rounded,
          title: 'Amenities',
          children: [
            if (_selectedAmenities.isEmpty)
              const Text(
                'No amenities selected',
                style: TextStyle(color: Colors.black54),
              )
            else
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _amenities
                    .where((item) => _selectedAmenities.contains(item.id))
                    .map((item) => _miniIconText(item.icon, item.name))
                    .toList(),
              ),
          ],
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _primary,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Listing Summary',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              _responsiveGrid(
                isTablet: true,
                children: [
                  _darkSummary('Total Rooms', '${_rooms.length}'),
                  _darkSummary('Total Beds', '$_totalBeds'),
                  _darkSummary('Monthly Rent', '$_totalMonthlyRent EGP'),
                  _darkSummary('Security Deposit', '$_totalDeposit EGP'),
                ],
              ),
              const Divider(height: 28, color: Colors.white24),
              Text(
                'Bills: ${_utilitiesBill == 'student' ? 'Student pays' : 'Included in rent'}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.green.shade100),
          ),
          child: const Row(
            children: [
              Icon(Icons.schedule_rounded, color: Colors.green),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Estimated approval within 24 hours',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        InkWell(
          onTap: () => setState(() => _isConfirmed = !_isConfirmed),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isConfirmed ? _accentSoft : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: _isConfirmed ? _accent : Colors.grey.shade200,
                width: 2,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isConfirmed ? _accent : Colors.transparent,
                    border: Border.all(
                      color: _isConfirmed ? _accent : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: _isConfirmed
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 15,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'I confirm that all information is correct and complete',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Your listing will be reviewed by our team',
                        style: TextStyle(color: Colors.black45, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_errors['confirm'] != null) _errorText(_errors['confirm']!),
      ],
    );
  }

  Widget _buildBottomBar(double maxWidth) {
    final isPhotoStep = _currentStep == 2;
    final isReviewStep = _currentStep == 4;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Align(
          alignment: Alignment.center,
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isPhotoStep)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Text(
                            '$_totalPhotos photos uploaded',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '$_totalPhotos/7 total',
                            style: const TextStyle(
                              color: Colors.black38,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    height: isReviewStep ? 54 : 50,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _goNext,
                      style: _primaryButtonStyle(
                        disabled:
                            isPhotoStep && _totalPhotos == 0 ||
                            isReviewStep && !_isConfirmed,
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              isPhotoStep && _totalPhotos == 0
                                  ? 'Add at least one photo'
                                  : isReviewStep && !_isConfirmed
                                  ? 'Confirm to Submit'
                                  : isReviewStep
                                  ? 'Submit Property'
                                  : 'Continue',
                            ),
                    ),
                  ),
                  if (isReviewStep)
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'By submitting, you agree to our Terms of Service',
                        style: TextStyle(color: Colors.black38, fontSize: 11),
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

  void _addRoom() {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      _rooms.add(
        RoomData(
          id: id,
          numberOfBeds: 1,
          coolingType: 'fan',
          hasWindow: true,
          hasBalcony: false,
          hasDesk: false,
          hasWardrobe: true,
          pricePerBed: 0,
          securityDepositPerBed: 0,
          photos: [],
        ),
      );
      _expandedRoomId = id;
    });
  }

  void _deleteRoom(String id) {
    if (_rooms.length == 1) return;
    setState(() {
      _rooms.removeWhere((room) => room.id == id);
      if (_expandedRoomId == id) _expandedRoomId = _rooms.first.id;
    });
  }

  Widget _stepHeader(String title, String description, String estimatedTime) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _primary,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            description,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 14,
                color: Colors.grey.shade400,
              ),
              const SizedBox(width: 5),
              Text(
                'Takes about $estimatedTime',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _iconBubble(icon),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: _primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }

  Widget _inputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    String? error,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          decoration: _inputDecoration(hint, error),
          style: const TextStyle(color: _primary, fontSize: 14),
        ),
        if (error != null) _errorText(error),
      ],
    );
  }

  Widget _dropdownField({
    required String label,
    required String value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? error,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label),
        const SizedBox(height: 7),
        DropdownButtonFormField<String>(
          initialValue: value.isEmpty ? null : value,
          hint: Text(hint, style: TextStyle(color: Colors.grey.shade400)),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
          decoration: _inputDecoration(hint, error),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          style: const TextStyle(color: _primary, fontSize: 14),
        ),
        if (error != null) _errorText(error),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint, String? error) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: error == null ? Colors.grey.shade200 : Colors.red,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _accent, width: 2),
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: _primary,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _segmentedButtons({
    required List<_Option> options,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Row(
      children: options
          .map(
            (option) => Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  end: option == options.last ? 0 : 10,
                ),
                child: _optionButton(
                  option: option,
                  selected: value == option.value,
                  onTap: () => onChanged(option.value),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _optionButton({
    required _Option option,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? _accent : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: _accent.withValues(alpha: 0.24),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              option.icon,
              size: 17,
              color: selected ? Colors.white : Colors.black54,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                option.label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black54,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _responsiveGrid({
    required bool isTablet,
    required List<Widget> children,
  }) {
    final columns = isTablet ? children.length.clamp(2, 3) : 2;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (children.length == 1) return children.first;
        final spacing = 12.0;
        final itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children
              .map((child) => SizedBox(width: itemWidth, child: child))
              .toList(),
        );
      },
    );
  }

  Widget _summaryTile(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: _cardDecoration(radius: 14),
      child: Column(
        children: [
          FittedBox(
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.black45, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _counterRow({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return Row(
      children: [
        Expanded(child: _fieldLabel(label)),
        _smallIconButton(Icons.remove_rounded, () => onChanged(value - 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            '$value',
            style: const TextStyle(
              color: _primary,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        _smallIconButton(Icons.add_rounded, () => onChanged(value + 1)),
      ],
    );
  }

  Widget _numberInput({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black45, fontSize: 11),
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: value.toString(),
          keyboardType: TextInputType.number,
          onChanged: (text) => onChanged(int.tryParse(text) ?? 0),
          decoration: _inputDecoration('0', null).copyWith(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }

  Widget _featureChip(
    String label,
    IconData icon,
    bool active,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: active ? _accent : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: active ? Colors.white : Colors.black54),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : Colors.black54,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _choiceCard({
    required bool selected,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: selected ? _accentSoft : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? _accent : Colors.grey.shade200,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: _accent.withValues(alpha: 0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: selected ? _accent : Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: selected ? Colors.white : Colors.black45,
                    size: 18,
                  ),
                ),
                const Spacer(),
                if (selected)
                  const Icon(Icons.check_rounded, color: _accent, size: 18),
              ],
            ),
            const SizedBox(height: 11),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.black45,
                fontSize: 12,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _amenityTile(AmenityItem amenity, bool selected) {
    return InkWell(
      onTap: () {
        setState(() {
          selected
              ? _selectedAmenities.remove(amenity.id)
              : _selectedAmenities.add(amenity.id);
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? _accentSoft : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? _accent : Colors.grey.shade200,
            width: selected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            if (selected)
              const Positioned(
                top: 0,
                right: 0,
                child: Icon(Icons.check_rounded, color: _accent, size: 17),
              ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    amenity.icon,
                    color: selected ? _accent : Colors.black45,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    amenity.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: selected ? _primary : Colors.black54,
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _photoUploadCard({
    required String title,
    required IconData icon,
    required String tip,
    required int maxPhotos,
    required List<String> photos,
  }) {
    return _sectionCard(
      icon: icon,
      title: title,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.blue.shade500,
                  size: 17,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tip,
                    style: TextStyle(color: Colors.blue.shade600, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (photos.isEmpty)
            _emptyUploadButton(() => _pickPhotos(photos, maxPhotos))
          else
            _photoPreview(
              title: title,
              photos: photos,
              maxPhotos: maxPhotos,
              onAdd: () => _pickPhotos(photos, maxPhotos),
              onRemove: (i) => setState(() {
                photos.removeAt(i);
                if (_coverPhotoIndex >= photos.length) {
                  _coverPhotoIndex = photos.isEmpty ? 0 : photos.length - 1;
                }
              }),
              allowCover: title == 'Living Room',
            ),
        ],
      ),
    );
  }

  Future<void> _pickPhotos(List<String> photos, int maxPhotos) async {
    final remaining = maxPhotos - photos.length;
    if (remaining <= 0) return;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: remaining > 1,
    );
    if (result == null || result.files.isEmpty || !mounted) return;

    final selectedPaths = result.files
        .map((file) => file.path)
        .whereType<String>()
        .take(remaining)
        .toList();
    if (selectedPaths.isEmpty) return;

    setState(() {
      photos.addAll(selectedPaths);
      _errors.remove('photos');
    });
  }

  Widget _localPhoto(String path, {required double width, required double height}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.file(
        File(path),
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: _primary.withValues(alpha: 0.08),
          child: const Icon(
            Icons.broken_image_rounded,
            color: Colors.black26,
          ),
        ),
      ),
    );
  }

  Widget _photoPreview({
    required String title,
    required List<String> photos,
    required int maxPhotos,
    required VoidCallback onAdd,
    required ValueChanged<int> onRemove,
    bool allowCover = false,
  }) {
    final currentIndex = 0;
    final isCover = allowCover && _coverPhotoIndex == currentIndex;
    return Column(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                File(photos[currentIndex]),
                height: 190,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 190,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        _primary.withValues(alpha: 0.18),
                        _accent.withValues(alpha: 0.14),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.broken_image_rounded,
                    color: Colors.black26,
                    size: 46,
                  ),
                ),
              ),
            ),
            if (isCover)
              Positioned(
                left: 12,
                top: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _accent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Cover Photo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            Positioned(
              top: 10,
              right: 10,
              child: InkWell(
                onTap: () => onRemove(currentIndex),
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 66,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: photos.length + (photos.length < maxPhotos ? 1 : 0),
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == photos.length) {
                return InkWell(
                  onTap: onAdd,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 66,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_rounded, color: Colors.black38),
                        Text(
                          'Add',
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              final selectedCover = allowCover && _coverPhotoIndex == index;
              return InkWell(
                onTap: allowCover
                    ? () => setState(() => _coverPhotoIndex = index)
                    : null,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 66,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selectedCover ? _accent : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: _localPhoto(
                    photos[index],
                    width: 62,
                    height: 62,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _emptyUploadButton(VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300, width: 2),
        ),
        child: Column(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: const BoxDecoration(
                color: _accentSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                color: _accent,
                size: 30,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Upload Photos',
              style: TextStyle(color: _primary, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tap to add photos',
              style: TextStyle(color: Colors.black38, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _photoStrip({
    required List<String> photos,
    required int maxPhotos,
    required VoidCallback onAdd,
    required ValueChanged<int> onRemove,
    bool allowCover = false,
  }) {
    return SizedBox(
      height: 86,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length + (photos.length < maxPhotos ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          if (index == photos.length) {
            return InkWell(
              onTap: onAdd,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 86,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_rounded, color: Colors.black38),
                    Text(
                      'Add',
                      style: TextStyle(color: Colors.black38, fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          }
          final isCover = allowCover && _coverPhotoIndex == index;
          return Stack(
            children: [
              InkWell(
                onTap: allowCover
                    ? () => setState(() => _coverPhotoIndex = index)
                    : null,
                child: Container(
                  width: 86,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isCover ? _accent : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: _localPhoto(
                    photos[index],
                    width: 82,
                    height: 82,
                  ),
                ),
              ),
              if (isCover)
                Positioned(
                  left: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _accent,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: const Text(
                      'Cover',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              Positioned(
                right: 4,
                top: 4,
                child: InkWell(
                  onTap: () => onRemove(index),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _reviewCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: _accentSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: _accent, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: _primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          ...children,
        ],
      ),
    );
  }

  Widget _utilitySummary(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: _accent, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(color: Colors.black45, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _darkSummary(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
        const SizedBox(height: 4),
        FittedBox(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _dashedButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade300, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: _accent),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: _accent,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _autoSaveIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.check_circle_rounded, color: Colors.green, size: 14),
          SizedBox(width: 5),
          Text(
            'Draft saved',
            style: TextStyle(color: Colors.green, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _miniMeta(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: Colors.black45),
        const SizedBox(width: 3),
        Text(text, style: const TextStyle(color: Colors.black45, fontSize: 12)),
      ],
    );
  }

  Widget _miniIconText(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: _accent, size: 17),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Colors.black54, fontSize: 13)),
      ],
    );
  }

  Widget _glassPill(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 15),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(color: fg, fontSize: 13, fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _smallIconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: _accentSoft,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: _accent, size: 20),
      ),
    );
  }

  Widget _iconBubble(IconData icon) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: _accentSoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: _accent, size: 22),
    );
  }

  Widget _errorText(String error) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 2),
      child: Text(
        error,
        style: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }

  BoxDecoration _cardDecoration({double radius = 20}) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: Colors.grey.shade100),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.035),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  ButtonStyle _primaryButtonStyle({bool disabled = false}) {
    return ElevatedButton.styleFrom(
      backgroundColor: disabled ? Colors.grey.shade300 : _accent,
      foregroundColor: Colors.white,
      disabledBackgroundColor: Colors.grey.shade300,
      disabledForegroundColor: Colors.white,
      elevation: 0,
      shadowColor: _accent.withValues(alpha: 0.25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
    );
  }
}

class _Option {
  final String value;
  final String label;
  final IconData icon;

  const _Option(this.value, this.label, this.icon);
}

class _TrustIndicator extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _TrustIndicator({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: _accentSoft,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: _accent, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _primary,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black38, fontSize: 10),
        ),
      ],
    );
  }
}
