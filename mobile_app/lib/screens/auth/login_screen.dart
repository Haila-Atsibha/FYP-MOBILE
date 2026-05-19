import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme.dart';
import 'package:mobile_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/screens/home/home_screen.dart';
import 'package:mobile_app/screens/provider/provider_dashboard_screen.dart';
import 'package:mobile_app/screens/admin/admin_dashboard_screen.dart';
import 'package:mobile_app/screens/auth/register_screen.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/providers/locale_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/screens/auth/verify_email_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  List<String> _savedEmails = [];

  @override
  void initState() {
    super.initState();
    _loadSavedEmails();
  }

  Future<void> _loadSavedEmails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedEmails = prefs.getStringList('saved_emails') ?? [];
    });
  }

  Future<void> _saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final emails = prefs.getStringList('saved_emails') ?? [];
    if (!emails.contains(email)) {
      emails.insert(0, email);
      if (emails.length > 5) emails.removeLast();
      await prefs.setStringList('saved_emails', emails);
    }
  }

  void _handleLogin() async {
    final auth = context.read<AuthProvider>();
    final String? errorMsg = await auth.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (errorMsg == null && mounted) {
      _saveEmail(_emailController.text.trim());
      final user = auth.user;
      Widget nextScreen;

      if (user?.role == 'admin') {
        nextScreen = const AdminDashboardScreen();
      } else if (user?.role == 'provider') {
        nextScreen = const ProviderDashboardScreen();
      } else {
        nextScreen = const HomeScreen();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => nextScreen),
      );
    } else if (mounted) {
      if (errorMsg != null && errorMsg.startsWith('EMAIL_NOT_VERIFIED|')) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => VerifyEmailScreen(email: _emailController.text.trim())),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg ?? AppLocalizations.of(context)!.loginFailed),
            backgroundColor: Colors.red.shade600,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with Gradient
            Container(
              height: 300,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppTheme.primaryColor, Color(0xFF1E293B)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                ),
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextButton.icon(
                          onPressed: () {
                            context.read<LocaleProvider>().toggleLocale();
                          },
                          icon: const Icon(Icons.language, color: AppTheme.accentColor, size: 20),
                          label: Text(
                            AppLocalizations.of(context)!.languageToggle,
                            style: const TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.1),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.flash_on, size: 40, color: AppTheme.accentColor),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        AppLocalizations.of(context)!.welcomeMessage,
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.professionalServicesSubtitle,
                        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
                      ),
                    ],
                  ),
                ),
                  ],
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.signIn,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                  ),
                  const SizedBox(height: 24),
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return _savedEmails;
                      }
                      return _savedEmails.where((String option) {
                        return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (String selection) {
                      _emailController.text = selection;
                    },
                    fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                      // Sync initial state if needed
                      if (controller.text.isEmpty && _emailController.text.isNotEmpty) {
                        controller.text = _emailController.text;
                      }
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        onChanged: (val) {
                          _emailController.text = val;
                        },
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.emailAddress,
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onEditingComplete: onEditingComplete,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.password,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Consumer<AuthProvider>(
                    builder: (context, auth, child) {
                      return ElevatedButton(
                        onPressed: auth.isLoading ? null : _handleLogin,
                        child: auth.isLoading
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text(AppLocalizations.of(context)!.login, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const RegisterScreen()),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: AppLocalizations.of(context)!.dontHaveAccount,
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                          children: [
                            TextSpan(
                              text: AppLocalizations.of(context)!.registerHere,
                              style: const TextStyle(
                                color: AppTheme.accentColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
