import 'package:daily_log/auth/l10n/auth_localizations.dart';
import 'package:daily_log/auth/presentation/api_exception_localization.dart';
import 'package:daily_log/auth/presentation/controllers/auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final AuthController authController;

  const LoginPage({super.key, required this.authController});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  final serverController = TextEditingController(text: 'http://10.0.2.2:4000');

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    final serverUri = Uri.parse(serverController.text.trim());

    await widget.authController.login(
      serverUri: serverUri,
      email: emailController.text.trim(),
      password: passwordController.text,
    );
  }

  String? _validateServerHost(String? value, AuthLocalizations l10n) {
    final host = value?.trim() ?? '';

    if (host.isEmpty) {
      return l10n.loginView_validation_hostEmpty;
    }

    final uri = Uri.tryParse(host);

    if (uri == null ||
        !uri.hasScheme ||
        !uri.hasAuthority ||
        !const {'http', 'https'}.contains(uri.scheme)) {
      return l10n.loginView_validation_hostInvalid;
    }

    return null;
  }

  String? _validateEmail(String? value, AuthLocalizations l10n) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return l10n.emailRequired;
    }

    final isValid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);

    if (!isValid) {
      return l10n.emailInvalid;
    }

    return null;
  }

  String? _validatePassword(String? value, AuthLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.passwordRequired;
    }

    return null;
  }

  @override
  void dispose() {
    serverController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.authController,
      builder: (context, child) {
        final authController = widget.authController;
        final isLoading = authController.isLoading;
        final error = authController.error;
        final l10n = AuthLocalizations.of(context)!;

        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(Icons.lock_outline, size: 64),
                        const SizedBox(height: 24),
                        Text(
                          l10n.loginView_Title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: serverController,
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.next,
                          enabled: !isLoading,
                          autocorrect: false,
                          enableSuggestions: false,
                          validator: (value) =>
                              _validateServerHost(value, l10n),
                          decoration: InputDecoration(
                            labelText: l10n.loginView_serverHostField,
                            hintText: 'http://10.0.2.2:4000',
                            prefixIcon: const Icon(Icons.dns_outlined),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          enabled: !isLoading,
                          autocorrect: false,
                          enableSuggestions: false,
                          autofillHints: const [
                            AutofillHints.email,
                            AutofillHints.username,
                          ],
                          validator: (value) => _validateEmail(value, l10n),
                          decoration: InputDecoration(
                            labelText: l10n.loginView_emailField,
                            hintText: 'user@example.com',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          enabled: !isLoading,
                          autocorrect: false,
                          enableSuggestions: false,
                          autofillHints: const [AutofillHints.password],
                          validator: (value) => _validatePassword(value, l10n),
                          onFieldSubmitted: (_) {
                            if (!isLoading) {
                              _login();
                            }
                          },
                          decoration: InputDecoration(
                            labelText: l10n.loginView_passwordField,
                            prefixIcon: const Icon(Icons.password_outlined),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Semantics(
                          liveRegion: true,
                          child: Text(
                            error != null
                                ? error.localizedMessage(context)
                                : "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _login,
                            child: isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(l10n.loginView_formSubmit),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
