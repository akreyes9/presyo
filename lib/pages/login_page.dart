import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
    const LoginPage({super.key});

    @override
    State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();

    bool _isLoading = false;
    bool _obscurePassword = true;

    Future<void> _login() async {
        setState(() => _isLoading = true);

        try {
            await Supabase.instance.client.auth.signInWithPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text,
            );

            if (!mounted) return;

            // Show a small message at the bottom of the screen.
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login successful!')),
            );
        } on AuthException catch (e) {
            // Supabase says no (weak password, email already used, etc.).
            // "e.message" is the explanation it gives us.
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(e.message)),
            );
        } finally {
            if (mounted) setState(() => _isLoading = false);
        }
    }

    // dispose() runs when the page is closed. We clean up the controllers
    // here so they do not keep using memory.
    @override
    void dispose() {
        _emailController.dispose();
        _passwordController.dispose();
        super.dispose();
    }

    // build() draws the screen. It runs again every time setState is called.
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Center(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 280),

                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                        const Text(
                            'Welcome back',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),

                        // A smaller, grey line under the title.
                        const Text(
                            'Log in to continue',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 32),

                        // Email box.
                        TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                        ),
                        const SizedBox(height: 16),

                        // Password box.
                        TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: const OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                            suffixIcon: IconButton(
                                // Pick the icon depending on true/false.
                                icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    size: 20,
                                ),
                                onPressed: () {
                                setState(() => _obscurePassword = !_obscurePassword);
                                },
                            ),
                            ),
                        ),
                        const SizedBox(height: 24),

                        SizedBox(
                            height: 48,
                            child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            child: Text(_isLoading ? 'Loading...' : 'Log In'),
                            ),
                        ),

                        // A gap between the Log In button and the link below it.
                        const SizedBox(height: 16),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                // Plain, non-clickable text.
                                const Text("Don't have an account?"),

                                // Only this part is clickable.
                                TextButton(
                                onPressed: () {
                                    Navigator.pushReplacement(
                                    context,    
                                    MaterialPageRoute(
                                        builder: (context) => const SignUpPage(),
                                    ),
                                    );
                                },
                                // styleFrom lets us change how the button looks.
                                // foregroundColor = the text color.
                                style: TextButton.styleFrom(
                                    foregroundColor: Theme.of(context).colorScheme.primary,
                                ),
                                child: const Text(
                                    'Sign up',
                                    // Bold makes it look more like a link.
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                ),
                            ],
                        ),
                        ],
                    ),
                    ),
                ),
            ),
        );
    }
}