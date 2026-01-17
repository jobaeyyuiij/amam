import 'package:flutter/material.dart';
import 'mail_detail_screen.dart';

class MailScreen extends StatefulWidget {
  const MailScreen({super.key});

  @override
  State<MailScreen> createState() => _MailScreenState();
}

class _MailScreenState extends State<MailScreen> {
  int _selectedFilter = 0; // 0: الكل, 1: مؤكد, 2: غير مقروء
  final TextEditingController _searchController = TextEditingController();

  // Sample mail data
  final List<Map<String, dynamic>> _allMails = [
    {
      'sender': 'وزارة النقل',
      'subject': 'تحديثات إدارية عاجلة',
      'preview': 'يرجى الإطلاع على المرفق الخاص بالتعليمات الجديدة الصادرة بخصوص العطل الرسمية ...',
      'time': '10:30 ص',
      'isRead': false,
      'isConfirmed': false,
      'priority': 'ع.م',
      'hasIcon': true,
    },
    {
      'sender': 'الموارد البشرية',
      'subject': 'اجتماع الموظفين الشهري',
      'preview': 'سيتم عقد الاجتماع الشهري في القاعة الرئيسية لمناقشة خطة العمل القادمة ...',
      'time': '09:10 ص',
      'isRead': false,
      'isConfirmed': false,
      'priority': null,
      'hasIcon': false,
      'avatar': 'assets/avatar1.png',
    },
    {
      'sender': 'مكتب المدير العام',
      'subject': 'جدول اعمال الأسبوع',
      'preview': 'مرفق جدول الأعمال المقترح للأسبوع الحالي، يرجى ابداء الملاحظات ...',
      'time': '08:10 ص',
      'isRead': true,
      'isConfirmed': true,
      'priority': 'ع.م',
      'hasIcon': false,
    },
    {
      'sender': 'مكتب المدير العام',
      'subject': 'جدول اعمال الأسبوع',
      'preview': 'مرفق جدول الأعمال المقترح للأسبوع الحالي، يرجى ابداء الملاحظات ...',
      'time': '08:10 ص',
      'isRead': true,
      'isConfirmed': true,
      'priority': 'ع.م',
      'hasIcon': false,
    },
    {
      'sender': 'مكتب المدير العام',
      'subject': 'جدول اعمال الأسبوع',
      'preview': 'مرفق جدول الأعمال المقترح للأسبوع الحالي، يرجى ابداء الملاحظات ...',
      'time': '08:10 ص',
      'isRead': true,
      'isConfirmed': true,
      'priority': 'ع.م',
      'hasIcon': false,
    },
  ];

  List<Map<String, dynamic>> get _filteredMails {
    switch (_selectedFilter) {
      case 1: // مؤكد
        return _allMails.where((mail) => mail['isConfirmed'] == true).toList();
      case 2: // غير مقروء
        return _allMails.where((mail) => mail['isRead'] == false).toList();
      default: // الكل
        return _allMails;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.chevron_right, size: 28, color: Colors.grey),
                  const Text(
                    'إجمالي البريد',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 28),
                ],
              ),
            ),
            // Search bar and filter
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  // Search bar
                  Row(
                    children: [
                      // Filter button
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.tune, color: Colors.grey[600], size: 22),
                      ),
                      const SizedBox(width: 12),
                      // Search field
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: _searchController,
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              hintText: 'البحث عن بريد ...',
                              hintStyle: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14,
                                color: Colors.grey[400],
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              suffixIcon: Icon(Icons.search, color: Colors.grey[400]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Filter tabs
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      _buildFilterTab('الكل', 0),
                      const SizedBox(width: 8),
                      _buildFilterTab('مؤكد', 1),
                      const SizedBox(width: 8),
                      _buildFilterTab('غير مقروء', 2),
                    ],
                  ),
                ],
              ),
            ),
            // Mail list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _filteredMails.length,
                itemBuilder: (context, index) {
                  return _buildMailCard(_filteredMails[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(String title, int index) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4DB6AC) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? const Color(0xFF4DB6AC) : Colors.grey[300]!,
          ),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
            ),
            if (index == 2) ...[
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : const Color(0xFF4DB6AC),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMailCard(Map<String, dynamic> mail) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MailDetailScreen(mail: mail),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar or Icon
          if (mail['hasIcon'] == true)
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFE0F7FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.business,
                color: Color(0xFF4DB6AC),
                size: 24,
              ),
            )
          else
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(22),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Icon(Icons.person, color: Colors.grey[400], size: 28),
              ),
            ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Sender and priority
                Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        mail['sender'],
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    if (mail['priority'] != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          mail['priority'],
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                // Subject
                Text(
                  mail['subject'],
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                // Preview
                Text(
                  mail['preview'],
                  textDirection: TextDirection.rtl,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Time and status
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mail['time'],
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 30),
              // Status indicator
              if (mail['isConfirmed'] == true)
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF4CAF50), width: 1.5),
                  ),
                  child: const Icon(Icons.check, color: Color(0xFF4CAF50), size: 16),
                )
              else if (mail['isRead'] == false)
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(left: 7),
                  decoration: const BoxDecoration(
                    color: Color(0xFF4DB6AC),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}
