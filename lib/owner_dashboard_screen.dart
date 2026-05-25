import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home_screen.dart';
import 'list_property_form_screen.dart';
import 'owner_requests_screen.dart';

class OwnerDashboardScreen extends StatefulWidget {
  final String userName;

  const OwnerDashboardScreen({super.key, required this.userName});

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  // Local list of owner listings, initialized with some dummy listings
  late List<Listing> _ownerListings;
  
  // Local state for requests, we will pass this to OwnerRequestsScreen
  late List<OwnerRequestData> _requests;

  static const Color _primary = Color(0xFF022B60);
  static const Color _accent = Color(0xFFFF751F);
  static const Color _accentSoft = Color(0xFFFFF1E8);
  static const Color _pageBg = Color(0xFFF8F9FB);

  @override
  void initState() {
    super.initState();
    // Initialize owner's listings with a subset of dummyListings for display
    _ownerListings = [
      dummyListings[0],
      dummyListings[1],
      dummyListings[2],
    ];

    // Initialize mock requests for the owner's listings
    _requests = [
      OwnerRequestData(
        id: 'req_owner_1',
        studentName: 'Shaheen Ahmed',
        studentMajor: 'Computer Science',
        studentYear: '4th Year',
        status: 'pending',
        listingId: '1',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        message: 'Hello! I am a quiet and clean student looking for a shared room near campus. I do not smoke and do not have pets.',
        studentTags: ['Male', 'Quiet', 'Non-Smoker', 'No Pets'],
      ),
      OwnerRequestData(
        id: 'req_owner_2',
        studentName: 'Mariam Ali',
        studentMajor: 'Dentistry',
        studentYear: '2nd Year',
        status: 'accepted',
        listingId: '1',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        message: 'Hi, I would love to move in starting next semester. Let me know if we can schedule a visit!',
        studentTags: ['Female', 'Studious', 'Quiet', 'No Pets'],
      ),
      OwnerRequestData(
        id: 'req_owner_3',
        studentName: 'Youssef Omar',
        studentMajor: 'Engineering',
        studentYear: '3rd Year',
        status: 'under_coordination',
        listingId: '3',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        message: 'Interested in the spacious room. Mawa coordinate details please.',
        studentTags: ['Male', 'Non-Smoker', 'Active', 'No Pets'],
      ),
    ];
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 18) return 'Good Afternoon';
    return 'Good Evening';
  }

  int get _totalStudents {
    return _ownerListings.fold(0, (sum, listing) => sum + listing.currentRoommates);
  }

  int get _pendingRequestsCount {
    return _requests.where((r) => r.status == 'pending').length;
  }

  void _onAddProperty() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ListPropertyFormScreen(
          userId: widget.userName,
          onComplete: (data) {
            // Convert creation payload to local listing object
            final roomsList = data['rooms'] as List? ?? [];
            double price = 0.0;
            if (roomsList.isNotEmpty) {
              price = (roomsList[0]['pricePerBed'] as num?)?.toDouble() ?? 0.0;
            }
            
            final totalBeds = roomsList.fold(0, (sum, room) => sum + (room['numberOfBeds'] as int? ?? 1));

            final newListing = Listing(
              id: (DateTime.now().millisecondsSinceEpoch).toString(),
              title: data['Title'] ?? 'New Property Listing',
              location: '${data['District'] ?? 'District'}, ${data['City'] ?? 'City'}',
              price: price,
              imageUrl: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=500',
              distanceFromUniversity: 1.2,
              maxRoommates: totalBeds,
              tags: List<String>.from(data['amenities'] ?? []),
              rooms: roomsList.length,
              currentRoommates: 0,
            );

            setState(() {
              _ownerListings.insert(0, newListing);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isTablet = size.width >= 700;
    final contentWidth = isTablet ? 680.0 : double.infinity;

    return Scaffold(
      backgroundColor: _pageBg,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(isTablet),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentWidth),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(const Duration(milliseconds: 800));
                    },
                    color: _accent,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 0 : 20.w,
                        vertical: 20.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatsCard(),
                          SizedBox(height: 24.h),
                          _buildQuickActions(),
                          SizedBox(height: 28.h),
                          _buildListingsHeader(),
                          SizedBox(height: 14.h),
                          _buildListingsSection(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddProperty,
        backgroundColor: _accent,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildHeader(bool isTablet) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      padding: EdgeInsets.fromLTRB(
        isTablet ? (MediaQuery.sizeOf(context).width - 680) / 2 + 20 : 24.w,
        MediaQuery.of(context).padding.top + 16.h,
        isTablet ? (MediaQuery.sizeOf(context).width - 680) / 2 + 20 : 24.w,
        24.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$_greeting,',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 13.sp),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        widget.userName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          Container(
                            width: 7.w,
                            height: 7.w,
                            decoration: const BoxDecoration(
                              color: Colors.greenAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Verified Owner',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  // Switch to student view button
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.swap_horiz_rounded, color: Colors.orange, size: 16),
                    label: Text(
                      'Student View',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.08),
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 10.w),
      child: Row(
        children: [
          Expanded(
            child: _statColumn(
              title: 'Your Properties',
              value: _ownerListings.length.toString(),
              label: 'Listings',
              valueColor: Colors.black87,
            ),
          ),
          Container(width: 1, height: 40.h, color: Colors.grey.shade100),
          Expanded(
            child: _statColumn(
              title: 'Students Living',
              value: _totalStudents.toString(),
              label: 'Active',
              valueColor: Colors.black87,
            ),
          ),
          Container(width: 1, height: 40.h, color: Colors.grey.shade100),
          Expanded(
            child: _statColumn(
              title: 'Pending',
              value: _pendingRequestsCount.toString(),
              label: 'Requests',
              valueColor: _accent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statColumn({
    required String title,
    required String value,
    required String label,
    required Color valueColor,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.black38, fontSize: 11.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 6.h),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(color: Colors.black38, fontSize: 10.sp),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _quickActionButton(
            icon: Icons.add_circle_outline_rounded,
            label: 'Add Listing',
            iconColor: _accent,
            bgColor: _accentSoft,
            onTap: _onAddProperty,
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: _quickActionButton(
            icon: Icons.home_work_outlined,
            label: 'Listings',
            iconColor: Colors.blue.shade700,
            bgColor: Colors.blue.shade50,
            onTap: () {}, // Simply stays on dashboard and filters/scrolls
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              _quickActionButton(
                icon: Icons.description_outlined,
                label: 'Requests',
                iconColor: Colors.green.shade700,
                bgColor: Colors.green.shade50,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OwnerRequestsScreen(
                        requests: _requests,
                        listings: _ownerListings,
                        userName: widget.userName,
                        onAcceptRequest: (id) {
                          setState(() {
                            final idx = _requests.indexWhere((r) => r.id == id);
                            if (idx != -1) {
                              _requests[idx] = _requests[idx].copyWith(status: 'accepted');
                            }
                          });
                        },
                        onRejectRequest: (id) {
                          setState(() {
                            final idx = _requests.indexWhere((r) => r.id == id);
                            if (idx != -1) {
                              _requests[idx] = _requests[idx].copyWith(status: 'rejected');
                            }
                          });
                        },
                      ),
                    ),
                  ).then((_) => setState(() {}));
                },
              ),
              if (_pendingRequestsCount > 0)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: EdgeInsets.all(5.w),
                    decoration: const BoxDecoration(
                      color: _accent,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 18.w,
                      minHeight: 18.w,
                    ),
                    child: Center(
                      child: Text(
                        _pendingRequestsCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _quickActionButton({
    required IconData icon,
    required String label,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListingsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Your Listings',
          style: TextStyle(
            color: _primary,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (_ownerListings.length > 3)
          TextButton(
            onPressed: () {},
            child: Text(
              'See All →',
              style: TextStyle(
                color: _accent,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildListingsSection() {
    if (_ownerListings.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          children: [
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.home_outlined, color: Colors.black38, size: 28),
            ),
            SizedBox(height: 16.h),
            Text(
              'No Listings Yet',
              style: TextStyle(color: Colors.black87, fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6.h),
            Text(
              'Start by adding your first property',
              style: TextStyle(color: Colors.black38, fontSize: 12.sp),
            ),
            SizedBox(height: 18.h),
            ElevatedButton(
              onPressed: _onAddProperty,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                elevation: 0,
              ),
              child: Text(
                '+ Add Listing',
                style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _ownerListings.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final listing = _ownerListings[index];
        final current = listing.currentRoommates;
        final max = listing.maxRoommates;
        final percent = max > 0 ? (current / max) : 0.0;
        final isActive = index % 2 == 0; // Alternate active and pending status

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.all(14.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  listing.imageUrl,
                  width: 76.w,
                  height: 76.w,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 76.w,
                    height: 76.w,
                    color: Colors.grey.shade100,
                    child: const Icon(Icons.image_not_supported_rounded, color: Colors.black26),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            listing.title,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '${listing.price.toInt()} EGP',
                          style: TextStyle(
                            color: _accent,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          listing.location.split(',')[0],
                          style: TextStyle(color: Colors.black38, fontSize: 11.sp),
                        ),
                        Text('/bed', style: TextStyle(color: Colors.black38, fontSize: 9.sp)),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$current/$max beds occupied',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: isActive ? Colors.green.shade50 : Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isActive ? 'Active' : 'Pending',
                            style: TextStyle(
                              color: isActive ? Colors.green.shade700 : Colors.orange.shade700,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percent,
                        backgroundColor: Colors.grey.shade100,
                        color: _accent,
                        minHeight: 4.h,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
