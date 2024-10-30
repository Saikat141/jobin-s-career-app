import 'package:flutter/material.dart';

class RecruiterLoginScreen extends StatelessWidget {
  const RecruiterLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "JOBIN's For Recruiter's",
          style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(
              color: Colors.blue,
              thickness: 2,
              indent: 32,
              endIndent: 32,
            ),
            const SizedBox(height: 20),
            const Text(
              "Let's get started by filling out the form below.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.visibility_off, color: Colors.grey),
                  onPressed: () {
                    // Toggle password visibility logic here if needed
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Sign in action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Sign In',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Forgot password action
              },
              child: const Text(
                'Forgot Password',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
