import 'package:e_shop_desktop/components/custom_text_field.dart';
import 'package:e_shop_desktop/components/show_snackbar.dart';
import 'package:e_shop_desktop/features/admin_panel/admin_screen.dart';
import 'package:e_shop_desktop/features/user_panel/user_screen.dart';
import 'package:e_shop_desktop/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';

enum AuthMode { login, signup }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth-screen';
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            height: double.infinity,
            width: 400,
            color: MyColors.primaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  MyIcons.user,
                  color: Colors.white,
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: 30),
                Text(
                  'Welcome to E-Shop',
                  style: MyFonts.getFont(
                    color: MyColors.secondaryColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _UserLoginScreen(),
          ),
        ],
      ),
    );
  }
}

class _UserLoginScreen extends StatefulWidget {
  @override
  State<_UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<_UserLoginScreen> {
  AuthMode _authMode = AuthMode.login;
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  final _authData = {
    'username': '',
    'email': '',
    'password': '',
  };

  void _onSubmitted() async {
    bool isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    final navigatorContext = Navigator.of(context);

    _formKey.currentState!.save();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (_authMode == AuthMode.signup) {
      final isAccountCreated = await auth.createAccount(
        username: _authData['username']!,
        email: _authData['email']!,
        password: _authData['password']!,
      );
      if (isAccountCreated) {
        navigatorContext.pushReplacementNamed(UserScreen.routeName);
        // ignore: use_build_context_synchronously
        ShowSnackBar(
          context: context,
          label: 'Account Created Successfully.',
          color: MyColors.primaryColor,
        ).show();
      } else {
        // ignore: use_build_context_synchronously
        ShowSnackBar(
          context: context,
          label: 'Account Already Found.',
          color: MyColors.primaryColor,
        ).show();
      }
    } else {
      final isUserFound = await auth.login(
        email: _authData['email']!,
        password: _authData['password']!,
      );
      if (isUserFound) {
        final currentUserRole = AuthProvider.currentUserRole;
        if (currentUserRole == 'admin') {
          navigatorContext.pushReplacementNamed(AdminScreen.routeName);
        } else {
          navigatorContext.pushReplacementNamed(UserScreen.routeName);
        }
        // ignore: use_build_context_synchronously
        ShowSnackBar(
          context: context,
          label: 'Logined Successfully.',
          color: MyColors.primaryColor,
        ).show();
      } else {
        // ignore: use_build_context_synchronously
        ShowSnackBar(
          context: context,
          label: 'User not found.',
          color: MyColors.primaryColor,
        ).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            MyIcons.lock,
            height: 100,
            width: 100,
            color: MyColors.primaryColor,
          ),
          const SizedBox(height: 40),
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_authMode == AuthMode.signup) ...[
                  Text(
                    'Username',
                    style: MyFonts.getFont(
                      color: MyColors.primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  CustomTextField(
                    getKey: 'username',
                    hintText: 'Enter Username Here',
                    width: 500,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    onSaved: (username) {
                      _authData['username'] = username!;
                    },
                  ),
                ],
                const SizedBox(height: 30),
                Text(
                  'Email',
                  style: MyFonts.getFont(
                    color: MyColors.primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                CustomTextField(
                  getKey: 'email',
                  hintText: 'Enter Email Here',
                  width: 500,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field is required';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter valid email!';
                    }
                    return null;
                  },
                  onSaved: (email) {
                    _authData['email'] = email!;
                  },
                ),
                const SizedBox(height: 30),
                Text(
                  'Password',
                  style: MyFonts.getFont(
                    color: MyColors.primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                CustomTextField(
                  getKey: 'password',
                  hintText: 'Enter Password Here',
                  controller: _passwordController,
                  width: 500,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field is required';
                    }
                    if (value.length < 5) {
                      return 'Password must contain at least 5 characters.';
                    }
                    return null;
                  },
                  onSaved: (password) {
                    _authData['password'] = password!;
                  },
                ),
                if (_authMode == AuthMode.signup) ...[
                  const SizedBox(height: 30),
                  Text(
                    'Confirm Password',
                    style: MyFonts.getFont(
                      color: MyColors.primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  CustomTextField(
                    getKey: 'confirm password',
                    hintText: 'Enter Password Here',
                    width: 500,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This field is required';
                      }
                      if (_passwordController.text != value.trim()) {
                        return 'Password does not match!';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 30),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _onSubmitted(),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(300, 40),
              backgroundColor: MyColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              _authMode == AuthMode.login ? 'Login' : 'Signup',
              style: MyFonts.getFont(
                color: MyColors.secondaryColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _authMode == AuthMode.login
                    ? 'Don\'t have an account?'
                    : 'Already have an account?',
                style: MyFonts.getFont(
                  color: MyColors.primaryColor.withOpacity(0.5),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    if (_authMode == AuthMode.login) {
                      _authMode = AuthMode.signup;
                    } else {
                      _authMode = AuthMode.login;
                    }
                  });
                },
                child: Text(
                  _authMode == AuthMode.login ? 'Sign up' : 'Login',
                  style: MyFonts.getFont(
                    color: MyColors.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
