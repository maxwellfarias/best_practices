import 'package:flutter/material.dart';

class TodoEmptyStateScreen extends StatefulWidget {
  const TodoEmptyStateScreen({super.key});

  @override
  State<TodoEmptyStateScreen> createState() => _TodoEmptyStateScreenState();
}

class _TodoEmptyStateScreenState extends State<TodoEmptyStateScreen> {
  bool _isButtonHovered = false;

  // Cores pastéis customizadas
  static const Color pastelPink = Color(0xFFFADADD);
  static const Color pastelBlue = Color(0xFFD6E4FF);
  static const Color pastelGreen = Color(0xFFD9F9E6);
  static const Color pastelYellow = Color(0xFFFEF8DD);
  static const Color textColor = Color(0xFF333333);
  static const Color backgroundColor = Color(0xFFFDFBFF);

  void _onAddFirstTodo() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Add todo functionality would be implemented here!'),
        backgroundColor: pastelPink.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildMainContent(),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: pastelBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'My Todos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937), // text-gray-800
                  fontFamily: 'Spline Sans',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTabletOrDesktop = screenWidth >= 768;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIllustration(isTabletOrDesktop),
              const SizedBox(height: 32),
              _buildTitle(),
              const SizedBox(height: 8),
              _buildDescription(),
              const SizedBox(height: 24),
              _buildAddButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration(bool isTabletOrDesktop) {
    final imageSize = isTabletOrDesktop ? 320.0 : 240.0;

    return Container(
      constraints: BoxConstraints(
        maxWidth: imageSize,
        maxHeight: imageSize,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDN2CWu2SuHG8XN2bqCfNPvmxKCn7H1Rb2ns78fcgLwk5x61nLogUvfr3oizZER_sQUMGOltwz-mSmi5N11QX1ozBWFHokzkrvxi7RZJFaXLB2jxue_xk-EvYf4YpI3dhCGeS6hpaB9eD7b62sg-qXe4V8ASKotZbw5PlrPsH5xNfDtX_nof5fSePKrogbcW70bKp3IM_JF4R79eQeYIRwniuExnSIgWJ9RsZ54-qqSYQohsumbO7tslYYXVNIh0gZKU9AWpzJeTgw',
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: imageSize,
              height: imageSize,
              decoration: BoxDecoration(
                color: pastelGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(pastelBlue),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: imageSize,
              height: imageSize,
              decoration: BoxDecoration(
                color: pastelGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.eco_outlined,
                    size: 64,
                    color: Color(0xFF10B981),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Growth Illustration',
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontFamily: 'Spline Sans',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Start your journey',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1F2937), // text-gray-800
        fontFamily: 'Spline Sans',
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 448), // max-w-md
      child: const Text(
        'Every great accomplishment starts with a single step. Add your first todo and get things done!',
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFF6B7280), // text-gray-500
          fontFamily: 'Spline Sans',
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAddButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isButtonHovered = true),
      onExit: (_) => setState(() => _isButtonHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()
          ..scale(_isButtonHovered ? 1.02 : 1.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isButtonHovered ? 0.15 : 0.1),
                blurRadius: _isButtonHovered ? 12 : 8,
                offset: const Offset(0, 4),
                spreadRadius: _isButtonHovered ? 2 : 0,
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: _onAddFirstTodo,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isButtonHovered 
                  ? pastelPink.withOpacity(0.9)
                  : pastelPink,
              foregroundColor: textColor,
              elevation: 0,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text(
              '+ Add First Todo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Spline Sans',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: const Text(
        '© 2024 TodoApp. All rights reserved.',
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFF9CA3AF), // text-gray-400
          fontFamily: 'Spline Sans',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}