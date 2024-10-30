import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyJobsScreen extends StatelessWidget {
  final String companyId;

  const CompanyJobsScreen({super.key, required this.companyId});




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Posted Jobs",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('jobs')
            .where('companyId', isEqualTo: companyId) // Filter by companyId
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No jobs posted yet.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final jobs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];

              return JobCard(
                jobTitle: job['jobTitle'],
                jobDescription: job['jobDescription'],
                jobLocation: job['jobLocation'],
                salary: job['salary'],
                onDelete: () {
                  _deleteJob(context, job.id);
                },
              );
            },
          );
        },
      ),
    );
  }

  // Function to delete a job
  void _deleteJob(BuildContext context, String jobId) async {
    try {
      await FirebaseFirestore.instance.collection('jobs').doc(jobId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Job deleted successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting job: $e")),
      );
    }
  }
}

class JobCard extends StatelessWidget {
  final String jobTitle;
  final String jobDescription;
  final String jobLocation;
  final String salary;
  final VoidCallback onDelete;

  const JobCard({
    super.key,
    required this.jobTitle,
    required this.jobDescription,
    required this.jobLocation,
    required this.salary,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job Title
            Text(
              jobTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 8),

            // Job Description
            Text(
              jobDescription,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 8),

            // Job Location and Salary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 18, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      jobLocation,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.money, size: 18, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(
                      " ৳ $salary",
                      style: const TextStyle(fontSize: 14, color: Colors.green),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Delete Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, color: Colors.white, size: 16),
                  label: const Text("Delete", style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
