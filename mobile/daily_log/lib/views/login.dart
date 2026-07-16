import 'dart:convert';

import 'package:daily_log/models/session.dart';
import 'package:daily_log/repositories/session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final serverController = TextEditingController(
    text: 'https://10.0.2.2:4000',
  );

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  Future<void> login() async {
    final serverUrl = serverController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (serverUrl.isEmpty) {
      setState(() {
        errorMessage = 'Podaj adres serwera';
      });
      return;
    }

    final serverUri = Uri.tryParse(serverUrl);

    if (serverUri == null ||
        !serverUri.hasScheme ||
        !serverUri.hasAuthority) {
      setState(() {
        errorMessage = 'Podaj poprawny adres serwera';
      });
      return;
    }

    if (email.isEmpty) {
      setState(() {
        errorMessage = 'Podaj adres e-mail';
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        errorMessage = 'Podaj hasło';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Tutaj wywołaj swoje API:
      //
      // final response = await authRepository.login(
      //   serverUrl: serverUrl,
      //   email: email,
      //   password: password,
      // );

      // await Future<void>.delayed(
      //   const Duration(seconds: 1),
      // );

      final url = Uri.parse('${serverUri.toString()}/api/json/sessions/password');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/vnd.api+json',
        },
        body: jsonEncode({
          'data': {
            'attributes': {
              'email': email,
              'password': password,
            }
          }
        }),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        print(json["data"]["attributes"]);
        final Session session = Session.fromJson(json["data"]);

        await SessionRepository.instance.login(
          userId: session.userId,
          id: session.id,
          accessToken: session.accessToken,
          hostUrl: serverUri.toString(),
        );
      } else {
        print('Błąd: ${response.statusCode}');
        print(response.body);
      }


      // Nie trzeba używać Navigator.push().
      // ValueListenableBuilder automatycznie pokaże HomePage
      // po zmianie stanu sesji.
    } catch (error, stackTrace) {
      debugPrint('Błąd logowania: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) {
        return;
      }

      setState(() {
        errorMessage = 'Nie udało się zalogować';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 400,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 64,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Logowanie',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: serverController,
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.next,
                    enabled: !isLoading,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: 'Adres serwera',
                      hintText: 'http://10.0.2.2:8080',
                      prefixIcon: Icon(Icons.dns_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    enabled: !isLoading,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      hintText: 'user@example.com',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    enabled: !isLoading,
                    onSubmitted: (_) {
                      if (!isLoading) {
                        login();
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Hasło',
                      prefixIcon: Icon(Icons.password_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : login,
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Zaloguj się'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
