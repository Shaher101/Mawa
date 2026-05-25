import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'owner_dashboard_screen.dart';
import 'profile_screen.dart';
import 'requests_screen.dart';
import 'favorites_screen.dart';
import 'notifications_screen.dart';
import 'sign_in.dart';

// ============================================================
// TODO (Backend Team): ربط الـ API الخاص بالشقق
// [1] GET /api/listings/
// [2] GET /api/listings/?near_university=true
// [3] GET /api/listings/?shared=true
// ============================================================

class Listing {
  final String id;
  final String title;
  final String location;
  final double price;
  final String imageUrl;
  final double distanceFromUniversity;
  final int maxRoommates;
  final List<String> tags;
  final int rooms;
  final int currentRoommates;

  Listing({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.imageUrl,
    required this.distanceFromUniversity,
    required this.maxRoommates,
    required this.tags,
    required this.rooms,
    required this.currentRoommates,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'].toString(),
      title: json['title'],
      location: json['location'],
      price: json['price'].toDouble(),
      imageUrl: json['image_url'] ?? '',
      distanceFromUniversity: json['distance_from_university'].toDouble(),
      maxRoommates: json['max_roommates'] ?? 1,
      tags: List<String>.from(json['tags'] ?? []),
      rooms: json['rooms'] ?? 1,
      currentRoommates: json['current_roommates'] ?? 0,
    );
  }
}

final List<Listing> dummyListings = [
  Listing(
    id: '1',
    title: 'Cozy 2BR Near KAU - Female Students',
    location: 'Al Andalus, Jeddah',
    price: 1800,
    imageUrl:
        'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=500',
    distanceFromUniversity: 1.5,
    maxRoommates: 2,
    tags: ['Furnished', 'Bills Included', 'Female Only'],
    rooms: 2,
    currentRoommates: 1,
  ),
  Listing(
    id: '2',
    title: 'Modern Studio Near KFUPM',
    location: 'Dhahran, Eastern Province',
    price: 2200,
    imageUrl:
        'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=500',
    distanceFromUniversity: 0.8,
    maxRoommates: 1,
    tags: ['Furnished', 'AC', 'WiFi'],
    rooms: 1,
    currentRoommates: 0,
  ),
  Listing(
    id: '3',
    title: 'Spacious 3BR Shared Apartment',
    location: 'Madinah Road, Jeddah',
    price: 1200,
    imageUrl:
        'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=500',
    distanceFromUniversity: 2.1,
    maxRoommates: 3,
    tags: ['Shared', 'Furnished', 'Mixed'],
    rooms: 3,
    currentRoommates: 2,
  ),
  Listing(
    id: '4',
    title: 'Budget Room Near UQU',
    location: 'Aziziyah, Makkah',
    price: 900,
    imageUrl: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=500',
    distanceFromUniversity: 1.2,
    maxRoommates: 4,
    tags: ['Shared', 'Bills Included'],
    rooms: 1,
    currentRoommates: 3,
  ),
];

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class HomeScreen extends StatefulWidget {
  final String userName;
  final String? userEmail;
  final String? userPhone;
  final String? userUniversity;
  final String? userStudentId;
  final String? userGender;
  final String? userDateOfBirth;
  final String? userProfilePicture;

  const HomeScreen({
    super.key,
    required this.userName,
    this.userEmail,
    this.userPhone,
    this.userUniversity,
    this.userStudentId,
    this.userGender,
    this.userDateOfBirth,
    this.userProfilePicture,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<String> _favorites = [];

  void _toggleFavorite(String id) {
    setState(() {
      if (_favorites.contains(id)) {
        _favorites.remove(id);
      } else {
        _favorites.add(id);
      }
    });
  }

  final List<String> _pageTitles = [
    'Home',
    'Search',
    'Favorites',
    'Requests',
    'Profile',
  ];

  Widget _buildCurrentTab() {
    switch (_currentIndex) {
      case 0:
        return _HomeTab(
          userName: widget.userName,
          favorites: _favorites,
          onToggleFavorite: _toggleFavorite,
        );
      case 2:
        return FavoritesScreen(
          listings: dummyListings,
          favorites: _favorites,
          onToggleFavorite: _toggleFavorite,
          onListingClick: (id) {
            final listing = dummyListings.firstWhere((l) => l.id == id);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ListingDetailScreen(listing: listing),
              ),
            );
          },
        );
      case 3:
        return RequestsScreen(userId: widget.userName);
      case 4:
        return ProfileScreen(
          user: UserProfile(
            name: widget.userName,
            email: widget.userEmail ?? '',
            phone: widget.userPhone ?? '',
            university: widget.userUniversity ?? '',
            gender: widget.userGender ?? '',
            dob: widget.userDateOfBirth ?? '',
            role: 'student',
          ),
          onLogout: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const SignInScreen()),
              (route) => false,
            );
          },
          onSwitchToOwner: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OwnerDashboardScreen(userName: widget.userName),
              ),
            );
          },
        );
      default:
        return _PlaceholderTab(title: _pageTitles[_currentIndex]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _buildCurrentTab(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(0, Icons.home_rounded, Icons.home_outlined, 'Home'),
              _navItem(
                1,
                Icons.search_rounded,
                Icons.search_outlined,
                'Search',
              ),
              _navItem(
                2,
                Icons.favorite_rounded,
                Icons.favorite_outline,
                'Favorites',
              ),
              _navItem(
                3,
                Icons.description_rounded,
                Icons.description_outlined,
                'Requests',
              ),
              _navItem(
                4,
                Icons.person_rounded,
                Icons.person_outline,
                'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    int index,
    IconData activeIcon,
    IconData inactiveIcon,
    String label,
  ) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 1.sw / 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              color: isActive ? Colors.orange : Colors.grey,
              size: 24.sp,
            ),
            SizedBox(height: 3.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: isActive ? Colors.orange : Colors.grey,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String title;
  const _PlaceholderTab({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction_rounded,
            size: 60.sp,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade400,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Coming soon...',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatefulWidget {
  final String userName;
  final List<String> favorites;
  final void Function(String id) onToggleFavorite;
  const _HomeTab({
    required this.userName,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  List<Listing> listings = dummyListings;
  bool isChatOpen = false;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  List<ChatMessage> messages = [];

  @override
  void initState() {
    super.initState();
    messages = [
      ChatMessage(
        id: '1',
        text:
            '👋 Hello ${widget.userName}! Welcome to Mawa! 🏠\n\nHow can we help you today?\n• Finding the perfect apartment\n• Listing your property\n• Rental process',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    _chatController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_chatController.text.trim().isEmpty) return;
    final userMsg = ChatMessage(
      id: DateTime.now().toString(),
      text: _chatController.text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );
    setState(() {
      messages.add(userMsg);
      _chatController.clear();
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        messages.add(
          ChatMessage(
            id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
            text:
                'Thank you for reaching out! 📩\n\nOur support team will respond shortly.',
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_chatScrollController.hasClients) {
          _chatScrollController.animateTo(
            _chatScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 18) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  List<Listing> get _recommended => listings.take(3).toList();
  List<Listing> get _nearUniversity =>
      listings.where((l) => l.distanceFromUniversity < 3).toList();
  List<Listing> get _sharedApartments =>
      listings.where((l) => l.maxRoommates > 1).toList();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildListPropertyBanner()),
            SliverToBoxAdapter(
              child: _buildSectionTitle('Recommended for You'),
            ),
            SliverToBoxAdapter(child: _buildHorizontalListings()),
            SliverToBoxAdapter(
              child: _buildSectionTitle(
                'Near Your University',
                showSeeAll: true,
                onSeeAll: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SeeAllScreen(
                        title: 'Near Your University',
                        listings: _nearUniversity,
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 6.h,
                  ),
                  child: _buildListingCard(_nearUniversity[index]),
                ),
                childCount: _nearUniversity.length,
              ),
            ),
            SliverToBoxAdapter(
              child: _buildSectionTitle(
                'Shared Apartments',
                showSeeAll: true,
                onSeeAll: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SeeAllScreen(
                        title: 'Shared Apartments',
                        listings: _sharedApartments,
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 6.h,
                  ),
                  child: _buildListingCard(_sharedApartments[index]),
                ),
                childCount: _sharedApartments.take(2).length,
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 40.h)),
          ],
        ),
        if (isChatOpen) _buildChatModal(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0B2A4A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16.h,
        bottom: 24.h,
        left: 20.w,
        right: 20.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _greeting,
                      style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      widget.userName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => isChatOpen = true),
                    child: Stack(
                      children: [
                        Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 10.w,
                            height: 10.w,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF0B2A4A),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationsScreen(),
                      ),
                    ),
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Container(
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              children: [
                SizedBox(width: 14.w),
                Icon(Icons.search, color: Colors.grey, size: 20.sp),
                SizedBox(width: 10.w),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(fontSize: 13.sp),
                    decoration: InputDecoration(
                      hintText: 'Search location, university, area...',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 13.sp),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(6.w),
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(Icons.tune, color: Colors.white, size: 18.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListPropertyBanner() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OwnerDashboardScreen(userName: widget.userName),
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Have a place to rent?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: const Color(0xFF0B2A4A),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Start earning with your property',
                      style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        'List your property',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.orange,
                      size: 16.sp,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    String title, {
    bool showSeeAll = false,
    VoidCallback? onSeeAll,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0B2A4A),
            ),
          ),
          if (showSeeAll)
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                'See All',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHorizontalListings() {
    // ✅ مفيش ارتفاع محدد — الـ SizedBox بياخد ارتفاع الكارد اللي جواه تلقائياً
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: 20.w),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _recommended
              .map(
                (listing) => Padding(
                  padding: EdgeInsets.only(right: 14.w),
                  child: SizedBox(
                    // العرض = 72% من عرض الشاشة — بيتكيف مع كل الأجهزة
                    width: 0.72.sw,
                    child: _buildListingCard(listing, isHorizontal: true),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildListingCard(Listing listing, {bool isHorizontal = false}) {
    final isFav = widget.favorites.contains(listing.id);

    // ✅ الصورة = 45% من عرض الكارد نفسه
    // - الـ horizontal كارد عرضه 72% من الشاشة  → صورته 72% * 45% ≈ 32% من الشاشة
    // - الـ vertical كارد عرضه الشاشة - 40w padding → صورته أكبر شوية
    // النسبة دي بتتكيف تلقائياً مع كل الأجهزة
    final double imageAspectRatio = 16 / 9;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ListingDetailScreen(listing: listing),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // ✅ mainAxisSize.min = الكارد بياخد بس المساحة اللي محتاجها
          mainAxisSize: MainAxisSize.min,
          children: [
            // — الصورة بـ AspectRatio بدل ارتفاع ثابت —
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
                  ),
                  // ✅ AspectRatio = الصورة دايماً 16:9 بغض النظر عن عرض الكارد
                  child: AspectRatio(
                    aspectRatio: imageAspectRatio,
                    child: listing.imageUrl.startsWith('http')
                        ? Image.network(
                            listing.imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey.shade200,
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                                size: 30.sp,
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey.shade200,
                            child: Icon(
                              Icons.home,
                              color: Colors.grey,
                              size: 40.sp,
                            ),
                          ),
                  ),
                ),
                Positioned(
                  bottom: 10.h,
                  left: 10.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      '${listing.distanceFromUniversity} km from campus',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: GestureDetector(
                    onTap: () => widget.onToggleFavorite(listing.id),
                    child: Container(
                      width: 34.w,
                      height: 34.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : Colors.grey,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // — المحتوى النصي —
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    listing.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                      color: const Color(0xFF0B2A4A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 13.sp, color: Colors.grey),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          listing.location,
                          style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${listing.price.toInt()} SAR/month',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                        ),
                      ),
                      Text(
                        '${listing.currentRoommates}/${listing.maxRoommates}',
                        style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  // ✅ Tags في row أفقي scroll بدل Wrap — مفيش كسر سطور = مفيش overflow
                  SizedBox(
                    height: 24.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listing.tags.take(3).length,
                      separatorBuilder: (_, __) => SizedBox(width: 6.w),
                      itemBuilder: (_, i) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF0B2A4A,
                          ).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          listing.tags[i],
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: const Color(0xFF0B2A4A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
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

  Widget _buildChatModal() {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => setState(() => isChatOpen = false),
          child: Container(color: Colors.black.withValues(alpha: 0.5)),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 0.85.sh,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0B2A4A),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.support_agent,
                          color: Colors.white,
                          size: 22.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Support Team',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                            Text(
                              'Usually replies in minutes',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => isChatOpen = false),
                        child: Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _chatScrollController,
                    padding: EdgeInsets.all(16.w),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      return Align(
                        alignment: msg.isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 12.h),
                          padding: EdgeInsets.all(12.w),
                          constraints: BoxConstraints(maxWidth: 0.75.sw),
                          decoration: BoxDecoration(
                            color: msg.isUser
                                ? Colors.orange
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.r),
                              topRight: Radius.circular(16.r),
                              bottomLeft: msg.isUser
                                  ? Radius.circular(16.r)
                                  : Radius.circular(4.r),
                              bottomRight: msg.isUser
                                  ? Radius.circular(4.r)
                                  : Radius.circular(16.r),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                msg.text,
                                style: TextStyle(
                                  color: msg.isUser
                                      ? Colors.white
                                      : Colors.black87,
                                  fontSize: 13.sp,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: msg.isUser
                                      ? Colors.white70
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                    16.w,
                    12.h,
                    16.w,
                    MediaQuery.of(context).viewInsets.bottom + 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _chatController,
                              onSubmitted: (_) => _sendMessage(),
                              style: TextStyle(fontSize: 13.sp),
                              decoration: InputDecoration(
                                hintText: 'Type your message...',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13.sp,
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 12.h,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.r),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          GestureDetector(
                            onTap: _sendMessage,
                            child: Container(
                              width: 44.w,
                              height: 44.w,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '💬 Our support team is available 24/7',
                        style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// LISTING DETAIL SCREEN
// ============================================================
class ListingDetailScreen extends StatelessWidget {
  final Listing listing;
  const ListingDetailScreen({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // ✅ AspectRatio للصورة في الـ Detail screen كمان
            expandedHeight: MediaQuery.of(context).size.width * (9 / 16),
            pinned: true,
            backgroundColor: const Color(0xFF0B2A4A),
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: const Color(0xFF0B2A4A),
                  size: 20.sp,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: listing.imageUrl.startsWith('http')
                  ? Image.network(
                      listing.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.home,
                          size: 60.sp,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.grey.shade200,
                      child: Icon(Icons.home, size: 60.sp, color: Colors.grey),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
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
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0B2A4A),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${listing.price.toInt()} SAR',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          Text(
                            '/month',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16.sp, color: Colors.grey),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          listing.location,
                          style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      _statChip(Icons.home, '${listing.rooms} Rooms'),
                      SizedBox(width: 10.w),
                      _statChip(
                        Icons.people,
                        '${listing.currentRoommates}/${listing.maxRoommates}',
                      ),
                      SizedBox(width: 10.w),
                      _statChip(
                        Icons.school,
                        '${listing.distanceFromUniversity} km',
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Features',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0B2A4A),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: listing.tags
                        .map(
                          (tag) => Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF0B2A4A,
                              ).withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xFF0B2A4A),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          20.w,
          12.h,
          20.w,
          MediaQuery.of(context).padding.bottom + 12.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
            elevation: 0,
          ),
          child: Text(
            'Contact Owner',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _statChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: Colors.orange),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.orange,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SEE ALL SCREEN
// ============================================================
class SeeAllScreen extends StatelessWidget {
  final String title;
  final List<Listing> listings;

  const SeeAllScreen({super.key, required this.title, required this.listings});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B2A4A),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, color: Colors.white, size: 20.sp),
          ),
        ),
        elevation: 0,
      ),
      body: listings.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.home_outlined,
                    size: 60.sp,
                    color: Colors.grey.shade300,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No listings found',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(20.w),
              itemCount: listings.length,
              itemBuilder: (context, index) {
                final listing = listings[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ListingDetailScreen(listing: listing),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // ✅ الصورة في See All = 30% من عرض الشاشة — بيتكيف تلقائياً
                            ClipRRect(
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(16.r),
                              ),
                              child: SizedBox(
                                width: 0.30.sw,
                                child: listing.imageUrl.startsWith('http')
                                    ? Image.network(
                                        listing.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: Colors.grey.shade200,
                                          child: Icon(
                                            Icons.home,
                                            color: Colors.grey,
                                            size: 30.sp,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        color: Colors.grey.shade200,
                                        child: Icon(
                                          Icons.home,
                                          color: Colors.grey,
                                          size: 30.sp,
                                        ),
                                      ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(12.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      listing.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.sp,
                                        color: const Color(0xFF0B2A4A),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4.h),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 12.sp,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 3.w),
                                        Expanded(
                                          child: Text(
                                            listing.location,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11.sp,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6.h),
                                    Text(
                                      '${listing.price.toInt()} SAR/month',
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 3.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.circular(
                                          6.r,
                                        ),
                                      ),
                                      child: Text(
                                        '${listing.distanceFromUniversity} km from campus',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
