import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home_screen.dart';

class OwnerRequestData {
  final String id;
  final String studentName;
  final String studentMajor;
  final String studentYear;
  final String status; // 'pending' | 'accepted' | 'under_coordination' | 'rejected'
  final String listingId;
  final DateTime createdAt;
  final String message;
  final List<String> studentTags;

  OwnerRequestData({
    required this.id,
    required this.studentName,
    required this.studentMajor,
    required this.studentYear,
    required this.status,
    required this.listingId,
    required this.createdAt,
    required this.message,
    required this.studentTags,
  });

  OwnerRequestData copyWith({
    String? id,
    String? studentName,
    String? studentMajor,
    String? studentYear,
    String? status,
    String? listingId,
    DateTime? createdAt,
    String? message,
    List<String>? studentTags,
  }) {
    return OwnerRequestData(
      id: id ?? this.id,
      studentName: studentName ?? this.studentName,
      studentMajor: studentMajor ?? this.studentMajor,
      studentYear: studentYear ?? this.studentYear,
      status: status ?? this.status,
      listingId: listingId ?? this.listingId,
      createdAt: createdAt ?? this.createdAt,
      message: message ?? this.message,
      studentTags: studentTags ?? this.studentTags,
    );
  }
}

class OwnerRequestsScreen extends StatefulWidget {
  final List<OwnerRequestData> requests;
  final List<Listing> listings;
  final String userName;
  final Function(String) onAcceptRequest;
  final Function(String) onRejectRequest;

  const OwnerRequestsScreen({
    super.key,
    required this.requests,
    required this.listings,
    required this.userName,
    required this.onAcceptRequest,
    required this.onRejectRequest,
  });

  @override
  State<OwnerRequestsScreen> createState() => _OwnerRequestsScreenState();
}

class _OwnerRequestsScreenState extends State<OwnerRequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const Color _primary = Color(0xFF022B60);
  static const Color _accent = Color(0xFFFF751F);
  static const Color _accentSoft = Color(0xFFFFF1E8);
  static const Color _pageBg = Color(0xFFF8F9FB);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int _countForStatus(String status) {
    return widget.requests.where((r) => r.status == status).length;
  }

  List<OwnerRequestData> _filterRequests(String status) {
    return widget.requests.where((r) => r.status == status).toList();
  }

  Map<String, dynamic> _statusConfig(String status) {
    switch (status) {
      case 'pending':
        return {
          'label': 'Pending',
          'color': Colors.orange.shade700,
          'bg': Colors.orange.shade50,
          'icon': Icons.access_time_rounded,
        };
      case 'accepted':
        return {
          'label': 'Accepted',
          'color': Colors.green.shade700,
          'bg': Colors.green.shade50,
          'icon': Icons.check_circle_outline_rounded,
        };
      case 'under_coordination':
        return {
          'label': 'Coordinating',
          'color': Colors.blue.shade700,
          'bg': Colors.blue.shade50,
          'icon': Icons.shield_outlined,
        };
      case 'rejected':
      default:
        return {
          'label': 'Rejected',
          'color': Colors.red.shade700,
          'bg': Colors.red.shade50,
          'icon': Icons.cancel_outlined,
        };
    }
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
            _buildTabBar(isTablet),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentWidth),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildRequestsList(_filterRequests('pending')),
                      _buildRequestsList(_filterRequests('accepted')),
                      _buildRequestsList(_filterRequests('under_coordination')),
                      _buildRequestsList(_filterRequests('rejected')),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
        20.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.notifications_none_rounded, color: Colors.white70, size: 18),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'Requests',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Review student requests for your listings',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(bool isTablet) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? (MediaQuery.sizeOf(context).width - 680) / 2 + 10 : 10.w,
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: _accent,
        unselectedLabelColor: Colors.grey,
        indicatorColor: _accent,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
        tabAlignment: TabAlignment.start,
        labelStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.normal),
        tabs: [
          Tab(text: 'Pending (${_countForStatus('pending')})'),
          Tab(text: 'Accepted (${_countForStatus('accepted')})'),
          Tab(text: 'Coordinating (${_countForStatus('under_coordination')})'),
          Tab(text: 'Rejected (${_countForStatus('rejected')})'),
        ],
      ),
    );
  }

  Widget _buildRequestsList(List<OwnerRequestData> list) {
    if (list.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 72.w,
                  height: 72.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Icon(Icons.chat_bubble_outline_rounded, size: 32.sp, color: Colors.black26),
                ),
                SizedBox(height: 18.h),
                Text(
                  'No Requests found',
                  style: TextStyle(color: Colors.black87, fontSize: 15.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6.h),
                Text(
                  'When students apply to your properties, they will appear here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black38, fontSize: 12.sp),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(18.w),
      itemCount: list.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final request = list[index];
        final listing = widget.listings.firstWhere(
          (l) => l.id == request.listingId,
          orElse: () => Listing(
            id: '',
            title: 'Unknown Property',
            location: 'N/A',
            price: 0,
            imageUrl: '',
            distanceFromUniversity: 0,
            maxRoommates: 0,
            tags: [],
            rooms: 0,
            currentRoommates: 0,
          ),
        );
        
        final config = _statusConfig(request.status);
        final IconData statusIcon = config['icon'];

        return InkWell(
          onTap: () => _showRequestDetailsBottomSheet(request, listing),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.015),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            padding: EdgeInsets.all(14.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: _accentSoft,
                  child: Text(
                    request.studentName.substring(0, 1).toUpperCase(),
                    style: TextStyle(color: _accent, fontWeight: FontWeight.bold, fontSize: 16.sp),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                request.studentName,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                '${request.studentMajor} • ${request.studentYear}',
                                style: TextStyle(color: Colors.black38, fontSize: 11.sp),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: config['bg'],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(statusIcon, color: config['color'], size: 12),
                                SizedBox(width: 4.w),
                                Text(
                                  config['label'],
                                  style: TextStyle(
                                    color: config['color'],
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          const Icon(Icons.home_outlined, color: Colors.black38, size: 14),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              listing.title,
                              style: TextStyle(color: Colors.black54, fontSize: 11.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            '${listing.price.toInt()} EGP',
                            style: TextStyle(
                              color: _accent,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, color: Colors.black26, size: 12),
                          SizedBox(width: 6.w),
                          Text(
                            '${request.createdAt.day}/${request.createdAt.month}/${request.createdAt.year}',
                            style: TextStyle(color: Colors.black38, fontSize: 10.sp),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4.w),
                const Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.chevron_right_rounded, color: Colors.black26),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showRequestDetailsBottomSheet(OwnerRequestData request, Listing listing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final config = _statusConfig(request.status);
        
        return StatefulBuilder(
          builder: (dialogContext, setModalState) {
            final isPending = request.status == 'pending';

            void accept() {
              widget.onAcceptRequest(request.id);
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Request Accepted! ✓'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            }

            void reject() {
              widget.onRejectRequest(request.id);
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Request Rejected'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            }

            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
              ),
              padding: EdgeInsets.fromLTRB(
                20.w,
                16.h,
                20.w,
                MediaQuery.of(dialogContext).viewInsets.bottom + 24.h,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.85,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 44.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      SizedBox(height: 18.h),
                      
                      // Header Card
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: config['bg'],
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.white,
                              child: Text(
                                request.studentName.substring(0, 1).toUpperCase(),
                                style: TextStyle(color: _accent, fontWeight: FontWeight.bold, fontSize: 18.sp),
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    request.studentName,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    '${request.studentMajor} Student',
                                    style: TextStyle(color: Colors.black54, fontSize: 12.sp),
                                  ),
                                  Text(
                                    'Ain Shams University • ${request.studentYear}',
                                    style: TextStyle(color: Colors.black38, fontSize: 11.sp),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      
                      // Student Tags
                      Text(
                        'About the student',
                        style: TextStyle(color: Colors.black38, fontSize: 11.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: request.studentTags.map((tag) {
                          String icon = '📌';
                          if (tag.toLowerCase().contains('male')) icon = '👨';
                          if (tag.toLowerCase().contains('female')) icon = '👩';
                          if (tag.toLowerCase().contains('quiet')) icon = '🔇';
                          if (tag.toLowerCase().contains('smoke')) icon = '🚭';
                          if (tag.toLowerCase().contains('pet')) icon = '🐾';
                          
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(icon, style: TextStyle(fontSize: 11.sp)),
                                SizedBox(width: 4.w),
                                Text(
                                  tag,
                                  style: TextStyle(color: Colors.black54, fontSize: 11.sp, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20.h),
                      
                      // Property Applied For
                      Text(
                        'Property applied for',
                        style: TextStyle(color: Colors.black38, fontSize: 11.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade100),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              listing.title,
                              style: TextStyle(color: Colors.black87, fontSize: 13.sp, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, color: Colors.black38, size: 14),
                                SizedBox(width: 4.w),
                                Text(
                                  listing.location,
                                  style: TextStyle(color: Colors.black38, fontSize: 11.sp),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              '${listing.price.toInt()} EGP/month',
                              style: TextStyle(color: _accent, fontSize: 13.sp, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      
                      // Student Message
                      Text(
                        "Student's message",
                        style: TextStyle(color: Colors.black38, fontSize: 11.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade100),
                        ),
                        child: Text(
                          '"${request.message}"',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12.sp,
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      
                      // Coordinator Warning
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.shield_outlined, color: Colors.blue.shade700, size: 18.sp),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                'Mawa will coordinate the next steps and secure tenancy details after approval.',
                                style: TextStyle(
                                  color: Colors.blue.shade800,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      
                      // Actions
                      if (isPending)
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: accept,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _accent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Accept Request',
                                  style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: reject,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red.shade600,
                                  side: BorderSide(color: Colors.red.shade200),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                ),
                                child: Text(
                                  'Reject',
                                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: Text(
                              'Request Status: ${request.status.toUpperCase()}',
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
