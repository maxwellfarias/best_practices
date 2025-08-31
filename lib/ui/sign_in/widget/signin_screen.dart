import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _rememberMe = false;
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isLoginButtonHovered = false;

  // Cores customizadas do tema
  static const Color primary50 = Color(0xFFF7F2FE);
  static const Color primary100 = Color(0xFFEADDFB);
  static const Color primary200 = Color(0xFFD8BAF7);
  static const Color primary300 = Color(0xFFC295F2);
  static const Color primary400 = Color(0xFFAC71ED);
  static const Color primary500 = Color(0xFF974CE8);
  static const Color primary600 = Color(0xFF8234DE);
  static const Color primary700 = Color(0xFF7127C6);
  static const Color primary800 = Color(0xFF5F21A4);
  static const Color primary900 = Color(0xFF4E1C85);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulação de autenticação
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome back, ${_emailController.text}!'),
            backgroundColor: primary500,
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
      backgroundColor: primary50,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 448), // max-w-md
              child: _buildLoginCard(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE5E7EB).withOpacity(0.5), // shadow-gray-200/50
            blurRadius: 25,
            offset: const Offset(0, 10),
            spreadRadius: -5,
          ),
        ],
      ),
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          _buildForm(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        _buildLogo(),
        const SizedBox(height: 24),
        _buildTitle(),
        const SizedBox(height: 8),
        _buildSubtitle(),
      ],
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 40,
      height: 40,
      child: CustomPaint(
        painter: TaskMasterLogoPainter(),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Sign in to TaskMaster',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Color(0xFF111827), // text-gray-900
        fontFamily: 'Spline Sans',
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF4B5563), // text-gray-600
          fontFamily: 'Spline Sans',
        ),
        children: [
          const TextSpan(text: 'Or '),
          WidgetSpan(
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Create account functionality would be implemented here'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text(
                'create an account',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: primary600,
                  fontFamily: 'Spline Sans',
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildEmailField(),
          const SizedBox(height: 16),
          _buildPasswordField(),
          const SizedBox(height: 24),
          _buildRememberAndForgot(),
          const SizedBox(height: 24),
          _buildLoginButton(),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Username or Email',
        hintStyle: const TextStyle(
          color: Color(0xFF6B7280), // placeholder-gray-500
          fontFamily: 'Spline Sans',
        ),
        filled: true,
        fillColor: const Color(0xFFF9FAFB), // bg-gray-50
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)), // border-gray-300
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primary500, width: 2),
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
        color: Color(0xFF111827), // text-gray-900
        fontSize: 14,
        fontFamily: 'Spline Sans',
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Username or Email is required';
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
          color: Color(0xFF6B7280), // placeholder-gray-500
          fontFamily: 'Spline Sans',
        ),
        filled: true,
        fillColor: const Color(0xFFF9FAFB), // bg-gray-50
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)), // border-gray-300
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primary500, width: 2),
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
        color: Color(0xFF111827), // text-gray-900
        fontSize: 14,
        fontFamily: 'Spline Sans',
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Password is required';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildRememberAndForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value ?? false;
                });
              },
              activeColor: primary600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const Text(
              'Remember me',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF111827), // text-gray-900
                fontFamily: 'Spline Sans',
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Forgot password functionality would be implemented here'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: const Text(
            'Forgot your password?',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: primary600,
              fontFamily: 'Spline Sans',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isLoginButtonHovered = true),
      onExit: (_) => setState(() => _isLoginButtonHovered = false),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isLoginButtonHovered ? primary600 : primary500,
            foregroundColor: Colors.white,
            disabledBackgroundColor: primary500.withOpacity(0.6),
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 20,
                      color: _isLoginButtonHovered ? primary100 : primary300,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Spline Sans',
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// Custom painter para o logo do TaskMaster
class TaskMasterLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF974CE8) // primary-500
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