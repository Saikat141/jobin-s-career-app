import 'package:flutter/material.dart';

//Recuitor Dashbord
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Recruiter's Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),

        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Company Profile Card
            DashboardCard(
              icon: Icons.business,
              title: "Company Profile",
              subtitle: "Update your company details and information",
              iconColor: Colors.purpleAccent,
              onTap: () {
                // Navigate to Company Profile page
              },
            ),
            const SizedBox(height: 20),

            // Job Posts Card
            DashboardCard(
              icon: Icons.work,
              title: "Job Posts",
              subtitle: "Manage your job listings",
              iconColor: Colors.blueAccent,
              onTap: () {
                // Navigate to Job Posts page
              },
              activeJobs: 12,
            ),
            const SizedBox(height: 20),

            // Candidates Card
            DashboardCard(
              icon: Icons.group,
              title: "Candidates",
              subtitle: "Review and manage applicants",
              iconColor: Colors.greenAccent,
              onTap: () {
                // Navigate to Candidates page
              },
              newApplications: 28,
            ),
            const Spacer(),

            // Logout Button
            ElevatedButton(
              onPressed: () {
                // Logout action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Logout",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: "Jobs",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Candidates",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final int? activeJobs;
  final int? newApplications;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    this.activeJobs,
    this.newApplications,
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
              if (activeJobs != null || newApplications != null)
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    activeJobs != null ? '$activeJobs' : '${newApplications ?? 0}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
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
