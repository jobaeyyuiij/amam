import 'package:flutter/material.dart';
import 'mail_detail_screen.dart';
import 'document_otp_screen.dart';
import '../services/api_service.dart';

class MailScreen extends StatefulWidget {
  const MailScreen({super.key});

  @override
  State<MailScreen> createState() => _MailScreenState();
}

class _MailScreenState extends State<MailScreen> {
  int _selectedFilter = 0; // 0: الكل, 1: مؤكد, 2: غير مقروء
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  
  List<Map<String, dynamic>> _allMails = [];
  List<Map<String, dynamic>> _readMails = [];
  List<Map<String, dynamic>> _unreadMails = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      print('📧 Loading documents...');
      
      // Load all documents
      final allResponse = await _apiService.getAllDocuments();
      print('📧 All docs response: success=${allResponse.success}, data=${allResponse.data}');
      
      final readResponse = await _apiService.getReadDocuments();
      print('📧 Read docs response: success=${readResponse.success}, data=${readResponse.data}');
      
      final unreadResponse = await _apiService.getUnreadDocuments();
      print('📧 Unread docs response: success=${unreadResponse.success}, data=${unreadResponse.data}');

      if (allResponse.success && allResponse.data != null) {
        _allMails = _parseDocuments(allResponse.data);
        print('📧 Parsed all mails: ${_allMails.length}');
      }
      if (readResponse.success && readResponse.data != null) {
        _readMails = _parseDocuments(readResponse.data);
        print('📧 Parsed read mails: ${_readMails.length}');
      }
      if (unreadResponse.success && unreadResponse.data != null) {
        _unreadMails = _parseDocuments(unreadResponse.data);
        print('📧 Parsed unread mails: ${_unreadMails.length}');
      }

      setState(() => _isLoading = false);
    } catch (e) {
      print('🚨 Error loading documents: $e');
      setState(() {
        _isLoading = false;
        _error = 'حدث خطأ في تحميل البيانات: $e';
      });
    }
  }

  List<Map<String, dynamic>> _parseDocuments(dynamic data) {
    List<Map<String, dynamic>> documents = [];
    
    // Handle different response formats
    List<dynamic>? docList;
    if (data is List) {
      docList = data;
    } else if (data is Map) {
      docList = data['documents'] ?? data['data'] ?? [];
    }
    
    if (docList != null) {
      for (var doc in docList) {
        documents.add({
          'id': doc['id'],
          'sender': doc['sender_name'] ?? doc['sender'] ?? 'مرسل غير معروف',
          'subject': doc['title'] ?? doc['subject'] ?? 'بدون عنوان',
          'preview': doc['content'] ?? doc['preview'] ?? doc['body'] ?? '',
          'time': _formatTime(doc['created_at'] ?? doc['date']),
          'isRead': doc['is_read'] == true || doc['is_read'] == 1,
          'isConfirmed': doc['is_confirmed'] == true || doc['is_confirmed'] == 1,
          'priority': doc['priority'],
          'hasIcon': doc['sender_type'] == 'organization',
          'rawData': doc,
        });
      }
    }
    
    return documents;
  }

  String _formatTime(dynamic dateStr) {
    if (dateStr == null) return '';
    try {
      DateTime date = DateTime.parse(dateStr.toString());
      int hour = date.hour;
      String period = hour >= 12 ? 'م' : 'ص';
      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;
      return '$hour:${date.minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return dateStr.toString();
    }
  }

  List<Map<String, dynamic>> get _filteredMails {
    switch (_selectedFilter) {
      case 1: // مؤكد (read/confirmed)
        return _readMails;
      case 2: // غير مقروء
        return _unreadMails;
      default: // الكل
        return _allMails;
    }
  }

  void _onMailTap(Map<String, dynamic> mail) async {
    // If unread, need OTP verification first
    if (mail['isRead'] == false) {
      // Send OTP for this document
      final response = await _apiService.sendDocumentOtp(mail['id']);
      
      if (response.success) {
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DocumentOtpScreen(
                documentId: mail['id'],
                documentData: mail,
              ),
            ),
          ).then((_) => _loadDocuments()); // Refresh after returning
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                response.message ?? 'حدث خطأ',
                textDirection: TextDirection.rtl,
                style: const TextStyle(fontFamily: 'Cairo'),
              ),
              backgroundColor: Colors.red[400],
            ),
          );
        }
      }
    } else {
      // Already read, go directly to details
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MailDetailScreen(mail: mail),
        ),
      );
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
                      _buildFilterTab('الكل', 0, _allMails.length),
                      const SizedBox(width: 8),
                      _buildFilterTab('مؤكد', 1, _readMails.length),
                      const SizedBox(width: 8),
                      _buildFilterTab('غير مقروء', 2, _unreadMails.length),
                    ],
                  ),
                ],
              ),
            ),
            // Mail list
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Color(0xFF4DB6AC)),
                    )
                  : _error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _error!,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadDocuments,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4DB6AC),
                                ),
                                child: const Text(
                                  'إعادة المحاولة',
                                  style: TextStyle(fontFamily: 'Cairo', color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        )
                      : _filteredMails.isEmpty
                          ? Center(
                              child: Text(
                                'لا توجد رسائل',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadDocuments,
                              color: const Color(0xFF4DB6AC),
                              child: ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: _filteredMails.length,
                                itemBuilder: (context, index) {
                                  return _buildMailCard(_filteredMails[index]);
                                },
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(String title, int index, int count) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withOpacity(0.2) : Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.grey[600],
                  ),
                ),
              ),
            ],
            if (index == 2 && count > 0) ...[
              const SizedBox(width: 6),
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
      onTap: () => _onMailTap(mail),
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
                          mail['sender'] ?? '',
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
                    mail['subject'] ?? '',
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
                    mail['preview'] ?? '',
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
                  mail['time'] ?? '',
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
