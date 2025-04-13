import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cooking_assist/auth/auth.dart';
import 'package:cooking_assist/presentation/screens/homescreens/home_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  "Sign Up",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _inputField("Full Name", _nameController, Icons.person),
                const SizedBox(height: 16),
                _inputField("Email", _emailController, Icons.email),
                const SizedBox(height: 16),
                _inputField("Password", _passwordController, Icons.lock,
                    obscure: true, minLen: 6),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration:
                      _inputDecoration("Confirm Password", Icons.lock_outline),
                  validator: (value) => value != _passwordController.text
                      ? "Passwords do not match"
                      : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await Auth().createUserWithEmailAndPassword(
                          _emailController.text,
                          _passwordController.text,
                        );
                        await Auth().updateDisplayName(_nameController.text);
                        Get.offAll(() => const HomeScreen());
                      } catch (e) {
                        Get.snackbar("Error", e.toString());
                      }
                    }
                  },
                  child: const Text("Sign Up"),
                ),
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      prefixIcon: Icon(icon),
    );
  }

  Widget _inputField(
      String label, TextEditingController controller, IconData icon,
      {bool obscure = false, int minLen = 0}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: _inputDecoration(label, icon),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your ${label.toLowerCase()}";
        }
        if (minLen > 0 && value.length < minLen) {
          return "Min $minLen characters";
        }
        return null;
      },
    );
  }
}
