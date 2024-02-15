import 'package:away_review/core/auth/auth_service.dart';
import 'package:away_review/core/extensions/build_context_extension.dart';
import 'package:away_review/core/extensions/exception_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  var showPassword = false;
  var signingUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildHeaderText(),
                const SizedBox(height: 30),
                _buildEmailTextField(),
                const SizedBox(height: 20),
                _buildPasswordField(),
                const SizedBox(height: 20),
                _buildConfirmPasswordField(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildSignUpButton(),
      ),
    );
  }

  Widget _buildHeaderText() {
    return Text(
      'Fill up mo sa baba para ma-set up account mo.',
      style: context.textTheme.titleLarge?.copyWith(height: 1.5),
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Email'),
      controller: _emailController,
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
      controller: _passwordController,
      obscureText: !showPassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }

        if (value.length < 8) {
          return 'Password must be at least 8 characters long';
        }

        if (!value.contains(RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$'))) {
          return 'Password must contain at least one uppercase letter, one lowercase letter, one number';
        }

        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Confirm password',
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
      controller: _confirmPasswordController,
      obscureText: !showPassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }

        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }

        return null;
      },
    );
  }

  Widget _buildSignUpButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: signingUp
              ? null
              : () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      signingUp = true;
                    });

                    try {
                      await ref
                          .read(authServiceProvider)
                          .signUpWithEmailAndPassword(
                            _emailController.text,
                            _passwordController.text,
                          );

                      ref.invalidate(signedInProvider);
                    } on Exception catch (e) {
                      if (mounted) {
                        context.showDefaultSnackBar(e.errorMessage);
                      }
                    }

                    setState(() {
                      signingUp = false;
                    });
                  }
                },
          child: const Text('Sign up'),
        ),
      ),
    );
  }
}
