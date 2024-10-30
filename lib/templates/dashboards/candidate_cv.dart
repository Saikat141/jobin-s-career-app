import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'candidate_dash.dart';

class CandidateCVPage extends StatefulWidget {
  final String candidateEmail;

  const CandidateCVPage({super.key, required this.candidateEmail});

  @override
  State<CandidateCVPage> createState() => _CandidateCVPageState();
}

class _CandidateCVPageState extends State<CandidateCVPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Data variables
  String fullName = '';
  String phoneNum = '';
  String currentEmployer = '';
  String currentJobRole = '';
  String experience = '';
  String resumeUrl = '';
  String educationInput = '';
  String skillsInput = '';
  List<String> education = [];
  List<String> skills = [];

  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    _loadCandidateData();
  }

  void _loadCandidateData() async {
    DocumentSnapshot doc = await _firestore
        .collection('candidate_cv')
        .doc(widget.candidateEmail)
        .get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      setState(() {
        fullName = data['fullName'] ?? '';
        phoneNum = data['phoneNum'] ?? '';
        currentEmployer = data['currentEmployer'] ?? '';
        currentJobRole = data['current_job_role'] ?? '';
        experience = data['experience'] ?? '';
        resumeUrl = data['resume_URL'] ?? '';
        education = List<String>.from(data['education'] ?? []);
        skills = List<String>.from(data['skills'] ?? []);
        educationInput = education.join(", ");
        skillsInput = skills.join(", ");
      });
    }
  }

  void _saveCandidateData() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Parse input strings into lists
      education = educationInput.split(",").map((e) => e.trim()).toList();
      skills = skillsInput.split(",").map((e) => e.trim()).toList();

      _firestore.collection('candidate_cv').doc(widget.candidateEmail).set({
        'candidateEmail': widget.candidateEmail,
        'fullName': fullName,
        'phoneNum': phoneNum,
        'currentEmployer': currentEmployer,
        'current_job_role': currentJobRole,
        'experience': experience,
        'resume_URL': resumeUrl,
        'education': education,
        'skills': skills,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CV updated successfully!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CandidateDashboard(email_Id: widget.candidateEmail)),
      );

      setState(() {
        isEditMode = false; // Switch back to view mode
      });
    }
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
              MaterialPageRoute(builder: (context) => CandidateDashboard(email_Id: widget.candidateEmail,)),
            );
          },
        ),
        title: const Text(
          'Candidate CV',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 5,
      ),
      body: Container(
        color: Colors.blue[50],
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: isEditMode ? _buildEditSection() : _buildViewSection(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isEditMode = !isEditMode;
          });
        },
        backgroundColor: Colors.deepPurple,
        child: Icon(isEditMode ? Icons.visibility : Icons.edit),
      ),
    );
  }

  Widget _buildViewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Candidate CV Details",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 20),
        _buildInfoCard("Full Name", fullName),
        _buildInfoCard("Phone Number", phoneNum),
        _buildInfoCard("Current Employer", currentEmployer),
        _buildInfoCard("Current Job Role", currentJobRole),
        _buildInfoCard("Experience", experience),
        _buildInfoCard("Resume URL", resumeUrl),
        _buildInfoCard("Education", education.join(", ")),
        _buildInfoCard("Skills", skills.join(", ")),
      ],
    );
  }

  Widget _buildEditSection() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Edit Your CV",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          _buildTextField("Full Name", fullName, (value) => fullName = value!),
          _buildTextField("Phone Number", phoneNum, (value) => phoneNum = value!, keyboardType: TextInputType.phone),
          _buildTextField("Current Employer", currentEmployer, (value) => currentEmployer = value!),
          _buildTextField("Current Job Role", currentJobRole, (value) => currentJobRole = value!),
          _buildTextField("Experience", experience, (value) => experience = value!),
          _buildTextField("Resume URL", resumeUrl, (value) => resumeUrl = value!, keyboardType: TextInputType.url),
          _buildTextField(
            "Education (comma-separated)",
            educationInput,
                (value) => educationInput = value!,
            keyboardType: TextInputType.multiline,
          ),
          _buildTextField(
            "Skills (comma-separated)",
            skillsInput,
                (value) => skillsInput = value!,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: _saveCandidateData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value.isNotEmpty ? value : "Not provided"),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      String initialValue,
      void Function(String?) onSaved, {
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black87),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
        ),
        onSaved: onSaved,
      ),
    );
  }
}
