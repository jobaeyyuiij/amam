import 'package:flutter/material.dart';
import 'main_container.dart';

class MailSuccessScreen extends StatelessWidget {
  final Map<String, dynamic>? mail;
  final String? transactionNumber;
  final String? receiptDate;
  final String? receiptTime;
  
  const MailSuccessScreen({
    super.key,
    this.mail,
    this.transactionNumber,
    this.receiptDate,
    this.receiptTime,
  });

  @override
  Widget build(BuildContext context) {
    // Get current date/time if not provided
    final now = DateTime.now();
    final displayDate = receiptDate ?? '${now.day} ${_getMonthName(now.month)} ${now.year}';
    final displayTime = receiptTime ?? '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'مساءً' : 'صباحاً'}';
    final displayNumber = transactionNumber ?? '#${mail?['id'] ?? now.millisecondsSinceEpoch.toString().substring(5)}';
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 80),
                      // Success icon with glow
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4DB6AC).withOpacity(0.3),
                              blurRadius: 60,
                              spreadRadius: 20,
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F7F4),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFB2DFDB),
                              width: 3,
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              color: Color(0xFF4DB6AC),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      // Title
                      const Text(
                        'تم تأكيد الأستلام بنجاح!',
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Description
                      Text(
                        'تم تسجيل استلام البريد في النظام الرسمي للشركة\nالعامة للنقل البري.',
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Details card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          children: [
                            _buildDetailRow('رقم المعاملة', displayNumber),
                            Divider(height: 32, color: Colors.grey[200]),
                            _buildDetailRow('تاريخ الأستلام', displayDate),
                            Divider(height: 32, color: Colors.grey[200]),
                            _buildDetailRow('وقت الأستلام', displayTime),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom button
            Container(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to main container and clear stack
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const MainContainer(),
                      ),
                      (route) => false,
                    );
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
                    'الانتقال للرئيسية',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'يناير', 'فبراير', 'مارس', 'ابريل', 'مايو', 'يونيو',
      'يوليو', 'اغسطس', 'سبتمبر', 'اكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    return months[month - 1];
  }
}
