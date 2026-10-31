import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';

// StatefulWidget = a widget that can change (like when the button says "Loading..."). 
class SignUpPage extends StatefulWidget {
    const SignUpPage({super.key});

    // This connects the page to its State class.
    @override
    State<SignUpPage> createState() => _SignUpPageState();
}

// The underscore (_) at the start means "private": only this file can use it.
class _SignUpPageState extends State<SignUpPage> {

    // Controllers are like "mailboxes" that hold what the user typed.
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _usernameController = TextEditingController();

    // true = we are waiting for Supabase to answer.
    bool _isLoading = false;

    // true = password is hidden as dots, false = password is visible. The "eye" icon will flip this.
    bool _obscurePassword = true;

    // This function runs when the user presses the Sign Up button.
    // Future<void> = "it does something slow and gives back nothing".
    Future<void> _signUp() async {

        // setState tells Flutter: "something changed, redraw the screen!"
        // Here it turns the button into "Loading...".
        setState(() => _isLoading = true);

        // try = "attempt this". If something goes wrong, jump to the catch part.
        try {
            // Send the email and password to Supabase and wait for the answer.
            await Supabase.instance.client.auth.signUp(
                email: _emailController.text.trim(), // trim() removes extra spaces
                password: _passwordController.text,
                data: {
                    'username': _usernameController.text.trim(),
                },
            );

            // After an "await", the user may have already left this page.
            // If so, stop here so the app does not crash.
            if (!mounted) return;

            // Show a small message at the bottom of the screen.
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account created!')),
            );
        } on AuthException catch (e) {
            // Supabase said no (weak password, email already used, etc.).
            // "e.message" is the explanation it gives us.
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(e.message)),
            );
        } finally {
            // "finally" runs no matter what (success or error).
            // We always want the button to stop saying "Loading...".
            if (mounted) setState(() => _isLoading = false);
        }
    }

    // dispose() runs when the page is closed. We clean up the controllers here so they do not keep using memory.
    @override
    void dispose() {
        _emailController.dispose();
        _passwordController.dispose();
        _usernameController.dispose();
        super.dispose();
    }

    // build() draws the screen. It runs again every time setState is called.
    @override
    Widget build(BuildContext context) {
        return Scaffold(

            body: Center(
            // Center puts everything in the middle of the screen.

            // SingleChildScrollView lets the page scroll if the screen is small
            // (for example, when the phone keyboard pops up).
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),

                // ConstrainedBox sets limits on size. Here: never wider than 280.
                // Without this, the boxes stretch across your whole wide window.
                child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),

                child: Column(
                    // "min" = the column is only as tall as its children need.
                    mainAxisSize: MainAxisSize.min,
                    // "stretch" = children fill the full width of the column.
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                        // The title. TextStyle controls how the text looks.
                        const Text(
                            'Create account',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),

                        // A smaller, grey line under the title.
                        const Text(
                            'Sign up to get started',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 32),

                        // Username box.
                        // OutlineInputBorder = a box outline around the field.
                        // prefixIcon = an icon at the left, inside the box.
                        TextField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                        ),
                        const SizedBox(height: 16),

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
                        // suffixIcon = an icon at the right, inside the box.
                        // This one is a button that shows or hides the password.
                        // Note: no "const" in front of InputDecoration here, because
                        // the icon changes (it depends on _obscurePassword).
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
                                // When pressed, flip true <-> false and redraw.
                                // The "!" means "the opposite of".
                                onPressed: () {
                                setState(() => _obscurePassword = !_obscurePassword);
                                },
                            ),
                            ),
                        ),
                        const SizedBox(height: 24),

                        // SizedBox can also set a fixed size. Here: 48 tall,
                        // and because of "stretch" above, it is full width.
                        SizedBox(
                            height: 48,
                            child: ElevatedButton(
                            onPressed: _isLoading ? null : _signUp,
                            child: Text(_isLoading ? 'Loading...' : 'Sign Up'),
                            ),
                        ),
                        // A gap between the Log In button and the link below it.
                        const SizedBox(height: 16),

                        Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            // Plain, non-clickable text.
                            const Text('Already have an account?'),

                            // Only this part is clickable.
                            TextButton(
                            onPressed: () {
                                Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                ),
                                );
                            },
                            style: TextButton.styleFrom(
                                foregroundColor: Theme.of(context).colorScheme.primary,
                            ),
                            child: const Text(
                                'Log in',
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