import 'package:flutter/material.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({super.key});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(text: "Finalize Q3 Report");
  final _descriptionController = TextEditingController(
    text: "Review the latest sales data and compile the final report for the quarterly review meeting. Ensure all charts are updated and key takeaways are highlighted.",
  );
  
  bool _isCompleted = false;
  bool _isHovered = false;

  // Cores customizadas do tema
  static const Color primary50 = Color(0xFFF0FDF4);
  static const Color primary100 = Color(0xFFDCFCE7);
  static const Color primary200 = Color(0xFFBBF7D0);
  static const Color primary300 = Color(0xFF86EFAC);
  static const Color primary400 = Color(0xFF4ADE80);
  static const Color primary500 = Color(0xFF22C55E);
  static const Color primary600 = Color(0xFF16A34A);
  static const Color primary700 = Color(0xFF15803D);
  static const Color primary800 = Color(0xFF166534);
  static const Color primary900 = Color(0xFF14532D);
  static const Color primary950 = Color(0xFF052E16);

  static const Color secondary50 = Color(0xFFF7F5FF);
  static const Color secondary100 = Color(0xFFEFEAFD);
  static const Color secondary200 = Color(0xFFE0D9FA);
  static const Color secondary300 = Color(0xFFCBBEF6);
  static const Color secondary400 = Color(0xFFB19CF0);
  static const Color secondary500 = Color(0xFF9879EA);
  static const Color secondary600 = Color(0xFF885CE4);
  static const Color secondary700 = Color(0xFF7641DE);
  static const Color secondary800 = Color(0xFF6431D6);
  static const Color secondary900 = Color(0xFF5527CE);
  static const Color secondary950 = Color(0xFF331599);

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task "${_titleController.text}" updated successfully!'),
          backgroundColor: primary500,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 768;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        border: const Border(
          bottom: BorderSide(color: Color(0xFFEAECEF)),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLogo(),
              if (isDesktop) _buildNavigation(),
              _buildUserSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: primary500,
          ),
          child: CustomPaint(
            painter: TaskifyLogoPainter(),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Taskify',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A202C),
            fontFamily: 'Spline Sans',
          ),
        ),
      ],
    );
  }

  Widget _buildNavigation() {
    return Row(
      children: [
        _buildNavLink('Home'),
        _buildNavLink('Tasks'),
        _buildNavLink('Projects'),
        _buildNavLink('Calendar'),
      ],
    );
  }

  Widget _buildNavLink(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {},
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4A5568),
              fontFamily: 'Spline Sans',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserSection() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.notifications_outlined,
            color: Color(0xFF4A5568),
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: NetworkImage(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDXPSLTJK4_IdDIRz0QYIS3C5B1vT9n458Bx4Oo_dExeH0U6dph-srPmYnpC5GAtr1q1IpV3HPvqv3E-6JSG6IKUJLfgFi7KX2gWVZsKYsjNeyZjGSSNyHOLLJLEDGBKsenYkkf7_HoymRAWveHtAyFUbANlGqGnViYW_BJbQHE4LbuMCAu2ZwRR0P71dEQMCRkqRaMB_qqcVyjHChla7ot5sEcXGuM9fIJaOiMxUoHMZ5dpWZRptaQHwEa9YolWYHLWTDgCbbde48',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 512),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _buildPageHeader(),
                const SizedBox(height: 32),
                _buildForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageHeader() {
    return Column(
      children: [
        const Text(
          'Edit Task',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A202C),
            fontFamily: 'Spline Sans',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Update the details of your existing task.',
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFF718096),
            fontFamily: 'Spline Sans',
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: -4,
          ),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleField(),
            const SizedBox(height: 24),
            _buildDescriptionField(),
            const SizedBox(height: 24),
            _buildCompletedToggle(),
            const SizedBox(height: 32),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Title',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF4A5568),
            fontFamily: 'Spline Sans',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF7FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: primary500, width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          style: const TextStyle(
            color: Color(0xFF1A202C),
            fontFamily: 'Spline Sans',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Title is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF4A5568),
            fontFamily: 'Spline Sans',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          maxLines: 6,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF7FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: primary500, width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          style: const TextStyle(
            color: Color(0xFF1A202C),
            fontFamily: 'Spline Sans',
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Completed',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2D3748),
              fontFamily: 'Spline Sans',
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _isCompleted = !_isCompleted;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56,
              height: 32,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _isCompleted ? primary500 : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(16),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: _isCompleted ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isHovered ? primary600 : primary500,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.1),
              minimumSize: const Size(120, 48),
            ),
            child: const Text(
              'Update Task',
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
}

// Custom painter para o logo do Taskify
class TaskifyLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Reproduzindo aproximadamente o formato do logo SVG
    path.moveTo(size.width * 0.85, size.height * 0.92);
    path.lineTo(size.width * 0.75, size.height * 0.71);
    path.quadraticBezierTo(
      size.width * 0.97, size.height * 0.5,
      size.width * 0.85, size.height * 0.27,
    );
    path.quadraticBezierTo(
      size.width * 0.97, size.height * 0.27,
      size.width * 0.85, size.height * 0.08,
    );
    path.lineTo(size.width * 0.15, size.height * 0.08);
    path.quadraticBezierTo(
      size.width * 0.03, size.height * 0.27,
      size.width * 0.15, size.height * 0.27,
    );
    path.quadraticBezierTo(
      size.width * 0.03, size.height * 0.5,
      size.width * 0.25, size.height * 0.71,
    );
    path.lineTo(size.width * 0.15, size.height * 0.92);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}