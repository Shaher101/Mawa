import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

// ══════════════════════════════════════════════════════════════
//  USER MODEL
// ══════════════════════════════════════════════════════════════
class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String university;
  final String college;
  final String level;
  final String nationality;
  final String parentPhone;
  final String religion;
  final String gender;
  final String dob;
  final String governmentId;
  final String role;
  final String? nationalIdName;
  final String? studentIdName;
  final File? nationalIdFile;
  final File? studentIdFile;
  final File? profilePicture; // ✅ صورة البروفايل
  final String governorate;
  final String major;
  final File? nationalIdFrontFile;
  final File? nationalIdBackFile;
  final File? studentIdFrontFile;
  final File? studentIdBackFile;
  final List<String> tags;

  const UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.university,
    this.college = '',
    this.level = '',
    this.nationality = '',
    this.parentPhone = '',
    this.religion = '',
    required this.gender,
    required this.dob,
    this.governmentId = '',
    required this.role,
    this.nationalIdName,
    this.studentIdName,
    this.nationalIdFile,
    this.studentIdFile,
    this.profilePicture,
    this.governorate = '',
    this.major = '',
    this.nationalIdFrontFile,
    this.nationalIdBackFile,
    this.studentIdFrontFile,
    this.studentIdBackFile,
    this.tags = const [],
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      if (parts.first.isNotEmpty && parts.last.isNotEmpty) {
        return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
      }
    }
    return name.isNotEmpty && name.trim().isNotEmpty
        ? name.trim()[0].toUpperCase()
        : 'U';
  }

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? university,
    String? college,
    String? level,
    String? nationality,
    String? parentPhone,
    String? religion,
    String? gender,
    String? dob,
    String? governmentId,
    String? role,
    File? nationalIdFile,
    String? nationalIdName,
    File? studentIdFile,
    String? studentIdName,
    File? profilePicture,
    String? governorate,
    String? major,
    File? nationalIdFrontFile,
    File? nationalIdBackFile,
    File? studentIdFrontFile,
    File? studentIdBackFile,
    List<String>? tags,
  }) => UserProfile(
    name: name ?? this.name,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    university: university ?? this.university,
    college: college ?? this.college,
    level: level ?? this.level,
    nationality: nationality ?? this.nationality,
    parentPhone: parentPhone ?? this.parentPhone,
    religion: religion ?? this.religion,
    gender: gender ?? this.gender,
    dob: dob ?? this.dob,
    governmentId: governmentId ?? this.governmentId,
    role: role ?? this.role,
    nationalIdFile: nationalIdFile ?? this.nationalIdFile,
    nationalIdName: nationalIdName ?? this.nationalIdName,
    studentIdFile: studentIdFile ?? this.studentIdFile,
    studentIdName: studentIdName ?? this.studentIdName,
    profilePicture: profilePicture ?? this.profilePicture,
    governorate: governorate ?? this.governorate,
    major: major ?? this.major,
    nationalIdFrontFile: nationalIdFrontFile ?? this.nationalIdFrontFile,
    nationalIdBackFile: nationalIdBackFile ?? this.nationalIdBackFile,
    studentIdFrontFile: studentIdFrontFile ?? this.studentIdFrontFile,
    studentIdBackFile: studentIdBackFile ?? this.studentIdBackFile,
    tags: tags ?? this.tags,
  );
}

// ══════════════════════════════════════════════════════════════
//  MAIN PROFILE SCREEN
// ══════════════════════════════════════════════════════════════
class ProfileScreen extends StatefulWidget {
  final UserProfile user;
  final VoidCallback? onLogout;
  final VoidCallback? onSwitchToOwner;

  const ProfileScreen({
    super.key,
    required this.user,
    this.onLogout,
    this.onSwitchToOwner,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserProfile _user;
  bool _uploadingPhoto = false;

  static const Color _primary = Color(0xFF0B2A4A);

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  void _navigate(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page)).then((_) {
      setState(() {});
    });
  }

  // ✅ دالة رفع صورة البروفايل
  Future<void> _pickProfilePicture() async {
    // بيظهر bottom sheet للمستخدم يختار
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profile Photo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Choose a photo for your profile',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 20),
              // ── اختيار من المعرض ──
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _primary.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.photo_library_outlined,
                    color: _primary,
                    size: 22,
                  ),
                ),
                title: const Text(
                  'Choose from gallery',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),
                subtitle: Text(
                  'JPG or PNG',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                ),
                onTap: () async {
                  Navigator.pop(ctx);
                  await _uploadPhoto();
                },
              ),
              const Divider(height: 1, color: Color(0xFFF2F2F2)),
              // ── حذف الصورة ──
              if (_user.profilePicture != null)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 22,
                    ),
                  ),
                  title: const Text(
                    'Remove photo',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.red,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _user = UserProfile(
                        name: _user.name,
                        email: _user.email,
                        phone: _user.phone,
                        university: _user.university,
                        college: _user.college,
                        level: _user.level,
                        nationality: _user.nationality,
                        parentPhone: _user.parentPhone,
                        religion: _user.religion,
                        gender: _user.gender,
                        dob: _user.dob,
                        governmentId: _user.governmentId,
                        role: _user.role,
                        nationalIdFile: _user.nationalIdFile,
                        nationalIdName: _user.nationalIdName,
                        studentIdFile: _user.studentIdFile,
                        studentIdName: _user.studentIdName,
                        profilePicture: null, // ✅ حذف الصورة
                      );
                    });
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _uploadPhoto() async {
    setState(() => _uploadingPhoto = true);
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        setState(() {
          _user = _user.copyWith(profilePicture: file);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profile photo updated! ✓'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      setState(() => _uploadingPhoto = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(w),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick Actions
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickActionCard(
                            icon: Icons.person_outline_rounded,
                            label: 'Personal Info',
                            description: 'View details',
                            iconColor: const Color(0xFFFF751F),
                            bgColor: const Color(0xFFFFF1E8),
                            onTap: () => _navigate(
                              PersonalInfoScreen(
                                user: _user,
                                onUpdate: (u) => setState(() => _user = u),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickActionCard(
                            icon: Icons.school_outlined,
                            label: 'Student Info',
                            description: 'View details',
                            iconColor: const Color(0xFF022B60),
                            bgColor: const Color(0xFFE6EBF2),
                            onTap: () => _navigate(
                              StudentInfoScreen(
                                user: _user,
                                onUpdate: (u) => setState(() => _user = u),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Switch to Owner Banner
                    if (_user.role == 'student' &&
                        widget.onSwitchToOwner != null) ...[
                      _buildHostBanner(w),
                      const SizedBox(height: 24),
                    ],

                    // Trust & Safety
                    _buildTrustSafetySection(),
                    const SizedBox(height: 24),

                    // Support Section
                    _buildSupportSection(),
                    const SizedBox(height: 24),

                    // Legal Section
                    _buildLegalSection(),
                    const SizedBox(height: 24),

                    // Log out
                    Center(
                      child: TextButton(
                        onPressed: widget.onLogout,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey.shade600,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Log out',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        'MAWA Version 1.0.0',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required String description,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF3F4F6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.015),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              description,
              style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double w) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF022B60),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
      child: Row(
        children: [
          GestureDetector(
            onTap: _pickProfilePicture,
            child: Stack(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFF751F),
                    image: _user.profilePicture != null
                        ? DecorationImage(
                            image: FileImage(_user.profilePicture!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: _uploadingPhoto
                      ? const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : _user.profilePicture == null
                      ? Center(
                          child: Text(
                            _user.initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Color(0xFF4B5563),
                      size: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _user.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const _PulsingDot(),
                    const SizedBox(width: 6),
                    Text(
                      'Verified Account',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHostBanner(double w) {
    return GestureDetector(
      onTap: widget.onSwitchToOwner,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF022B60), Color(0xFF033B82)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF022B60).withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Text('🏠', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'List your property',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Start earning by renting to students',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustSafetySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.shield_outlined, color: Color(0xFFFF751F), size: 18),
            SizedBox(width: 8),
            Text(
              'Trust & Safety',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _buildTrustBadge('ID Verified'),
            _buildTrustBadge('Phone Verified'),
          ],
        ),
      ],
    );
  }

  Widget _buildTrustBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFA7F3D0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF059669),
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF047857),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    final items = [
      _MenuItem(
        icon: Icons.help_outline_rounded,
        label: 'Visit the Help Center',
        onTap: () => _showComingSoon('Help Center'),
      ),
      _MenuItem(
        icon: Icons.shield_outlined,
        label: 'Get help with a safety issue',
        onTap: () => _showComingSoon('Safety'),
      ),
      _MenuItem(
        icon: Icons.location_on_outlined,
        label: 'Report a neighborhood concern',
        onTap: () => _showComingSoon('Report'),
      ),
      _MenuItem(
        icon: Icons.menu_book_outlined,
        label: 'How Mawa works',
        onTap: () => _showComingSoon('How Mawa works'),
      ),
      _MenuItem(
        icon: Icons.chat_bubble_outline_rounded,
        label: 'Give us feedback',
        onTap: () => _showComingSoon('Feedback'),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SUPPORT',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4B5563),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 10),
        _buildMenuCard(items),
      ],
    );
  }

  Widget _buildLegalSection() {
    final items = [
      _MenuItem(
        icon: Icons.balance_outlined,
        label: 'Terms of Service',
        onTap: () => _showComingSoon('Terms'),
      ),
      _MenuItem(
        icon: Icons.shield_outlined,
        label: 'Privacy Policy',
        onTap: () => _showComingSoon('Privacy'),
      ),
      _MenuItem(
        icon: Icons.description_outlined,
        label: 'Open source licenses',
        onTap: () => _showComingSoon('Licenses'),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'LEGAL',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4B5563),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 10),
        _buildMenuCard(items),
      ],
    );
  }

  Widget _buildMenuCard(List<_MenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: List.generate(items.length, (index) {
            final item = items[index];
            return Column(
              children: [
                ListTile(
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item.icon,
                      color: const Color(0xFF4B5563),
                      size: 18,
                    ),
                  ),
                  title: Text(
                    item.label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFFD1D5DB),
                    size: 18,
                  ),
                  onTap: item.onTap,
                ),
                if (index != items.length - 1)
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFF3F4F6),
                    indent: 64,
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  void _showComingSoon(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label — coming soon'),
        backgroundColor: const Color(0xFF022B60),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

// ── Pulsing Dot Widget ──
class _PulsingDot extends StatefulWidget {
  const _PulsingDot();
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.greenAccent.shade400.withOpacity(_animation.value),
            boxShadow: [
              BoxShadow(
                color: Colors.greenAccent.shade400.withOpacity(
                  1.0 - _animation.value,
                ),
                blurRadius: 4,
                spreadRadius: 2,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Helper ──
class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

// ══════════════════════════════════════════════════════════════
//  PERSONAL INFO SCREEN
// ══════════════════════════════════════════════════════════════
class PersonalInfoScreen extends StatefulWidget {
  final UserProfile user;
  final ValueChanged<UserProfile> onUpdate;
  const PersonalInfoScreen({
    super.key,
    required this.user,
    required this.onUpdate,
  });

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  bool _editing = false;
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _dob;
  late final TextEditingController _govId;
  String _governorate = '';
  File? _nationalIdFrontFile;
  File? _nationalIdBackFile;

  static const Color _primary = Color(0xFF022B60);
  static const Color _accent = Color(0xFFFF751F);

  static const List<String> _governorates = [
    'Cairo',
    'Giza',
    'Alexandria',
    'Mansoura',
    'Assiut',
    'Tanta',
    'Zagazig',
    'Ismailia',
  ];

  @override
  void initState() {
    super.initState();
    final parts = widget.user.name.trim().split(' ');
    _firstName = TextEditingController(
      text: parts.isNotEmpty ? parts.first : '',
    );
    _lastName = TextEditingController(
      text: parts.length > 1 ? parts.sublist(1).join(' ') : '',
    );
    _dob = TextEditingController(text: widget.user.dob);
    _govId = TextEditingController(text: widget.user.governmentId);
    _governorate = widget.user.governorate;
    _nationalIdFrontFile = widget.user.nationalIdFrontFile;
    _nationalIdBackFile = widget.user.nationalIdBackFile;
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _dob.dispose();
    _govId.dispose();
    super.dispose();
  }

  String _formatNationalId(String id) {
    if (id.isEmpty) return 'Not provided';
    if (id.length == 14) {
      return '${id.substring(0, 4)} •••• •••• ${id.substring(12, 14)}';
    }
    return id;
  }

  void _save() {
    final fName = _firstName.text.trim();
    final lName = _lastName.text.trim();
    if (fName.isEmpty || lName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both First and Last Name.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final updated = widget.user.copyWith(
      name: '$fName $lName',
      dob: _dob.text.trim(),
      governmentId: _govId.text.trim(),
      governorate: _governorate,
      nationalIdFrontFile: _nationalIdFrontFile,
      nationalIdBackFile: _nationalIdBackFile,
    );
    widget.onUpdate(updated);
    setState(() => _editing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Personal information updated successfully!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _pickImage(bool isFront) async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        setState(() {
          if (isFront) {
            _nationalIdFrontFile = file;
          } else {
            _nationalIdBackFile = file;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${isFront ? "Front" : "Back"} side uploaded'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking file: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _removeImage(bool isFront) {
    setState(() {
      if (isFront) {
        _nationalIdFrontFile = null;
      } else {
        _nationalIdBackFile = null;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${isFront ? "Front" : "Back"} side removed'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getVerificationStatus() {
    if (_nationalIdFrontFile != null && _nationalIdBackFile != null) {
      return 'Pending Review';
    }
    return 'Not Started';
  }

  Color _getStatusColor(String status) {
    if (status == 'Pending Review') return Colors.amber;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final status = _getVerificationStatus();
    final statusColor = _getStatusColor(status);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              color: _primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              bottom: 24,
              left: 20,
              right: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: _editing
                          ? _save
                          : () => setState(() => _editing = true),
                      style: TextButton.styleFrom(
                        foregroundColor: _accent,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        _editing ? 'Save' : 'Edit',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'View and manage your personal details',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_editing) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: Colors.blue.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'You can edit your first name, last name, date of birth, governorate, and national ID.\nEmail, phone, and gender cannot be changed.',
                              style: TextStyle(
                                color: Colors.blue.shade800,
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Profile Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFF3F4F6)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.015),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Column(
                        children: [
                          _buildFieldItem(
                            'FIRST NAME',
                            _editing
                                ? _buildNameInput(_firstName, 'First name')
                                : _valText(_firstName.text),
                            isLast: false,
                          ),
                          _buildFieldItem(
                            'LAST NAME',
                            _editing
                                ? _buildNameInput(_lastName, 'Last name')
                                : _valText(_lastName.text),
                            isLast: false,
                          ),
                          _buildFieldItem(
                            'EMAIL ADDRESS',
                            _valText(widget.user.email),
                            badge: _buildBadge('Verified', Colors.green),
                            isLast: false,
                          ),
                          _buildFieldItem(
                            'PHONE NUMBER',
                            _valText(
                              widget.user.phone.isEmpty
                                  ? 'Not set'
                                  : widget.user.phone,
                            ),
                            badge: widget.user.phone.isNotEmpty
                                ? _buildBadge('Verified', Colors.green)
                                : null,
                            isLast: false,
                          ),
                          _buildFieldItem(
                            'DATE OF BIRTH',
                            _editing
                                ? _buildDateInput(_dob, context)
                                : _valText(
                                    _dob.text.isEmpty ? 'Not set' : _dob.text,
                                  ),
                            isLast: false,
                          ),
                          _buildFieldItem(
                            'GENDER',
                            _valText(
                              widget.user.gender.isEmpty
                                  ? 'Not set'
                                  : widget.user.gender,
                            ),
                            badge: widget.user.gender.isNotEmpty
                                ? _buildBadge('Verified', Colors.green)
                                : null,
                            isLast: false,
                          ),
                          _buildFieldItem(
                            'GOVERNORATE',
                            _editing
                                ? _buildGovernorateDropdown()
                                : _valText(
                                    _governorate.isEmpty
                                        ? 'Not set'
                                        : _governorate,
                                  ),
                            isLast: false,
                          ),
                          _buildFieldItem(
                            'NATIONAL ID NUMBER',
                            _editing
                                ? _buildNationalIdInput(_govId)
                                : _valText(_formatNationalId(_govId.text)),
                            badge: !_editing && _govId.text.isNotEmpty
                                ? _buildBadge('Provided', Colors.green)
                                : null,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ID Card Verification Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFF3F4F6)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.015),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.shield_outlined,
                                  color: _accent,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'ID Card Verification',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF022B60),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    status == 'Pending Review'
                                        ? Icons.access_time
                                        : Icons.error_outline,
                                    size: 12,
                                    color: statusColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    status,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildUploadCard(
                                title: 'Front Side',
                                description: 'Make sure all text is visible',
                                file: _nationalIdFrontFile,
                                isFront: true,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildUploadCard(
                                title: 'Back Side',
                                description: 'Make sure all text is visible',
                                file: _nationalIdBackFile,
                                isFront: false,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: const [
                            Icon(
                              Icons.upload_file_outlined,
                              size: 14,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Upload clear photos of both sides. Your data is encrypted and secure.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('📌', style: TextStyle(fontSize: 14)),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Your personal information helps us verify your identity and keep your account secure.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF1A5A9E),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldItem(
    String label,
    Widget child, {
    Widget? badge,
    required bool isLast,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(child: child),
                  if (badge != null) badge,
                ],
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(height: 1, color: Color(0xFFF3F4F6), thickness: 1),
      ],
    );
  }

  Widget _valText(String text) {
    final isEmpty = text.isEmpty || text == 'Not set';
    return Text(
      text.isEmpty ? 'Not set' : text,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: isEmpty ? Colors.grey.shade400 : const Color(0xFF1F2937),
        fontStyle: isEmpty ? FontStyle.italic : FontStyle.normal,
      ),
    );
  }

  Widget _buildNameInput(TextEditingController c, String hint) {
    return TextField(
      controller: c,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1F2937),
      ),
      maxLength: 15,
      inputFormatters: [
        LengthLimitingTextInputFormatter(15),
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s\u0600-\u06FF]')),
      ],
      decoration: InputDecoration(
        hintText: hint,
        counterText: "",
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildNationalIdInput(TextEditingController c) {
    return TextField(
      controller: c,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1F2937),
      ),
      maxLength: 14,
      keyboardType: TextInputType.number,
      inputFormatters: [
        LengthLimitingTextInputFormatter(14),
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: const InputDecoration(
        hintText: 'Enter 14-digit National ID',
        counterText: "",
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildGovernorateDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _governorate.isEmpty ? null : _governorate,
        hint: const Text(
          'Select Governorate',
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),
        isExpanded: true,
        isDense: true,
        items: _governorates
            .map(
              (g) => DropdownMenuItem(
                value: g,
                child: Text(g, style: const TextStyle(fontSize: 15)),
              ),
            )
            .toList(),
        onChanged: (v) {
          setState(() {
            _governorate = v ?? '';
          });
        },
      ),
    );
  }

  Widget _buildDateInput(TextEditingController c, BuildContext ctx) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: ctx,
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
          builder: (ctx, child) => Theme(
            data: Theme.of(
              ctx,
            ).copyWith(colorScheme: const ColorScheme.light(primary: _primary)),
            child: child!,
          ),
        );
        if (picked != null) {
          setState(
            () => c.text = '${picked.day}/${picked.month}/${picked.year}',
          );
        }
      },
      child: Row(
        children: [
          Text(
            c.text.isEmpty ? 'Tap to select' : c.text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: c.text.isEmpty ? Colors.grey : const Color(0xFF1F2937),
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.calendar_today_rounded,
            size: 16,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadCard({
    required String title,
    required String description,
    required File? file,
    required bool isFront,
  }) {
    final hasFile = file != null;
    return GestureDetector(
      onTap: () => _pickImage(isFront),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: hasFile ? const Color(0xFFFFF1E8) : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasFile ? _accent : const Color(0xFFE5E7EB),
            width: hasFile ? 2 : 1.5,
          ),
        ),
        child: hasFile
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(
                      file,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () => _removeImage(isFront),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF1E8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: _accent,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 9, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  STUDENT INFO SCREEN
// ══════════════════════════════════════════════════════════════
class StudentInfoScreen extends StatefulWidget {
  final UserProfile user;
  final ValueChanged<UserProfile> onUpdate;
  const StudentInfoScreen({
    super.key,
    required this.user,
    required this.onUpdate,
  });

  @override
  State<StudentInfoScreen> createState() => _StudentInfoScreenState();
}

class _StudentInfoScreenState extends State<StudentInfoScreen> {
  bool _editing = false;
  String _university = '';
  String _college = '';
  String _level = '';
  late final TextEditingController _major;
  late final TextEditingController _nationality;
  String _religion = '';
  List<String> _selectedTags = [];
  File? _studentIdFrontFile;
  File? _studentIdBackFile;

  static const Color _primary = Color(0xFF022B60);
  static const Color _accent = Color(0xFFFF751F);

  static const List<String> _universities = [
    'Cairo University',
    'Ain Shams University',
    'Alexandria University',
    'Giza University',
    'Helwan University',
    'American University in Cairo',
    'British University in Egypt',
    'German University in Cairo',
    'Misr International University',
    'October 6 University',
  ];

  static const Map<String, List<String>> _collegesMap = {
    'Cairo University': [
      'Faculty of Engineering',
      'Faculty of Medicine',
      'Faculty of Commerce',
      'Faculty of Science',
      'Faculty of Arts',
      'Faculty of Law',
    ],
    'Ain Shams University': [
      'Faculty of Engineering',
      'Faculty of Medicine',
      'Faculty of Commerce',
      'Faculty of Science',
      'Faculty of Arts',
      'Faculty of Law',
    ],
    'Alexandria University': [
      'Faculty of Engineering',
      'Faculty of Medicine',
      'Faculty of Commerce',
      'Faculty of Science',
      'Faculty of Arts',
      'Faculty of Law',
    ],
    'Giza University': [
      'Faculty of Pharmacy',
      'Faculty of Dentistry',
      'Faculty of Physical Therapy',
      'Faculty of Nursing',
    ],
    'Helwan University': [
      'Faculty of Fine Arts',
      'Faculty of Music Education',
      'Faculty of Physical Education',
      'Faculty of Applied Arts',
    ],
    'American University in Cairo': [
      'School of Business',
      'School of Sciences',
      'School of Humanities',
      'School of Engineering',
    ],
    'British University in Egypt': [
      'Faculty of Engineering',
      'Faculty of Business',
      'Faculty of Informatics',
      'Faculty of Law',
    ],
    'German University in Cairo': [
      'Faculty of Engineering',
      'Faculty of Management',
      'Faculty of Pharmacy',
      'Faculty of Biotechnology',
    ],
    'Misr International University': [
      'Faculty of Engineering',
      'Faculty of Pharmacy',
      'Faculty of Mass Communication',
      'Faculty of Dentistry',
    ],
    'October 6 University': [
      'Faculty of Medicine',
      'Faculty of Pharmacy',
      'Faculty of Engineering',
      'Faculty of Commerce',
    ],
  };

  static const List<String> _levels = [
    '1st Year',
    '2nd Year',
    '3rd Year',
    '4th Year',
    '5th Year',
    'Masters',
    'PhD',
  ];

  static const Map<String, List<Map<String, dynamic>>> _tagCategories = {
    'Sleeping Schedule': [
      {'id': 'flexible', 'label': 'Flexible', 'icon': Icons.coffee_rounded},
      {'id': 'night_owl', 'label': 'Night Owl', 'icon': Icons.nightlight_round},
      {
        'id': 'early_bird',
        'label': 'Early Bird',
        'icon': Icons.wb_sunny_rounded,
      },
    ],
    'Social Style': [
      {'id': 'social', 'label': 'Social', 'icon': Icons.people_outline_rounded},
      {'id': 'introvert', 'label': 'Introvert', 'icon': Icons.book_rounded},
      {
        'id': 'friendly',
        'label': 'Friendly',
        'icon': Icons.favorite_border_rounded,
      },
      {
        'id': 'study_focused',
        'label': 'Study Focused',
        'icon': Icons.school_rounded,
      },
      {'id': 'gamer', 'label': 'Gamer', 'icon': Icons.gamepad_outlined},
      {
        'id': 'gym_lover',
        'label': 'Gym Lover',
        'icon': Icons.fitness_center_rounded,
      },
    ],
    'Living Style': [
      {
        'id': 'cooking_friendly',
        'label': 'Cooking Friendly',
        'icon': Icons.restaurant_rounded,
      },
      {'id': 'clean', 'label': 'Clean', 'icon': Icons.auto_awesome_rounded},
      {
        'id': 'organized',
        'label': 'Organized',
        'icon': Icons.inventory_2_outlined,
      },
      {'id': 'quiet', 'label': 'Quiet', 'icon': Icons.volume_mute_rounded},
    ],
  };

  @override
  void initState() {
    super.initState();
    _university = widget.user.university;
    _college = widget.user.college;
    _level = widget.user.level;
    _major = TextEditingController(text: widget.user.major);
    _nationality = TextEditingController(text: widget.user.nationality);
    _religion = widget.user.religion.isEmpty ? 'Muslim' : widget.user.religion;
    _selectedTags = List<String>.from(widget.user.tags);
    _studentIdFrontFile = widget.user.studentIdFrontFile;
    _studentIdBackFile = widget.user.studentIdBackFile;
  }

  @override
  void dispose() {
    _major.dispose();
    _nationality.dispose();
    super.dispose();
  }

  void _toggleTag(String tagId) {
    setState(() {
      if (_selectedTags.contains(tagId)) {
        _selectedTags.remove(tagId);
      } else {
        if (_selectedTags.length < 5) {
          _selectedTags.add(tagId);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Maximum 5 tags allowed'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    });
  }

  Map<String, dynamic> _getTagDetails(String tagId) {
    for (var category in _tagCategories.values) {
      for (var tag in category) {
        if (tag['id'] == tagId) return tag;
      }
    }
    return {'id': tagId, 'label': tagId, 'icon': Icons.tag_rounded};
  }

  void _save() {
    if (_selectedTags.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least 3 tags'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final updated = widget.user.copyWith(
      university: _university,
      college: _college,
      level: _level,
      major: _major.text.trim(),
      nationality: _nationality.text.trim(),
      religion: _religion,
      tags: _selectedTags,
      studentIdFrontFile: _studentIdFrontFile,
      studentIdBackFile: _studentIdBackFile,
    );
    widget.onUpdate(updated);
    setState(() => _editing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Student information updated successfully!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _pickImage(bool isFront) async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        setState(() {
          if (isFront) {
            _studentIdFrontFile = file;
          } else {
            _studentIdBackFile = file;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${isFront ? "Front" : "Back"} side uploaded'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking file: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _removeImage(bool isFront) {
    setState(() {
      if (isFront) {
        _studentIdFrontFile = null;
      } else {
        _studentIdBackFile = null;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${isFront ? "Front" : "Back"} side removed'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasColleges = _university.isNotEmpty;
    final availableColleges = hasColleges
        ? _collegesMap[_university] ?? []
        : <String>[];

    final univItems = List<String>.from(_universities);
    if (_university.isNotEmpty && !univItems.contains(_university)) {
      univItems.add(_university);
    }

    final collegeItems = List<String>.from(availableColleges);
    if (_college.isNotEmpty && !collegeItems.contains(_college)) {
      collegeItems.add(_college);
    }

    final levelItems = List<String>.from(_levels);
    if (_level.isNotEmpty && !levelItems.contains(_level)) {
      levelItems.add(_level);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              color: _primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              bottom: 24,
              left: 20,
              right: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const Text(
                      'Student Information',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: _editing
                          ? _save
                          : () => setState(() => _editing = true),
                      style: TextButton.styleFrom(
                        foregroundColor: _accent,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        _editing ? 'Save' : 'Edit',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Manage your academic information and preferences',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_editing) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: Colors.blue.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'You can edit your academic information below.\nReligion cannot be changed after verification.',
                              style: TextStyle(
                                color: Colors.blue.shade800,
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Academic Information Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFF3F4F6)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.015),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Column(
                        children: [
                          _buildFieldItem(
                            'UNIVERSITY',
                            _editing
                                ? _buildDropdown(
                                    univItems,
                                    _university.isEmpty ? null : _university,
                                    'Select University',
                                    (v) => setState(() {
                                      _university = v ?? '';
                                      _college = '';
                                    }),
                                  )
                                : _valText(_university),
                            isLast: false,
                          ),
                          _buildFieldItem(
                            'COLLEGE / FACULTY',
                            _editing
                                ? _buildDropdown(
                                    collegeItems,
                                    _college.isEmpty ? null : _college,
                                    _university.isEmpty
                                        ? 'Select University first'
                                        : 'Select College',
                                    (v) => setState(() => _college = v ?? ''),
                                    disabled: _university.isEmpty,
                                  )
                                : _valText(_college),
                            isLast: false,
                          ),
                          _buildFieldItem(
                            'ACADEMIC LEVEL',
                            _editing
                                ? _buildDropdown(
                                    levelItems,
                                    _level.isEmpty ? null : _level,
                                    'Select level',
                                    (v) => setState(() => _level = v ?? ''),
                                  )
                                : _valText(_level),
                            isLast: false,
                          ),
                          _buildFieldItem(
                            'MAJOR / SPECIALIZATION',
                            _editing
                                ? _buildInput(
                                    _major,
                                    'e.g. Computer Science, Business',
                                  )
                                : _valText(_major.text),
                            isLast: false,
                          ),
                          _buildFieldItem(
                            'NATIONALITY',
                            _editing
                                ? _buildInput(_nationality, 'Your nationality')
                                : _valText(_nationality.text),
                            isLast: false,
                          ),
                          _buildFieldItem(
                            'RELIGION',
                            _valText(_religion),
                            badge: _buildBadge('Verified', Colors.green),
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Student ID Card Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFF3F4F6)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.015),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.badge_outlined,
                              color: Colors.grey,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Student ID Card',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Upload your university ID card (front and back)',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildUploadCard(
                                title: 'Front Side',
                                description: 'Make sure all text is visible',
                                file: _studentIdFrontFile,
                                isFront: true,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildUploadCard(
                                title: 'Back Side',
                                description: 'Make sure all text is visible',
                                file: _studentIdBackFile,
                                isFront: false,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: const [
                            Icon(
                              Icons.upload_file_outlined,
                              size: 14,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Upload clear photos of both sides. Your student ID is used for roommate verification.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tags Section (Interests & Lifestyle)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFF3F4F6)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.015),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.tag_rounded,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Student Interests & Lifestyle',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                              ],
                            ),
                            if (!_editing && _selectedTags.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${_selectedTags.length} tags',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (_editing) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Text(
                                  'Select tags that describe you (minimum 3, maximum 5)',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Text(
                                '${_selectedTags.length}/5 selected',
                                style: TextStyle(
                                  color: _selectedTags.length < 3
                                      ? Colors.red
                                      : Colors.green,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ..._tagCategories.entries.map((category) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 8.0,
                                    top: 4.0,
                                  ),
                                  child: Text(
                                    category.key,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4B5563),
                                    ),
                                  ),
                                ),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: category.value.map((tag) {
                                    final isSelected = _selectedTags.contains(
                                      tag['id'],
                                    );
                                    return FilterChip(
                                      selected: isSelected,
                                      avatar: Icon(
                                        tag['icon'] as IconData,
                                        size: 14,
                                        color: isSelected
                                            ? _accent
                                            : const Color(0xFF4B5563),
                                      ),
                                      label: Text(tag['label'] as String),
                                      labelStyle: TextStyle(
                                        color: isSelected
                                            ? _accent
                                            : const Color(0xFF1F2937),
                                        fontSize: 13,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                      selectedColor: const Color(
                                        0xFFFF751F,
                                      ).withOpacity(0.1),
                                      checkmarkColor: _accent,
                                      backgroundColor: const Color(0xFFF3F4F6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                          color: isSelected
                                              ? const Color(
                                                  0xFFFF751F,
                                                ).withOpacity(0.2)
                                              : Colors.transparent,
                                        ),
                                      ),
                                      showCheckmark: false,
                                      onSelected: (_) =>
                                          _toggleTag(tag['id'] as String),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 12),
                              ],
                            );
                          }).toList(),
                        ] else ...[
                          if (_selectedTags.isEmpty)
                            const Text(
                              'No tags selected',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                              ),
                            )
                          else
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _selectedTags.map((tagId) {
                                final tag = _getTagDetails(tagId);
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFFF751F,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(
                                        0xFFFF751F,
                                      ).withOpacity(0.2),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        tag['icon'] as IconData,
                                        size: 14,
                                        color: _accent,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        tag['label'] as String,
                                        style: const TextStyle(
                                          color: _accent,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('📌', style: TextStyle(fontSize: 14)),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'This information helps property owners find suitable roommates and verify your student status.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF4B5563),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldItem(
    String label,
    Widget child, {
    Widget? badge,
    required bool isLast,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(child: child),
                  if (badge != null) badge,
                ],
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(height: 1, color: Color(0xFFF3F4F6), thickness: 1),
      ],
    );
  }

  Widget _valText(String text) {
    final isEmpty = text.isEmpty || text == 'Not set';
    return Text(
      text.isEmpty ? 'Not set' : text,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: isEmpty ? Colors.grey.shade400 : const Color(0xFF1F2937),
        fontStyle: isEmpty ? FontStyle.italic : FontStyle.normal,
      ),
    );
  }

  Widget _buildInput(TextEditingController c, String hint) {
    return TextField(
      controller: c,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1F2937),
      ),
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildDropdown(
    List<String> items,
    String? value,
    String hint,
    ValueChanged<String?> onChanged, {
    bool disabled = false,
  }) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        hint: Text(
          hint,
          style: TextStyle(
            color: disabled ? Colors.grey.shade300 : Colors.grey,
            fontSize: 15,
          ),
        ),
        isExpanded: true,
        isDense: true,
        items: disabled
            ? null
            : items
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: const TextStyle(fontSize: 15)),
                    ),
                  )
                  .toList(),
        onChanged: disabled ? null : onChanged,
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadCard({
    required String title,
    required String description,
    required File? file,
    required bool isFront,
  }) {
    final hasFile = file != null;
    return GestureDetector(
      onTap: () => _pickImage(isFront),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: hasFile ? const Color(0xFFFFF1E8) : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasFile ? _accent : const Color(0xFFE5E7EB),
            width: hasFile ? 2 : 1.5,
          ),
        ),
        child: hasFile
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(
                      file,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () => _removeImage(isFront),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF1E8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: _accent,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 9, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}
