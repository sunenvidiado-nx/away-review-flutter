import 'package:away_review/core/auth/auth_service.dart';
import 'package:away_review/core/extensions/build_context_extension.dart';
import 'package:away_review/core/extensions/exception_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var showPassword = false;
  var signingIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderImage(MediaQuery.of(context).size.width),
                _buildHeaderText(),
                const SizedBox(height: 30),
                _buildEmailField(),
                const SizedBox(height: 20),
                _buildPasswordField(),
                const SizedBox(height: 35),
                _buildForgotPasswordSection(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSignInButton(),
                const SizedBox(height: 30),
                _buildSignUpSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderImage(double screenWidth) {
    return Stack(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: -0.2, end: 0.0),
          curve: Curves.easeInOutQuart,
          duration: const Duration(seconds: 2),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(value * screenWidth, 0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Image.asset('assets/icon/app-icon.png', height: 100),
                ),
              ),
            );
          },
        ),
        Positioned.fill(
          right: screenWidth * 0.52,
          child: Container(
            height: 120,
            width: screenWidth * 0.52,
            color: context.colorScheme.background,
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderText() {
    return RichText(
      text: TextSpan(
        text: 'Welcome sa ',
        style: context.textTheme.headlineSmall?.copyWith(
          color: context.colorScheme.primary,
        ),
        children: [
          TextSpan(
            text: 'Away Review.',
            style: context.textTheme.headlineSmall?.copyWith(
              color: context.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(labelText: 'Email'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }

        if (!value.contains(RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'))) {
          return 'Please enter a valid email';
        }

        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              showPassword = !showPassword;
            });
          },
          icon: Icon(
            !showPassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
        ),
      ),
      obscureText: !showPassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }

        if (value.length < 8) {
          return 'Password must be at least 8 characters long';
        }

        return null;
      },
    );
  }

  Widget _buildForgotPasswordSection() {
    return RichText(
      text: TextSpan(
        text: 'Forgot your password? ',
        style: context.textTheme.titleMedium,
        children: [
          TextSpan(
            text: 'Reset mo dito.',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // context.push('/reset-password')
                context.showDefaultSnackBar(
                  'Wala pang reset password feature. Sorry!',
                );
              },
          ),
        ],
      ),
    );
  }

  Widget _buildSignInButton() {
    return ElevatedButton(
      onPressed: signingIn
          ? null
          : () async {
              setState(() {
                signingIn = true;
              });

              try {
                if (_formKey.currentState!.validate()) {
                  await ref
                      .read(authServiceProvider)
                      .signInWithEmailAndPassword(
                        _emailController.text,
                        _passwordController.text,
                      );
                }
              } on Exception catch (e) {
                if (mounted) {
                  context.showDefaultSnackBar(e.errorMessage);
                }
              }

              setState(() {
                signingIn = false;
              });
            },
      child: const Text('Sign in'),
    );
  }

  Widget _buildSignUpSection() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Walang account? ',
          style: context.textTheme.titleMedium,
          children: [
            TextSpan(
              text: 'Register ka dito.',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => context.push('/register'),
            ),
          ],
        ),
      ),
    );
  }
}
