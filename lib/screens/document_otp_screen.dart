import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../services/api_service.dart';
import 'mail_detail_screen.dart';

class DocumentOtpScreen extends StatefulWidget {
  final int documentId;
  final Map<String, dynamic>? documentData;
  
  const DocumentOtpScreen({
    super.key, 
    required this.documentId,
    this.documentData,
  });

  @override
  State<DocumentOtpScreen> createState() => _DocumentOtpScreenState();
}

class _DocumentOtpScreenState extends State<DocumentOtpScreen> with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final ApiService _apiService = ApiService();
  bool _isButtonEnabled = false;
  bool _isLoading = false;
  bool _hasError = false;
  int _secondsRemaining = 120; // 2 minutes
  Timer? _timer;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize shake animation
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _shakeController.reverse();
        }
      });
    
    _startTimer();
    
    // Add listeners to all controllers
    for (int i = 0; i < 4; i++) {
      _controllers[i].addListener(_checkIfComplete);
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _checkIfComplete() {
    setState(() {
      _isButtonEnabled = _controllers.every((controller) => controller.text.isNotEmpty);
    });
  }

  Future<void> _resendOtp() async {
    setState(() {
      _secondsRemaining = 120;
      _isLoading = true;
    });
    _startTimer();
    
    final response = await _apiService.sendDocumentOtp(widget.documentId);
    
    setState(() => _isLoading = false);
    
    if (response.success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تم إعادة إرسال رمز التحقق',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: Color(0xFF4DB6AC),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.message ?? 'حدث خطأ، يرجى المحاولة مرة أخرى',
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: Colors.red[400],
          ),
        );
      }
    }
  }

  Future<void> _handleVerifyOtp() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    String otp = _controllers.map((c) => c.text).join();
    final response = await _apiService.verifyDocumentOtp(widget.documentId, otp);

    setState(() => _isLoading = false);

    if (response.success) {
      // Mark document as read locally
      final updatedData = Map<String, dynamic>.from(widget.documentData ?? {});
      updatedData['isRead'] = true;
      if (updatedData['rawData'] != null) {
        updatedData['rawData'] = Map<String, dynamic>.from(updatedData['rawData']);
        updatedData['rawData']['read'] = true;
      }
      
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MailDetailScreen(mail: updatedData),
          ),
        );
      }
    } else {
      // Show error animation
      setState(() => _hasError = true);
      _shakeController.forward(from: 0);
      
      // Clear error after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _hasError = false);
        }
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.message ?? 'رمز التحقق غير صحيح',
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: Colors.red[400],
          ),
        );
      }
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shakeController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
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
                    'تأكيد الأطلاع على البريد',
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      // Lock icon with yellow background
                      Container(
                        width: 160,
                        height: 160,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFF9C4), // Light yellow background
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                              Color(0xFFFDD835), // Golden color for icon
                              BlendMode.srcIn,
                            ),
                            child: Image.asset(
                              'images/lock.png',
                              width: 80,
                              height: 80,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Title
                      const Text(
                        'التحقق من الهوية',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Subtitle
                      Text(
                        'تم إرسال رمز تحقق خاص لفتح هذه الرسالة إلى رقم\nهاتفك المسجل',
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // OTP Input boxes with shake animation
                      AnimatedBuilder(
                        animation: _shakeAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(_shakeAnimation.value, 0),
                            child: child,
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(4, (index) => _buildOtpBox(index)),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Verify button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: (_isButtonEnabled && !_isLoading) ? _handleVerifyOtp : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isButtonEnabled ? const Color(0xFF4DB6AC) : Colors.grey[300],
                            foregroundColor: _isButtonEnabled ? Colors.white : Colors.grey[500],
                            disabledBackgroundColor: Colors.grey[300],
                            disabledForegroundColor: Colors.grey[500],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'تأكيد',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Timer text
                      Text(
                        'انتهاء صلاحية الرمز خلال: ${_formatTime(_secondsRemaining)}',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Resend link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        textDirection: TextDirection.rtl,
                        children: [
                          Text(
                            'لم يصلك رمز؟ ',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[600],
                            ),
                          ),
                          GestureDetector(
                            onTap: _secondsRemaining == 0 ? _resendOtp : null,
                            child: Text(
                              'إعادة إرسال',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _secondsRemaining == 0 ? const Color(0xFF2196F3) : Colors.grey[400],
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return Container(
      width: 70,
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: _hasError ? Colors.red[50] : Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _hasError ? Colors.red : Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _hasError ? Colors.red : Colors.grey[300]!, width: _hasError ? 2 : 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _hasError ? Colors.red : const Color(0xFFFDD835), width: 2),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            // Move to next field
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            // Move to previous field when backspace
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}
