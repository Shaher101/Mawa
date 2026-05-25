import 'package:flutter/material.dart';

// ============================================================
// MODEL: RentalRequest
// ============================================================
class RentalRequest {
  final String id;
  final String listingId;
  final String listingTitle;
  final String listingLocation;
  final String listingImageUrl;
  final double listingPrice;
  final RequestStatus status;
  final DateTime moveInDate;
  final DateTime requestDate;
  final String? rejectionReason;

  RentalRequest({
    required this.id,
    required this.listingId,
    required this.listingTitle,
    required this.listingLocation,
    required this.listingImageUrl,
    required this.listingPrice,
    required this.status,
    required this.moveInDate,
    required this.requestDate,
    this.rejectionReason,
  });

  // TODO (Backend): factory RentalRequest.fromJson(Map<String, dynamic> json)
  // GET /api/requests/?student_id={userId}
}

enum RequestStatus { pending, accepted, rejected }

// ============================================================
// DUMMY DATA — يتحذف لما الـ API يتربط
// ============================================================
final List<RentalRequest> dummyRequests = [
  RentalRequest(
    id: 'req_1',
    listingId: '1',
    listingTitle: 'Cozy 2BR Near KAU - Female Students',
    listingLocation: 'Al Andalus, Jeddah',
    listingImageUrl:
        'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=500',
    listingPrice: 1800,
    status: RequestStatus.pending,
    moveInDate: DateTime(2025, 9, 1),
    requestDate: DateTime.now().subtract(const Duration(days: 2)),
  ),
  RentalRequest(
    id: 'req_2',
    listingId: '2',
    listingTitle: 'Modern Studio Near KFUPM',
    listingLocation: 'Dhahran, Eastern Province',
    listingImageUrl:
        'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=500',
    listingPrice: 2200,
    status: RequestStatus.accepted,
    moveInDate: DateTime(2025, 8, 15),
    requestDate: DateTime.now().subtract(const Duration(days: 5)),
  ),
  RentalRequest(
    id: 'req_3',
    listingId: '4',
    listingTitle: 'Budget Room Near UQU',
    listingLocation: 'Aziziyah, Makkah',
    listingImageUrl:
        'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=500',
    listingPrice: 900,
    status: RequestStatus.rejected,
    moveInDate: DateTime(2025, 10, 1),
    requestDate: DateTime.now().subtract(const Duration(days: 7)),
    rejectionReason: 'Unit no longer available',
  ),
  RentalRequest(
    id: 'req_4',
    listingId: '3',
    listingTitle: 'Spacious 3BR Shared Apartment',
    listingLocation: 'Madinah Road, Jeddah',
    listingImageUrl:
        'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=500',
    listingPrice: 1200,
    status: RequestStatus.accepted,
    moveInDate: DateTime(2025, 9, 20),
    requestDate: DateTime.now().subtract(const Duration(days: 1)),
  ),
];

// ============================================================
// REQUESTS SCREEN
// ============================================================
class RequestsScreen extends StatefulWidget {
  final String userId; // يتبعت من HomeScreen

  const RequestsScreen({super.key, required this.userId});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // TODO (Backend): جلب الطلبات من الـ API
  // GET /api/requests/?student_id={widget.userId}
  // وبعدين setState بالـ requests اللي ترجع
  List<RentalRequest> requests = dummyRequests;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // TODO: استدعي _fetchRequests() هنا لما الـ API يتربط
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<RentalRequest> get _pendingRequests =>
      requests.where((r) => r.status == RequestStatus.pending).toList();

  List<RentalRequest> get _acceptedRequests =>
      requests.where((r) => r.status == RequestStatus.accepted).toList();

  List<RentalRequest> get _rejectedRequests =>
      requests.where((r) => r.status == RequestStatus.rejected).toList();

  // TODO (Backend): دالة لجلب الطلبات
  // Future<void> _fetchRequests() async {
  //   setState(() => isLoading = true);
  //   final response = await http.get(Uri.parse('/api/requests/?student_id=${widget.userId}'));
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body) as List;
  //     setState(() {
  //       requests = data.map((e) => RentalRequest.fromJson(e)).toList();
  //       isLoading = false;
  //     });
  //   }
  // }

  // TODO (Backend): دالة لإلغاء الـ request
  // Future<void> _cancelRequest(String requestId) async {
  //   await http.delete(Uri.parse('/api/requests/$requestId/'));
  //   _fetchRequests();
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          _buildHeader(screenWidth),
          _buildTabBar(screenWidth),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  )
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildRequestsList(requests),
                      _buildRequestsList(_pendingRequests),
                      _buildRequestsList(_acceptedRequests),
                      _buildRequestsList(_rejectedRequests),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0B2A4A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 24,
        left: screenWidth * 0.06,
        right: screenWidth * 0.06,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Requests',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${requests.length} total ${requests.length == 1 ? 'request' : 'requests'}',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: screenWidth * 0.033,
                  ),
                ),
              ],
            ),
          ),
          // Stats summary
          Row(
            children: [
              _statBadge(
                _pendingRequests.length.toString(),
                Colors.orange,
                'Pending',
              ),
              const SizedBox(width: 8),
              _statBadge(
                _acceptedRequests.length.toString(),
                const Color(0xFF4CAF50),
                'Accepted',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statBadge(String count, Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(label, style: TextStyle(color: color, fontSize: 9)),
        ],
      ),
    );
  }

  Widget _buildTabBar(double screenWidth) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.orange,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.orange,
        indicatorWeight: 3,
        labelStyle: TextStyle(
          fontSize: screenWidth * 0.031,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(fontSize: screenWidth * 0.031),
        tabs: [
          Tab(text: 'All (${requests.length})'),
          Tab(text: 'Pending (${_pendingRequests.length})'),
          Tab(text: 'Accepted (${_acceptedRequests.length})'),
          Tab(text: 'Rejected (${_rejectedRequests.length})'),
        ],
      ),
    );
  }

  Widget _buildRequestsList(List<RentalRequest> list) {
    if (list.isEmpty) return _buildEmptyState();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) => _buildRequestCard(list[index]),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.description_outlined,
              size: 40,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No requests here',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your rental requests will appear here',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(RentalRequest request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top: image + info
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    request.listingImageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.home, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.listingTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF0B2A4A),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 12,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              request.listingLocation,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${request.listingPrice.toInt()} SAR/month',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Status Badge
                _buildStatusBadge(request.status),
              ],
            ),
          ),

          // Divider
          Divider(height: 1, color: Colors.grey.shade100),

          // Bottom: dates + action
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    _infoChip(
                      Icons.calendar_today_outlined,
                      'Move-in: ${_formatDate(request.moveInDate)}',
                    ),
                    const SizedBox(width: 10),
                    _infoChip(
                      Icons.access_time_outlined,
                      'Sent: ${_formatDate(request.requestDate)}',
                    ),
                  ],
                ),

                // Rejection reason
                if (request.status == RequestStatus.rejected &&
                    request.rejectionReason != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade100),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 14,
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            request.rejectionReason!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Pay Now button for accepted
                if (request.status == RequestStatus.accepted) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO (Backend): ربط بصفحة الدفع
                        // Navigator.push(context, MaterialPageRoute(
                        //   builder: (_) => PaymentScreen(requestId: request.id),
                        // ));
                        _showPaymentBottomSheet(context, request);
                      },
                      icon: const Icon(
                        Icons.credit_card,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Pay Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],

                // Cancel button for pending
                if (request.status == RequestStatus.pending) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showCancelDialog(context, request.id),
                      icon: Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.red.shade400,
                      ),
                      label: Text(
                        'Cancel Request',
                        style: TextStyle(
                          color: Colors.red.shade400,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        side: BorderSide(color: Colors.red.shade200),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(RequestStatus status) {
    final config = {
      RequestStatus.pending: {
        'label': 'Pending',
        'color': Colors.orange,
        'bg': Colors.orange.shade50,
        'icon': Icons.hourglass_empty_rounded,
      },
      RequestStatus.accepted: {
        'label': 'Accepted',
        'color': const Color(0xFF4CAF50),
        'bg': const Color(0xFFE8F5E9),
        'icon': Icons.check_circle_outline_rounded,
      },
      RequestStatus.rejected: {
        'label': 'Rejected',
        'color': Colors.red.shade400,
        'bg': Colors.red.shade50,
        'icon': Icons.cancel_outlined,
      },
    }[status]!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: config['bg'] as Color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            config['icon'] as IconData,
            size: 13,
            color: config['color'] as Color,
          ),
          const SizedBox(width: 4),
          Text(
            config['label'] as String,
            style: TextStyle(
              color: config['color'] as Color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.grey),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _showCancelDialog(BuildContext context, String requestId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Cancel Request',
          style: TextStyle(
            color: Color(0xFF0B2A4A),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Are you sure you want to cancel this request? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Keep It',
              style: TextStyle(color: Color(0xFF0B2A4A)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              // TODO (Backend): DELETE /api/requests/{requestId}/
              setState(() {
                requests.removeWhere((r) => r.id == requestId);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Request cancelled'),
                  backgroundColor: Colors.red.shade400,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Cancel Request',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentBottomSheet(BuildContext context, RentalRequest request) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Complete Payment',
              style: TextStyle(
                color: Color(0xFF0B2A4A),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF0B2A4A).withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      request.listingImageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.home, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.listingTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0B2A4A),
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${request.listingPrice.toInt()} SAR/month',
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // TODO (Backend): ربط بـ Payment Gateway (Stripe / HyperPay / Tabby)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Redirecting to payment...'),
                      backgroundColor: Colors.orange,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.credit_card, color: Colors.white),
                label: Text(
                  'Pay ${request.listingPrice.toInt()} SAR',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
