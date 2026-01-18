import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'home_screen.dart';
import 'mail_screen.dart';
import '../services/api_service.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _currentIndex = 3; // Start with home (index 3 = الرئيسية)
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isDialogShowing = false;

  final List<Widget> _screens = [
    const Center(child: Text('الأعدادات', style: TextStyle(fontFamily: 'Cairo', fontSize: 24))),
    const Center(child: Text('التقارير', style: TextStyle(fontFamily: 'Cairo', fontSize: 24))),
    const MailScreen(),
    const _HomeContent(),
  ];

  @override
  void initState() {
    super.initState();
    // Delay initial check to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkConnectivity();
    });
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(_onConnectivityChanged);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    print('🌐 Checking connectivity...');
    final result = await Connectivity().checkConnectivity();
    print('🌐 Connectivity result: $result');
    if (result.contains(ConnectivityResult.none)) {
      print('🌐 No internet - showing dialog');
      _showNoInternetDialog();
    }
  }

  void _onConnectivityChanged(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.none)) {
      _showNoInternetDialog();
    } else if (_isDialogShowing) {
      Navigator.of(context).pop();
      _isDialogShowing = false;
    }
  }

  void _showNoInternetDialog() {
    if (_isDialogShowing) return;
    _isDialogShowing = true;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.wifi_off_rounded,
                  size: 40,
                  color: Colors.red[400],
                ),
              ),
              const SizedBox(height: 24),
              // Title
              const Text(
                'لا يوجد اتصال بالإنترنت',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              // Description
              Text(
                'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              // Retry button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await Connectivity().checkConnectivity();
                    if (!result.contains(ConnectivityResult.none)) {
                      Navigator.of(context).pop();
                      _isDialogShowing = false;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4DB6AC),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'إعادة المحاولة',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Exit button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red[400],
                    side: BorderSide(color: Colors.red[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'الخروج من التطبيق',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.red[400],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF4DB6AC),
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'الأعدادات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'التقارير',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mail_outline),
              label: 'البريد',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
          ],
        ),
      ),
    );
  }
}

// Home content extracted from HomeScreen
class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  final ApiService _apiService = ApiService();
  String _userName = 'المستخدم';
  int _totalMails = 0;
  int _readMails = 0;
  int _unreadMails = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadMailCounts();
  }

  Future<void> _loadUserName() async {
    // First try from memory
    String? name = _apiService.getUserName();
    
    // If not in memory, load from SharedPreferences
    if (name == null || name.isEmpty) {
      name = await _apiService.loadUserName();
    }
    
    if (name != null && name.isNotEmpty && mounted) {
      setState(() => _userName = name!);
    }
  }

  Future<void> _loadMailCounts() async {
    try {
      final allResponse = await _apiService.getAllDocuments();
      final readResponse = await _apiService.getReadDocuments();
      final unreadResponse = await _apiService.getUnreadDocuments();

      int allCount = 0;
      int readCount = 0;
      int unreadCount = 0;

      // Parse all documents count
      if (allResponse.success && allResponse.data != null) {
        if (allResponse.data['documents'] is Map && allResponse.data['documents']['total'] != null) {
          allCount = allResponse.data['documents']['total'];
        } else if (allResponse.data['documents'] is Map && allResponse.data['documents']['data'] is List) {
          allCount = (allResponse.data['documents']['data'] as List).length;
        }
      }

      // Parse read documents count
      if (readResponse.success && readResponse.data != null) {
        if (readResponse.data['documents'] is Map && readResponse.data['documents']['total'] != null) {
          readCount = readResponse.data['documents']['total'];
        } else if (readResponse.data['documents'] is Map && readResponse.data['documents']['data'] is List) {
          readCount = (readResponse.data['documents']['data'] as List).length;
        }
      }

      // Parse unread documents count
      if (unreadResponse.success && unreadResponse.data != null) {
        if (unreadResponse.data['documents'] is Map && unreadResponse.data['documents']['total'] != null) {
          unreadCount = unreadResponse.data['documents']['total'];
        } else if (unreadResponse.data['documents'] is Map && unreadResponse.data['documents']['data'] is List) {
          unreadCount = (unreadResponse.data['documents']['data'] as List).length;
        }
      }

      if (mounted) {
        setState(() {
          _totalMails = allCount;
          _readMails = readCount;
          _unreadMails = unreadCount;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading mail counts: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Header with logo and notification
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Notification icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      'images/notfication.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  // Logo and title
                  Row(
                    children: [
                      const Text(
                        'اعمام',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Image.asset(
                        'images/logo.png',
                        width: 40,
                        height: 40,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Welcome message
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'أهلاً وسهلاً، $_userName',
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'إليك ملخص أعمالك اليومية',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Stats cards row
              Row(
                children: [
                  // Unread card
                  Expanded(
                    child: _buildStatsCard(
                      icon: 'images/kermkroh.png',
                      iconBgColor: const Color(0xFFFFF3E0),
                      count: _isLoading ? '...' : '$_unreadMails',
                      label: 'غير مقروءة',
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Confirmed card
                  Expanded(
                    child: _buildStatsCard(
                      icon: 'images/mokeed.png',
                      iconBgColor: const Color(0xFFE8F5E9),
                      count: _isLoading ? '...' : '$_readMails',
                      label: 'المؤكد',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Total mail card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    // Text on right
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'إجمالي البريد',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          _isLoading ? '...' : '$_totalMails',
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Icon on left
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F7FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.mail_outline,
                        color: Color(0xFF4DB6AC),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Security notice card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shield icon on right
                    Image.asset(
                      'images/shiled.png',
                      width: 32,
                      height: 32,
                    ),
                    const SizedBox(width: 16),
                    // Text content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'ملاحظة أمنية',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'لأسباب امنية، يتطلب الوصول إلى البريد غير المقروء إدخال رمز تحقق خاص بكل رسالة.',
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Events calendar section
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF4DB6AC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Calendar header
                    Row(
                      textDirection: TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Icon and title on RIGHT
                        Row(
                          children: [
                            const Text(
                              'تقويم الأحداث',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Image.asset(
                              'images/cal.png',
                              width: 22,
                              height: 22,
                            ),
                          ],
                        ),
                        // Date on LEFT
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'أكتوبر 2025',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Event content
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        // Date box on right
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Column(
                            children: [
                              Text(
                                'الخميس',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '24',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Event details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'اجتماع وزراء النقل السنوي',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                textDirection: TextDirection.rtl,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.access_time, size: 15, color: Colors.white.withOpacity(0.9)),
                                  const SizedBox(width: 5),
                                  Text(
                                    '10:00 صباحاً - القاعة الكبرى',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 13,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      textDirection: TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Participants avatars on right
                        Row(
                          children: [
                            _buildAvatarWhite('م'),
                            _buildAvatarWhite('ع'),
                            _buildAvatarWhite('+3'),
                          ],
                        ),
                        // Details button - WHITE background
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF4DB6AC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            elevation: 0,
                          ),
                          child: const Text(
                            'التفاصيل',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildStatsCard({
    required String icon,
    required Color iconBgColor,
    required String count,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              icon,
              width: 24,
              height: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            count,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildAvatarWhite(String text) {
    return Container(
      width: 28,
      height: 28,
      margin: const EdgeInsets.only(left: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
