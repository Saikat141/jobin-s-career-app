import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicantsListPage extends StatefulWidget {
  final String companyEmail;

  const ApplicantsListPage({required this.companyEmail, super.key});

  @override
  _ApplicantsListPageState createState() => _ApplicantsListPageState();
}

class _ApplicantsListPageState extends State<ApplicantsListPage> {
  late Future<List<Map<String, dynamic>>> applicantsFuture;
  final Map<int, TextEditingController> feedbackControllers = {};

  @override
  void initState() {
    super.initState();
    applicantsFuture = fetchApplicants(widget.companyEmail);
  }

  Future<List<Map<String, dynamic>>> fetchApplicants(String companyEmail) async {
    // Fetch the company name using the email from the 'user' collection
    final userQuery = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: companyEmail)
        .get();

    String companyName = 'Unknown Company';
    if (userQuery.docs.isNotEmpty) {
      companyName = userQuery.docs.first.data()['companyName'] ?? 'Unknown Company';
    }

    // Get all jobs posted by the company
    final jobsQuery = await FirebaseFirestore.instance
        .collection('jobs')
        .where('companyId', isEqualTo: companyEmail)
        .get();

    if (jobsQuery.docs.isNotEmpty) {
      List<Map<String, dynamic>> applicantsList = [];

      for (var jobDoc in jobsQuery.docs) {
        String jobTitle = jobDoc.data()['jobTitle'] ?? '';
        String jobId = jobDoc.id;
        List<dynamic> applicants = jobDoc.data()['applicants'] ?? [];

        // Get candidates with existing feedback for this job
        final feedbackQuery = await FirebaseFirestore.instance
            .collection('job_status')
            .where('jobTitle', isEqualTo: jobTitle)
            .where('companyEmail', isEqualTo: companyEmail)
            .get();

        List<String> feedbackGivenCandidates = feedbackQuery.docs
            .map((doc) => doc.data()['candidateEmail'] as String)
            .toList();

        // Exclude candidates with feedback
        final remainingApplicants =
        applicants.where((email) => !feedbackGivenCandidates.contains(email)).toList();

        // Get details for remaining candidates
        if (remainingApplicants.isNotEmpty) {
          final candidates = await FirebaseFirestore.instance
              .collection('candidate_cv')
              .where('candidateEmail', whereIn: remainingApplicants)
              .get();

          for (var doc in candidates.docs) {
            final data = doc.data();
            data['jobTitle'] = jobTitle;
            data['jobId'] = jobId;
            data['companyName'] = companyName; // Use the fetched companyName
            applicantsList.add(data);
          }
        }
      }

      return applicantsList;
    }

    return [];
  }

  Future<void> updateJobStatus(
      Map<String, dynamic> applicant, String status, int index) async {
    String feedback = feedbackControllers[index]?.text.trim() ?? "";

    if (feedback.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please provide feedback before submitting."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('job_status').add({
        'candidateEmail': applicant['candidateEmail'],
        'companyEmail': widget.companyEmail,
        'companyName': applicant['companyName'], // Include companyName
        'jobTitle': applicant['jobTitle'],
        'status': status,
        'feedback': feedback,
      });

      // Update the list dynamically
      setState(() {
        applicantsFuture = applicantsFuture.then((applicants) {
          applicants.removeAt(index);
          feedbackControllers.remove(index);
          return applicants;
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Status updated: $status"),
          backgroundColor: status == 'Hired' ? Colors.teal : Colors.red,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error updating status: $error"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Applicants List",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: applicantsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.teal));
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final applicants = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: applicants.length,
              itemBuilder: (context, index) {
                final applicant = applicants[index];
                feedbackControllers[index] ??= TextEditingController();

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name: ${applicant['fullName'] ?? 'N/A'}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Email: ${applicant['candidateEmail']}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Company: ${applicant['companyName']}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Education: ${(applicant['education'] as List<dynamic>?)?.join(', ') ?? 'N/A'}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Skills: ${(applicant['skills'] as List<dynamic>?)?.join(', ') ?? 'N/A'}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Experience: ${applicant['experience'] ?? 'N/A'}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Job Title: ${applicant['jobTitle']}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: feedbackControllers[index],
                          decoration: InputDecoration(
                            labelText: "Feedback",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => updateJobStatus(
                                  applicant, 'Hired', index),
                              icon: const Icon(Icons.check_circle_outline),
                              label: const Text("Hire"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => updateJobStatus(
                                  applicant, 'Rejected', index),
                              icon: const Icon(Icons.cancel_outlined),
                              label: const Text("Reject"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                "No applicants found.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
        },
      ),
    );
  }
}
