import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home_screen.dart'; // عشان نستخدم موديل Listing

class FavoritesScreen extends StatefulWidget {
  final List<Listing> listings;
  final List<String> favorites;
  final void Function(String id) onToggleFavorite;
  final void Function(String id) onListingClick;

  const FavoritesScreen({
    super.key,
    required this.listings,
    required this.favorites,
    required this.onToggleFavorite,
    required this.onListingClick,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final favoriteListings = widget.listings
        .where((l) => widget.favorites.contains(l.id))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saved Properties',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0B2A4A),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${favoriteListings.length} ${favoriteListings.length == 1 ? 'property' : 'properties'}',
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // ── Content ──
            Expanded(
              child: favoriteListings.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      itemCount: favoriteListings.length,
                      itemBuilder: (context, index) {
                        return _FavoriteListingCard(
                          listing: favoriteListings[index],
                          onToggleFavorite: widget.onToggleFavorite,
                          onClick: widget.onListingClick,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 40.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'No Favorites Yet',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0B2A4A),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Start exploring and save properties you like to see them here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── كارد الـ Listing في صفحة Favorites ──
class _FavoriteListingCard extends StatelessWidget {
  final Listing listing;
  final void Function(String id) onToggleFavorite;
  final void Function(String id) onClick;

  const _FavoriteListingCard({
    required this.listing,
    required this.onToggleFavorite,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick(listing.id),
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── صورة العقار ──
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      listing.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFE0E0E0),
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 40.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                // زرار القلب
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: GestureDetector(
                    onTap: () => onToggleFavorite(listing.id),
                    child: Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_rounded,
                        color: Colors.red,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
                // Price badge
                Positioned(
                  bottom: 10.h,
                  left: 10.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      'SAR ${listing.price.toStringAsFixed(0)}/mo',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── تفاصيل العقار ──
            Padding(
              padding: EdgeInsets.all(14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0B2A4A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14.sp,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          listing.location,
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  // Tags
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 6.h,
                    children: listing.tags
                        .take(3)
                        .map(
                          (tag) => Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3E0),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
