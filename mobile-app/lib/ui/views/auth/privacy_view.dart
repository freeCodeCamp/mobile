import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';

class PrivacyView extends StatelessWidget {
  const PrivacyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const paragraphTextStyle = TextStyle(
      fontSize: 18,
      fontFamily: 'Lato',
      height: 1.2,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Email Sign Up',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Please slow down and read this.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                'freeCodeCamp is a proven path to your first software developer job.',
                style: paragraphTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'More than 40,000 people have gotten developer jobs after completing this — including at big companies like Google and Microsoft.',
                style: paragraphTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'More than 40,000 people have gotten developer jobs after completing this - including at big companies like Google and Microsoft.',
                style: paragraphTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'If you are new to programming, we recommend you start at the beginning and earn these certifications in order.',
                style: paragraphTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'To earn each certification, build its 5 required projects and get all their tests to pass.',
                style: paragraphTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'You can add these certifications to your résumé or LinkedIn. But more important than the certifications is the practice you get along the way.',
                style: paragraphTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'If you feel overwhelmed, that is normal. Programming is hard.',
                style: paragraphTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'Practice is the key. Practice, practice, practice.',
                style: paragraphTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'And this curriculum will give you thousands of hours of hands-on programming practice.',
                style: paragraphTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'And if you want to learn more math and computer science theory, we also have thousands of hours of video courses on freeCodeCamp\'s YouTube channel.',
                style: paragraphTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'If you want to get a developer job or freelance clients, programming skills will be just part of the puzzle. You also need to build your personal network and your reputation as a developer.',
                style: paragraphTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'You can do this on LinkedIn and GitHub, and also on the freeCodeCamp forum.',
                style: paragraphTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'Happy coding!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              buildDivider(),
              const SizedBox(
                height: 4,
              ),
              const Text(
                '- Quincy Larson, the teacher who founded freeCodeCamp.org',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Lato',
                  // height: 1.2,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                'By the way, each Friday I send an email with 5 links about programming and computer science. I send these to about 4 million people. Would you like me to send this to you, too?',
                style: paragraphTextStyle,
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF0a0a23),
                      ),
                      child: const Text('Yes please'),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF0a0a23),
                      ),
                      child: const Text(
                        'No thanks',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
