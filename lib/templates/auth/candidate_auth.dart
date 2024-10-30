import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../dashboards/candidate_dash.dart';

class CandidateAuthScreen extends StatefulWidget {
  const CandidateAuthScreen({super.key});

  @override
  _CandidateAuthScreenState createState() => _CandidateAuthScreenState();
}

class _CandidateAuthScreenState extends State<CandidateAuthScreen> {
  bool isSignUp = false; // Flag to toggle between Sign In and Sign Up

  // Controllers for text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    fullNameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  // Sign-Up method
  Future<void> signUp() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();
    final String fullName = fullNameController.text.trim();
    final String phoneNumber = phoneNumberController.text.trim();

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save additional user data in Firestore
      await FirebaseFirestore.instance.collection('user_candidate').doc(userCredential.user?.uid).set({
        'fullName': fullName,
        'phoneNum': phoneNumber,
        'birthday': '',
        'profile_url': '',
        'uniqueEmail': email,
        'role' : 'candidate'
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully")),
      );

      // Navigate to candidate dashboard or any other screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CandidateAuthScreen()),
      );
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // Sign-In method
  Future<void> signIn() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    try {
      // Authenticate the user
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch user details from Firestore
      String? userId = userCredential.user?.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('user_candidate')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        String role = userDoc['role']; // Get the role field

        if (role == 'candidate') {
          // If the role matches, navigate to the Candidate Dashboard
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Signed in successfully")),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CandidateDashboard(email_Id: email)),
          );
        } else {
          // If the role doesn't match, sign out and show an error
          await FirebaseAuth.instance.signOut();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Unauthorized access. Please check your role.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User data not found. Please contact support.")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.deepPurple,
        elevation: 0,
        title: const Text(
          "JOBIN's For Candidate's",
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
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
              controller: emailController,
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
                    controller: fullNameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
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
              controller: passwordController,
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
                controller: confirmPasswordController,
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
                if (isSignUp) {
                  signUp();
                } else {
                  signIn();
                }
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
            // if (!isSignUp)
            //   TextButton(
            //     onPressed: () {
            //       // Forgot password action
            //     },
            //     child: const Text(
            //       'Forgot Password?',
            //       style: TextStyle(color: Colors.grey, fontSize: 16),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
