import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecruiterPostJobScreen extends StatefulWidget {
  final dynamic companyId;

  const RecruiterPostJobScreen({super.key,required this.companyId});

  @override
  _RecruiterPostJobScreenState createState() => _RecruiterPostJobScreenState();
}

class _RecruiterPostJobScreenState extends State<RecruiterPostJobScreen> {
  // Controllers for job input fields
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController jobDescriptionController = TextEditingController();
  final TextEditingController jobLocationController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController skillsRequiredController = TextEditingController();

  get companyId => companyId;


  // Method to post the job to Firestore
  Future<void> postJob() async {
    final String jobTitle = jobTitleController.text.trim();
    final String jobDescription = jobDescriptionController.text.trim();
    final String jobLocation = jobLocationController.text.trim();
    final String salary = salaryController.text.trim();
    final String skillsRequired = skillsRequiredController.text.trim();

    if (jobTitle.isEmpty || jobDescription.isEmpty || jobLocation.isEmpty || salary.isEmpty || skillsRequired.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all the fields")),
      );
      return;
    }

    try {
      // Save job to Firestore
      await FirebaseFirestore.instance.collection('jobs').add({
        'jobTitle': jobTitle,
        'jobDescription': jobDescription,
        'jobLocation': jobLocation,
        'salary': salary,
        'skillsRequired': skillsRequired.split(',').map((skill) => skill.trim()).toList(),
        'postedAt': DateTime.now(),
        'companyId': widget.companyId, // Access the companyId directly from the widget
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Job posted successfully")),
      );

      // Clear the fields after successful submission
      jobTitleController.clear();
      jobDescriptionController.clear();
      jobLocationController.clear();
      salaryController.clear();
      skillsRequiredController.clear();


    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to post job: $e")),
      );
    }
  }


  @override
  void dispose() {
    jobTitleController.dispose();
    jobDescriptionController.dispose();
    jobLocationController.dispose();
    salaryController.dispose();
    skillsRequiredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Post a Job",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Job Details",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: jobTitleController,
                decoration: InputDecoration(
                  labelText: 'Job Title',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: jobDescriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Job Description',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: jobLocationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: salaryController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Salary (e.g.,5000/month)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: skillsRequiredController,
                decoration: InputDecoration(
                  labelText: 'Skills Required (comma-separated)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: postJob,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: const Text(
                    'Post Job',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}