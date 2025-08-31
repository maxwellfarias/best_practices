import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isSignUpButtonHovered = false;

  // Cores customizadas do tema
  static const Color primaryColor = Color(0xFFBAE3F7);
  static const Color secondaryColor = Color(0xFFF7FAFD);
  static const Color textPrimary = Color(0xFF1D2B3A);
  static const Color textSecondary = Color(0xFF6C7E8E);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulação de registro
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome to TaskFlow, ${_nameController.text}!'),
            backgroundColor: primaryColor.withOpacity(0.9),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
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

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLogo(),
            if (isDesktop) _buildNavigation(),
            _buildAuthButtons(),
          ],
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
          child: CustomPaint(
            painter: TaskFlowLogoPainter(),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'TaskFlow',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textPrimary,
            fontFamily: 'Spline Sans',
          ),
        ),
      ],
    );
  }

  Widget _buildNavigation() {
    return Row(
      children: [
        _buildNavLink('Features'),
        _buildNavLink('Pricing'),
        _buildNavLink('Templates'),
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
              color: Color(0xFF4B5563), // text-gray-600
              fontFamily: 'Spline Sans',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthButtons() {
    return Row(
      children: [
        _buildLoginButton(),
        const SizedBox(width: 16),
        _buildSignUpHeaderButton(),
      ],
    );
  }

  Widget _buildLoginButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Navigate to login screen'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.transparent,
          ),
          child: const Text(
            'Log in',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4B5563), // text-gray-600
              fontFamily: 'Spline Sans',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpHeaderButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: primaryColor,
          ),
          child: const Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontFamily: 'Spline Sans',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 448), // max-w-md
          child: _buildSignUpCard(),
        ),
      ),
    );
  }

  Widget _buildSignUpCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 25,
            offset: const Offset(0, 10),
            spreadRadius: -5,
          ),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildCardHeader(),
          const SizedBox(height: 32),
          _buildForm(),
          const SizedBox(height: 24),
          _buildTermsText(),
        ],
      ),
    );
  }

  Widget _buildCardHeader() {
    return Column(
      children: [
        const Text(
          'Create your account',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: textPrimary,
            fontFamily: 'Spline Sans',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Start organizing your tasks and boost your productivity.',
          style: TextStyle(
            fontSize: 14,
            color: textSecondary,
            fontFamily: 'Spline Sans',
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildNameField(),
          const SizedBox(height: 24),
          _buildEmailField(),
          const SizedBox(height: 24),
          _buildPasswordField(),
          const SizedBox(height: 24),
          _buildCreateAccountButton(),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        hintText: 'Full name',
        hintStyle: const TextStyle(
          color: Color(0xFF9CA3AF), // placeholder-gray-400
          fontFamily: 'Spline Sans',
        ),
        filled: true,
        fillColor: const Color(0xFFF9FAFB), // bg-gray-50
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)), // border-gray-200
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      style: const TextStyle(
        color: textPrimary,
        fontSize: 16,
        fontFamily: 'Spline Sans',
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Full name is required';
        }
        if (value.trim().length < 2) {
          return 'Name must be at least 2 characters';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Email address',
        hintStyle: const TextStyle(
          color: Color(0xFF9CA3AF), // placeholder-gray-400
          fontFamily: 'Spline Sans',
        ),
        filled: true,
        fillColor: const Color(0xFFF9FAFB), // bg-gray-50
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)), // border-gray-200
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      style: const TextStyle(
        color: textPrimary,
        fontSize: 16,
        fontFamily: 'Spline Sans',
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Email address is required';
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: const TextStyle(
          color: Color(0xFF9CA3AF), // placeholder-gray-400
          fontFamily: 'Spline Sans',
        ),
        filled: true,
        fillColor: const Color(0xFFF9FAFB), // bg-gray-50
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)), // border-gray-200
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFF6B7280),
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      style: const TextStyle(
        color: textPrimary,
        fontSize: 16,
        fontFamily: 'Spline Sans',
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Password is required';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters';
        }
        return null;
      },
    );
  }

  Widget _buildCreateAccountButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isSignUpButtonHovered = true),
      onExit: (_) => setState(() => _isSignUpButtonHovered = false),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleSignUp,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isSignUpButtonHovered 
                ? primaryColor.withOpacity(0.9) 
                : primaryColor,
            foregroundColor: textPrimary,
            disabledBackgroundColor: primaryColor.withOpacity(0.6),
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(textPrimary),
                  ),
                )
              : const Text(
                  'Create account',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Spline Sans',
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildTermsText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 12,
          color: textSecondary,
          fontFamily: 'Spline Sans',
        ),
        children: [
          const TextSpan(text: 'By creating an account, you agree to our '),
          TextSpan(
            text: 'Terms of Service',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: primaryColor,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Terms of Service clicked'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: primaryColor,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Privacy Policy clicked'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }
}

// Custom painter para o logo do TaskFlow
class TaskFlowLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFBAE3F7) // primary-color
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Reproduzindo o formato hexagonal do logo SVG
    final width = size.width;
    final height = size.height;
    
    path.moveTo(width * 0.125, height * 0.125); // 6,6
    path.lineTo(width * 0.875, height * 0.125); // 42,6
    path.lineTo(width * 0.75, height * 0.5); // 36,24
    path.lineTo(width * 0.875, height * 0.875); // 42,42
    path.lineTo(width * 0.125, height * 0.875); // 6,42
    path.lineTo(width * 0.25, height * 0.5); // 12,24
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}