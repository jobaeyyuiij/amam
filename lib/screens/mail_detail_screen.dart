import 'package:flutter/material.dart';

class MailDetailScreen extends StatelessWidget {
  final Map<String, dynamic>? mail;

  const MailDetailScreen({super.key, this.mail});

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
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.chevron_right, size: 28, color: Colors.grey),
                  ),
                  const Text(
                    'تفاصيل الرسالة',
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
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Sender card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          // Avatar
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Icon(Icons.person, color: Colors.grey[400], size: 30),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Sender info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'قسم الموارد البشرية',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'تعميم إداري بخصوص العطلات الرسمية',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  textDirection: TextDirection.rtl,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                                    const SizedBox(width: 4),
                                    Text(
                                      '10:00 صباحاً - القاعة الكبرى',
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 12,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Message content card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'نص الرسالة',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'السادة الزملاء، تحية طيبة وبعد،\n\n'
                            'يرجى العلم بأنه تقرر تعطيل الدوام الرسمي ليوم غد بمناسبة الأعياد الوطنية، وذلك استناداً إلى توجيهات الأمانة العامة لمجلس الوزراء.\n\n'
                            'نرجو من كافة رؤساء الأقسام التنسيق لضمان سير العمل في الوحدات التي تتطلب تواجداً مستمراً، وتعميم هذا الكتاب على كافة الموظفين. سيتم استئناف الدوام الرسمي كالمعتاد بعد العطلة مباشرة.\n\n'
                            'شاكرين تعاونكم والتزامكم.',
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[700],
                              height: 1.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Attachments section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          // Header
                          Row(
                            textDirection: TextDirection.rtl,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  '2',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'المرفقات',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.attach_file, color: Colors.grey[600], size: 20),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // PDF attachment
                          _buildAttachmentItem(
                            fileName: 'قرار_مجلس_الوزراء.pdf',
                            fileSize: 'MB 1.2',
                            iconColor: const Color(0xFFE53935),
                            iconBgColor: const Color(0xFFFFEBEE),
                            isPdf: true,
                          ),
                          const Divider(height: 24),
                          // Image attachment
                          _buildAttachmentItem(
                            fileName: 'جدول_المناوبات.jpg',
                            fileSize: 'KB 850',
                            iconColor: const Color(0xFF4CAF50),
                            iconBgColor: const Color(0xFFE8F5E9),
                            isPdf: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            // Bottom button
            Container(
              padding: const EdgeInsets.all(16),
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
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle confirm receipt
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'تم تأكيد الاستلام بنجاح',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(fontFamily: 'Cairo'),
                        ),
                        backgroundColor: Color(0xFF4DB6AC),
                      ),
                    );
                    Navigator.of(context).pop();
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
                    'تأكيد الأستلام',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
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

  Widget _buildAttachmentItem({
    required String fileName,
    required String fileSize,
    required Color iconColor,
    required Color iconBgColor,
    required bool isPdf,
  }) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        // File icon
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            isPdf ? Icons.picture_as_pdf : Icons.image,
            color: iconColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        // File info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                fileName,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                fileSize,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
        // Download button
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.download, color: Colors.grey[400]),
        ),
      ],
    );
  }
}
