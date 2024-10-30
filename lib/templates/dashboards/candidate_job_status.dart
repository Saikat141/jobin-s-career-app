import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'candidate_dash.dart';


class JobStatusScreen extends StatefulWidget {
  final String candidateEmail;

  const JobStatusScreen({super.key, required this.candidateEmail});

  @override
  _JobStatusScreenState createState() => _JobStatusScreenState();
}

class _JobStatusScreenState extends State<JobStatusScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CandidateDashboard(email_Id: widget.candidateEmail,)),
            ); // Go back to the previous screen (dashboard)
          },
        ),
        title: const Text(
          'Job Status Tracker',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            

        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                hintText: 'Search by Company Name...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('job_status')
            .where('candidateEmail', isEqualTo: widget.candidateEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
              ),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading data'),
            );
          }

          final jobs = snapshot.data!.docs
              .map((doc) => {
            'id': doc.id,
            'candidateEmail': doc['candidateEmail'],
            'companyEmail': doc['companyEmail'],
            'companyName': doc['companyName'],
            'feedback': doc['feedback'],
            'jobTitle': doc['jobTitle'],
            'status': doc['status'],
          })
              .where((job) => job['companyName']
              .toString()
              .toLowerCase()
              .contains(_searchQuery))
              .toList();

          return jobs.isEmpty
              ? const Center(
            child: Text(
              'No jobs found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
              : ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildJobStatusSection('Hired', jobs),
              _buildJobStatusSection('Pending', jobs),
              _buildJobStatusSection('Rejected', jobs),
            ],
          );
        },
      ),
    );
  }

  Widget _buildJobStatusSection(String status, List jobs) {
    final filteredJobs = jobs.where((job) => job['status'] == status).toList();

    if (filteredJobs.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ExpansionTile(
          title: Row(
            children: [
              Icon(
                status == 'Hired'
                    ? Icons.check_circle
                    : status == 'Pending'
                    ? Icons.hourglass_empty
                    : Icons.cancel,
                color: status == 'Hired'
                    ? Colors.green
                    : status == 'Pending'
                    ? Colors.orange
                    : Colors.red,
              ),
              const SizedBox(width: 10),
              Text(
                '$status (${filteredJobs.length})',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: status == 'Hired'
                      ? Colors.green
                      : status == 'Pending'
                      ? Colors.orange
                      : Colors.red,
                ),
              ),
            ],
          ),
          children: filteredJobs.map((job) {
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.2), width: 1),
                ),
              ),
              child: ListTile(
                title: Text(
                  '${job['jobTitle']} at ${job['companyName']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      'Candidate: ${job['candidateEmail']}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Company Email: ${job['companyEmail']}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Feedback: ${job['feedback']}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
                trailing: Chip(
                  label: Text(
                    job['status'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: status == 'Hired'
                      ? Colors.green
                      : status == 'Pending'
                      ? Colors.orange
                      : Colors.red,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
