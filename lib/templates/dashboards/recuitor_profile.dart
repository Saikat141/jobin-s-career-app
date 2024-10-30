import 'package:android_app/templates/dashboards/recuitor_dash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecruiterProfile extends StatefulWidget {
  final String email;

  const RecruiterProfile({super.key, required this.email});

  @override
  State<RecruiterProfile> createState() => _RecruiterProfileState();
}

class _RecruiterProfileState extends State<RecruiterProfile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String companyName = "";
  String email = "";
  String companyDescription = "";
  String website = "";
  String phoneNumber = "";

  bool isLoading = true;

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserDataByEmail();
  }

  // Fetch user data based on email
  Future<void> fetchUserDataByEmail() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('user')
          .where('email', isEqualTo: widget.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userDoc = querySnapshot.docs.first;
        setState(() {
          companyName = userDoc['companyName'] ?? "N/A";
          email = userDoc['email'] ?? "N/A";
          companyDescription = userDoc['companyDescription'] ?? "";
          website = userDoc['website'] ?? "";
          phoneNumber = userDoc['phoneNumber'] ?? "";

          // Set controllers
          _descriptionController.text = companyDescription;
          _websiteController.text = website;
          _phoneController.text = phoneNumber;

          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No user found with this email")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading profile data: $e")),
      );
    }
  }

  // Save updated company info
  Future<void> saveCompanyInfo() async {
    if (_phoneController.text.isEmpty || _websiteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill out all fields")),
      );
      return;
    }

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('user')
          .where('email', isEqualTo: widget.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String documentId = querySnapshot.docs.first.id;

        await _firestore.collection('user').doc(documentId).update({
          'companyDescription': _descriptionController.text,
          'website': _websiteController.text,
          'phoneNumber': _phoneController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Company info updated successfully!")),
        );
        Navigator.push(context,
            MaterialPageRoute(
              builder:(context) => RecruiterDash(companyId: email,),

            )
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving company info: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recruiter Profile",

            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),

        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileDetail(label: "Company Name", value: companyName),
              const SizedBox(height: 16),
              ProfileDetail(label: "Email", value: email),
              const SizedBox(height: 16),
              const Text(
                "Company Description",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Enter company description",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _websiteController,
                decoration: const InputDecoration(
                  labelText: "Website",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveCompanyInfo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Save Info",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileDetail extends StatelessWidget {
  final String label;
  final String value;

  const ProfileDetail({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
}
