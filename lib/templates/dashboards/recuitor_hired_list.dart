import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HiredCandidatesPage extends StatefulWidget {
  final String companyEmail;

  const HiredCandidatesPage({
    required this.companyEmail,
    super.key,
  });

  @override
  _HiredCandidatesPageState createState() => _HiredCandidatesPageState();
}

class _HiredCandidatesPageState extends State<HiredCandidatesPage> {
  late Future<List<Map<String, dynamic>>> hiredCandidatesFuture;

  @override
  void initState() {
    super.initState();
    hiredCandidatesFuture = fetchHiredCandidates(widget.companyEmail);
  }

  /// Fetch hired candidates from job_status filtered by companyEmail and status
  Future<List<Map<String, dynamic>>> fetchHiredCandidates(String companyEmail) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('job_status')
          .where('companyEmail', isEqualTo: companyEmail) // Filter by recruiter email
          .where('status', isEqualTo: 'Hired')           // Only hired candidates
          .get();

      // Map data from Firestore documents into a list of maps
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (error) {
      print("Error fetching hired candidates: $error");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hired Candidates",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 6,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: hiredCandidatesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final hiredCandidates = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: hiredCandidates.length,
              itemBuilder: (context, index) {
                final candidate = hiredCandidates[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              color: Colors.deepPurple,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              candidate['candidateEmail'] ?? 'No Email',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ],
                        ),
                        Divider(thickness: 1, color: Colors.grey[300]),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.work_outline, size: 20, color: Colors.deepPurple),
                            const SizedBox(width: 8),
                            Text(
                              "Job Title: ${candidate['jobTitle'] ?? 'N/A'}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.business_outlined, size: 20, color: Colors.deepPurple),
                            const SizedBox(width: 8),
                            Text(
                              "Company: ${candidate['companyName'] ?? 'N/A'}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.feedback_outlined, size: 20, color: Colors.deepPurple),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                "Feedback: ${candidate['feedback'] ?? 'N/A'}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
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
                "No hired candidates found.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
        },
      ),
    );
  }
}
