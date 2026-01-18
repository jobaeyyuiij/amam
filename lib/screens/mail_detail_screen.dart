import 'package:flutter/material.dart';
import 'mail_confirm_screen.dart';

class MailDetailScreen extends StatelessWidget {
  final Map<String, dynamic>? mail;

  const MailDetailScreen({super.key, this.mail});

  @override
  Widget build(BuildContext context) {
    // Extract data from mail object
    final sender = mail?['sender'] ?? mail?['rawData']?['issuer'] ?? 'مرسل غير معروف';
    final subject = mail?['subject'] ?? mail?['rawData']?['subject'] ?? 'بدون عنوان';
    final content = mail?['preview'] ?? mail?['rawData']?['content'] ?? 'لا يوجد محتوى';
    final time = mail?['time'] ?? mail?['rawData']?['document_time'] ?? '';
    final date = mail?['rawData']?['document_date'] ?? '';
    final documentId = mail?['id'] ?? mail?['rawData']?['id'];
    final isConfirmed = mail?['isConfirmed'] == true || mail?['rawData']?['confirmed'] == true;

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
                textDirection: TextDirection.rtl,
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
                              color: const Color(0xFFE0F7FA),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.business,
                              color: Color(0xFF4DB6AC),
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Sender info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  sender,
                                  textDirection: TextDirection.rtl,
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  subject,
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
                                      '$time - $date',
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
                            content,
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
                    // Attachments section (if any)
                    _buildAttachmentsSection(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            // Bottom button - only show if not confirmed
            if (!isConfirmed && documentId != null)
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
                      // Navigate to confirm screen
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MailConfirmScreen(
                            mail: mail,
                            documentId: documentId,
                          ),
                        ),
                      ).then((confirmed) {
                        if (confirmed == true) {
                          Navigator.of(context).pop(true);
                        }
                      });
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

  Widget _buildAttachmentsSection() {
    // Check if there are attachments in the mail data
    final attachments = mail?['rawData']?['attachments'] ?? [];
    
    if (attachments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
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
                child: Text(
                  '${attachments.length}',
                  style: const TextStyle(
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
          // Attachment items
          ...List.generate(attachments.length, (index) {
            final attachment = attachments[index];
            final fileName = attachment['name'] ?? 'ملف';
            final fileSize = attachment['size'] ?? '';
            final isPdf = fileName.toLowerCase().endsWith('.pdf');
            
            return Column(
              children: [
                if (index > 0) const Divider(height: 24),
                _buildAttachmentItem(
                  fileName: fileName,
                  fileSize: fileSize,
                  iconColor: isPdf ? const Color(0xFFE53935) : const Color(0xFF4CAF50),
                  iconBgColor: isPdf ? const Color(0xFFFFEBEE) : const Color(0xFFE8F5E9),
                  isPdf: isPdf,
                ),
              ],
            );
          }),
        ],
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
