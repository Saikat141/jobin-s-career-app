import 'package:android_app/templates/dashboards/candidate_dash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class SearchJobsScreen extends StatefulWidget {
  final String candidateEmail;

  const SearchJobsScreen({super.key, required this.candidateEmail});

  @override
  _SearchJobsScreenState createState() => _SearchJobsScreenState();
}

class _SearchJobsScreenState extends State<SearchJobsScreen> {
  String searchQuery = ""; // To store the filter query

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
             // Go back to the previous screen (dashboard)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CandidateDashboard(email_Id: widget.candidateEmail,)),
            );
          },
        ),
        title: const Text("Search Jobs",

                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search by Job Title",
                prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.trim(); // Update the filter query
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Error fetching jobs!"));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No jobs available."));
                }

                // Filter jobs by search query
                final jobs = snapshot.data!.docs.where((doc) {
                  final jobData = doc.data() as Map<String, dynamic>;
                  final jobTitle = jobData['jobTitle'] as String;

                  // Filter jobs by search query and check if the candidate already applied
                  return jobTitle.toLowerCase().contains(searchQuery.toLowerCase()) &&
                      !(jobData['applicants'] ?? []).contains(widget.candidateEmail);
                }).toList();

                if (jobs.isEmpty) {
                  return const Center(child: Text("No matching jobs found."));
                }

                return ListView.builder(
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    final jobData = job.data() as Map<String, dynamic>;

                    return JobCard(
                      jobId: job.id,
                      jobTitle: jobData['jobTitle'],
                      companyId: jobData['companyId'],
                      jobDescription: jobData['jobDescription'],
                      jobLocation: jobData['jobLocation'],
                      salary: jobData['salary'],
                      skillsRequired: List<String>.from(jobData['skillsRequired']),
                      candidateEmail: widget.candidateEmail,
                      onApply: () {
                        setState(() {}); // Refresh the UI to remove the job from the list
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final String jobId;
  final String jobTitle;
  final String companyId;
  final String jobDescription;
  final String jobLocation;
  final String salary;
  final List<String> skillsRequired;
  final String candidateEmail;
  final VoidCallback onApply;

  const JobCard({
    super.key,
    required this.jobId,
    required this.jobTitle,
    required this.companyId,
    required this.jobDescription,
    required this.jobLocation,
    required this.salary,
    required this.skillsRequired,
    required this.candidateEmail,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    jobTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Company: $companyId",
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Location: $jobLocation",
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Salary:  ৳ $salary",
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Skills Required: ${skillsRequired.join(', ')}",
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () => applyForJob(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: const Text(
                "Apply",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void applyForJob(BuildContext context) {
    FirebaseFirestore.instance.collection('jobs').doc(jobId).get().then((jobDoc) {
      if (jobDoc.exists) {
        final jobData = jobDoc.data() as Map<String, dynamic>;

        // Cross-check companyId and jobTitle
        if (jobData['companyId'] == companyId && jobData['jobTitle'] == jobTitle) {
          FirebaseFirestore.instance.collection('jobs').doc(jobId).update({
            'applicants': FieldValue.arrayUnion([candidateEmail])
          }).then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Application submitted successfully!")),
            );
            onApply(); // Refresh the UI to remove the applied job
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed to apply: $error")),
            );
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Job details mismatch. Cannot apply.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Job not found.")),
        );
      }
    });
  }
}
