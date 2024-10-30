import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'candidate_dash.dart';

class CandidateProfileScreen extends StatefulWidget {
  final dynamic email;

  const CandidateProfileScreen({super.key,required this.email});

  @override
  _CandidateProfileScreenState createState() => _CandidateProfileScreenState();
}

class _CandidateProfileScreenState extends State<CandidateProfileScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController profileUrlController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? userId;
  bool isSaving = false;


  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        userId = user.uid;
        DocumentSnapshot snapshot =
        await _firestore.collection('user_candidate').doc(userId).get();

        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          fullNameController.text = data['fullName'] ?? '';
          phoneNumberController.text = data['phoneNum'] ?? '';
          birthdayController.text = data['birthday'] ?? '';
          profileUrlController.text = data['profile_url'] ?? '';
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching data: $e")),
      );
    }
  }

  Future<void> saveProfileData() async {
    if (userId == null) return;

    setState(() {
      isSaving = true; // Start saving
    });

    try {
      await _firestore.collection('user_candidate').doc(userId).update({
        'fullName': fullNameController.text.trim(),
        'phoneNum': phoneNumberController.text.trim(),
        'birthday': birthdayController.text.trim(),
        'profile_url': profileUrlController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CandidateDashboard(email_Id: widget.email)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving data: $e")),
      );
    } finally {
      setState(() {
        isSaving = false; // End saving
      });
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneNumberController.dispose();
    birthdayController.dispose();
    profileUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CandidateDashboard(email_Id: widget.email,)),
            ); // Go back to the previous screen (dashboard)
          },
        ),
        title: const Text("My Profile",

          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),

        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,


      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: birthdayController,
              decoration: const InputDecoration(
                labelText: 'Birthday (YYYY-MM-DD)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: profileUrlController,
              decoration: const InputDecoration(
                labelText: 'Profile Picture URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isSaving ? null : saveProfileData, // Disable button while saving
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size.fromHeight(50),
              ),
              child: isSaving
                  ? const CircularProgressIndicator(
                color: Colors.white,
              )
                  : const Text(
                'Save Profile',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
