import 'package:android_app/templates/dashboards/recuitor_applicant_list.dart';
import 'package:android_app/templates/dashboards/recuitor_hired_list.dart';
import 'package:android_app/templates/dashboards/recuitor_reject_list.dart';
import 'package:flutter/material.dart';

class ApplicantsScreen extends StatelessWidget {
  final String companyId;

  const ApplicantsScreen({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Candidates Management",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DashboardCard(
              icon: Icons.group,
              title: "All Applicants",
              subtitle: "View all applicants who applied for your jobs",
              iconColor: Colors.blueAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ApplicantsListPage(companyEmail:  companyId),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            DashboardCard(
              icon: Icons.check_circle,
              title: "Hired Applicants",
              subtitle: "Review the list of hired applicants",
              iconColor: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HiredCandidatesPage(companyEmail: companyId,),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            DashboardCard(
              icon: Icons.cancel,
              title: "Rejected Applicants",
              subtitle: "View the list of rejected applicants",
              iconColor: Colors.redAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RejectedCandidatesPage(companyEmail: companyId,),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.grey[900],
        shadowColor: Colors.black87,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: iconColor.withOpacity(0.2),
                child: Icon(icon, size: 28, color: iconColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder screens for navigation


class HiredApplicantsScreen extends StatelessWidget {
  final String companyId;

  const HiredApplicantsScreen({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hired Applicants"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text("Displaying hired applicants for Company ID: $companyId"),
      ),
    );
  }
}

class RejectedApplicantsScreen extends StatelessWidget {
  final String companyId;

  const RejectedApplicantsScreen({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rejected Applicants"),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Text("Displaying rejected applicants for Company ID: $companyId"),
      ),
    );
  }
}
