import 'package:flutter/material.dart';
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

  final List<Widget> _screens = [
    const Center(child: Text('الأعدادات', style: TextStyle(fontFamily: 'Cairo', fontSize: 24))),
    const Center(child: Text('التقارير', style: TextStyle(fontFamily: 'Cairo', fontSize: 24))),
    const MailScreen(),
    const _HomeContent(),
  ];

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

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  void _loadUserName() {
    final name = _apiService.getUserName();
    if (name != null && name.isNotEmpty) {
      setState(() => _userName = name);
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
                      count: '10',
                      label: 'غير مقروءة',
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Confirmed card
                  Expanded(
                    child: _buildStatsCard(
                      icon: 'images/mokeed.png',
                      iconBgColor: const Color(0xFFE8F5E9),
                      count: '490',
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
                        const Text(
                          '500',
                          style: TextStyle(
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
