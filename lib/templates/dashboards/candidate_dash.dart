import 'package:android_app/templates/auth/candidate_auth.dart';
import 'package:android_app/templates/dashboards/candidate_cv.dart';
import 'package:android_app/templates/dashboards/candidate_profile.dart';
import 'package:flutter/material.dart';


import 'candidate_job_status.dart';
import 'candidate_seach_job.dart';




class CandidateDashboard extends StatelessWidget {
  final dynamic email_Id;


  const CandidateDashboard({super.key, required this.email_Id});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("JOBIN's Candidate's Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
        ),

        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("User ID: $email_Id" ,
              style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 23),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            DashboardCard(
              title: "My Profile",
              subtitle: "Update your personal information and skills",
              icon: Icons.edit,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CandidateProfileScreen(email: email_Id,)),
                );
              },
            ),
            const SizedBox(height: 16),
            DashboardCard(
              title: "Search Jobs",
              subtitle: "Find and apply for jobs matching your skills",
              icon: Icons.search,
              additionalInfo: "Available Jobs",
              additionalCount: 42,
              onTap: () {

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SearchJobsScreen(candidateEmail: email_Id,)),
                );
              },
            ),
            const SizedBox(height: 16),
            DashboardCard(
              title: "Job Application History",
              subtitle: "Track your job applications",
              icon: Icons.history,
              statusCounts: const {
                "Pending": 5,
                "Hired": 2,
                "Rejected": 3,
              },
              onTap: () {

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => JobStatusScreen(candidateEmail: email_Id,)),
                );
              },
            ),

            const SizedBox(height: 16),

            DashboardCard(
              title: "Manage Your CV",
              subtitle: "Add your professional experience and skills",
              icon: Icons.work,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CandidateCVPage(candidateEmail: email_Id,)),
                );

              },
            ),
            const Spacer(),
            const LogoutButton(),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: Colors.black,
      //   selectedItemColor: Colors.deepPurple,
      //   unselectedItemColor: Colors.grey,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.dashboard),
      //       label: 'Dashboard',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.work_outline),
      //       label: 'Jobs',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.history),
      //       label: 'History',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //     ),
      //   ],
      // ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function onTap;
  final String? additionalInfo;
  final int? additionalCount;
  final Map<String, int>? statusCounts;

  const DashboardCard({super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.additionalInfo,
    this.additionalCount,
    this.statusCounts,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
                if (additionalInfo != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '$additionalInfo: $additionalCount',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                  ),
                if (statusCounts != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: statusCounts!.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Column(
                            children: [
                              Text(
                                '${entry.value}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurpleAccent,
                                ),
                              ),
                              Text(
                                entry.key,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
            Icon(
              icon,
              color: Colors.deepPurpleAccent,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CandidateAuthScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text(
        'Logout',
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
      ),
    );
  }
}