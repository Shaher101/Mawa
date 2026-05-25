import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ── موديل الـ Notification ──
class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime time;
  final NotificationType type;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.type,
    this.isRead = false,
  });
}

enum NotificationType { newListing, request, message, system }

// ── بيانات تجريبية (هتتبدل بـ API لما يجهز) ──
final List<AppNotification> _dummyNotifications = [
  AppNotification(
    id: '1',
    title: 'New Listing Near You',
    body: 'A new 2BR apartment was just listed in Al Andalus, Jeddah',
    time: DateTime.now().subtract(const Duration(minutes: 10)),
    type: NotificationType.newListing,
    isRead: false,
  ),
  AppNotification(
    id: '2',
    title: 'Request Update',
    body: 'Your request for the studio near KFUPM has been approved!',
    time: DateTime.now().subtract(const Duration(hours: 2)),
    type: NotificationType.request,
    isRead: false,
  ),
  AppNotification(
    id: '3',
    title: 'New Message',
    body: 'Ahmed sent you a message about the shared apartment',
    time: DateTime.now().subtract(const Duration(hours: 5)),
    type: NotificationType.message,
    isRead: true,
  ),
  AppNotification(
    id: '4',
    title: 'Welcome to MA\'WA! 🎉',
    body: 'Your account has been set up successfully. Start exploring!',
    time: DateTime.now().subtract(const Duration(days: 1)),
    type: NotificationType.system,
    isRead: true,
  ),
];

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<AppNotification> notifications = List.from(_dummyNotifications);

  void _markAllRead() {
    setState(() {
      for (final n in notifications) {
        n.isRead = true;
      }
    });
  }

  void _markOneRead(String id) {
    setState(() {
      final n = notifications.firstWhere((e) => e.id == id);
      n.isRead = true;
    });
  }

  int get _unreadCount => notifications.where((n) => !n.isRead).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B2A4A),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Notifications',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: Text(
                'Mark all read',
                style: TextStyle(color: Colors.orange, fontSize: 12.sp),
              ),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return _NotificationTile(
                  notification: notifications[index],
                  onTap: () => _markOneRead(notifications[index].id),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 60.sp,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16.h),
          Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0B2A4A),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "You're all caught up!\nWe'll notify you when something new happens.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.sp, color: Colors.grey, height: 1.5),
          ),
        ],
      ),
    );
  }
}

// ── تايل كل notification ──
class _NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const _NotificationTile({required this.notification, required this.onTap});

  IconData get _icon {
    switch (notification.type) {
      case NotificationType.newListing:
        return Icons.home_rounded;
      case NotificationType.request:
        return Icons.description_rounded;
      case NotificationType.message:
        return Icons.chat_bubble_rounded;
      case NotificationType.system:
        return Icons.info_rounded;
    }
  }

  Color get _iconColor {
    switch (notification.type) {
      case NotificationType.newListing:
        return Colors.green;
      case NotificationType.request:
        return Colors.blue;
      case NotificationType.message:
        return Colors.purple;
      case NotificationType.system:
        return Colors.orange;
    }
  }

  String _formatTime() {
    final diff = DateTime.now().difference(notification.time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : const Color(0xFFFFF8F0),
          borderRadius: BorderRadius.circular(14.r),
          border: notification.isRead
              ? null
              : Border.all(color: Colors.orange.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: _iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(_icon, color: _iconColor, size: 22.sp),
            ),
            SizedBox(width: 12.w),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: notification.isRead
                                ? FontWeight.normal
                                : FontWeight.bold,
                            color: const Color(0xFF0B2A4A),
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    notification.body,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    _formatTime(),
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey[400]),
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
