import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title "JOBIN's" in bold style
            const Text(
              "JOBIN's",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
                fontFamily: 'Arial', // Use a bold font if available
              ),
            ),
            const SizedBox(height: 16),

            // Center Image with Rounded Corners
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child:Image.network(
                'https://images.unsplash.com/photo-1653669486925-bb7e9f160343?w=500&h=500',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),

            ),
            const SizedBox(height: 24),

            // "Welcome to JOBIN's" Text
            const Text(
              'Welcome to JOBIN\'s',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),

            // User Role Selection Container
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  const Text(
                    'I am a:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Recruiter Button
                      ChoiceButton(
                        icon: Icons.business,
                        label: 'Recruiter',
                        iconColor: Colors.blue,
                        onTap: () {
                          // Action for Recruiter
                        },
                      ),
                      const SizedBox(width: 16),
                      // Candidate Button
                      ChoiceButton(
                        icon: Icons.person,
                        label: 'Candidate',
                        iconColor: Colors.teal,
                        onTap: () {
                          // Action for Candidate
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChoiceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final VoidCallback onTap;

  const ChoiceButton({
    super.key,
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 40),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
