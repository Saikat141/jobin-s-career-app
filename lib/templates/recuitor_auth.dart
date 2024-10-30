import 'package:flutter/material.dart';

class RecruiterAuthScreen extends StatefulWidget {
  const RecruiterAuthScreen({super.key});

  @override
  _RecruiterAuthScreenState createState() => _RecruiterAuthScreenState();
}

class _RecruiterAuthScreenState extends State<RecruiterAuthScreen> {
  bool isSignUp = false; // Flag to toggle between Sign In and Sign Up

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
            // Toggle between Sign In and Sign Up
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      isSignUp = false;
                    });
                  },
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: isSignUp ? FontWeight.w500 : FontWeight.bold,
                      color: isSignUp ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isSignUp = true;
                    });
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: isSignUp ? FontWeight.bold : FontWeight.w500,
                      color: isSignUp ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Divider(
              color: Colors.blue,
              thickness: 2,
              indent: isSignUp ? MediaQuery.of(context).size.width * 0.5 : 32,
              endIndent: isSignUp ? 32 : MediaQuery.of(context).size.width * 0.5,
            ),
            const SizedBox(height: 20),
            Text(

              isSignUp ? "Let's get started by filling out the form below." : "Welcome back! Please login to continue.",
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Common Email Text Field
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

            // Additional fields for Sign Up
            if (isSignUp)
              Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Company Name',
                      labelStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),

            // Password Text Field
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.visibility_off, color: Colors.grey),
                  onPressed: () {
                    // Toggle password visibility logic if needed
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Confirm Password for Sign Up only
            if (isSignUp)
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: const TextStyle(color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.visibility_off, color: Colors.grey),
                    onPressed: () {
                      // Toggle confirm password visibility logic if needed
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            const SizedBox(height: 24),

            // Sign In or Sign Up Button
            ElevatedButton(
              onPressed: () {
                // Sign In or Sign Up action based on the current view
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                isSignUp ? 'Create Account' : 'Sign In',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),

            // Forgot Password for Sign In only
            if (!isSignUp)
              TextButton(
                onPressed: () {
                  // Forgot password action
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
