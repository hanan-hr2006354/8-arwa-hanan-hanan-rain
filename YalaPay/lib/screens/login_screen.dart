// login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quickmart/providers/user_provider.dart';
import 'package:quickmart/routes/app_router.dart';

class LoginScreen extends ConsumerWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userNotifierProvider);

    return Scaffold(
      backgroundColor: Color(0xFFFEFFF7),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 3.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.PNG'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF915050),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Log in to your account!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF915050).withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 3.4,
            left: 0,
            right: 0,
            child: ClipPath(
              child: Container(
                color: Color(0xFFFEFFF7),
                padding: EdgeInsets.all(30),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF915050),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      controller: _firstnameController,
                      icon: Icons.person,
                      hintText: 'First Name',
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      controller: _lastnameController,
                      icon: Icons.person,
                      hintText: 'Last Name',
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      controller: _usernameController,
                      icon: Icons.person,
                      hintText: 'Username',
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      controller: _passwordController,
                      icon: Icons.lock,
                      hintText: 'Password',
                      isPassword: true,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: true,
                              onChanged: (value) {},
                              fillColor:
                                  MaterialStateProperty.all(Color(0xFF915050)),
                            ),
                            Text(
                              'Remember me',
                              style: TextStyle(
                                color: Color(0xFF915050),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: Color(0xFF915050),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        final username = _usernameController.text;
                        final password = _passwordController.text;
                        final firstname = _firstnameController.text;
                        final lastname = _lastnameController.text;

                        if (ref
                            .read(userNotifierProvider.notifier)
                            .validateCredentials(
                                firstname, lastname, username, password)) {
                          context.go(AppRouter.main.path);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Invalid username or password')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[400],
                        padding:
                            EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 250, 250, 250),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: Color(0xFF915050),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              color: Color(0xFF915050),
                              fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    bool isPassword = false,
  }) {
    return Container(
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          hintStyle: TextStyle(color: Color(0xFF915050)),
          filled: true,
          fillColor: Colors.brown[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
