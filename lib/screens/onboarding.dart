/*
import 'package:flutter/material.dart';
import 'package:loggingg/screens/authpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = [
    const OnboardingContent(
      image: 'assets/Hello Robot.png',
      title: "Let's get started!",
      description: "Together, let's unleash the \n power of an AI in Java learning.",
      imageTitle: 'CLARA',
      subImageTitle: 'AN AI JAVA CHATBOT',
    ),
    const OnboardingContent(
      image: 'assets/Chatbot.png',
      title: 'About Clara',
      description: 'Clara is an AI Java chatbot that \n will answer your questions\nabout Java.',
      imageTitle: 'CLARA',
      subImageTitle: 'AN AI JAVA CHATBOT',
    ),
    const Stack(
      children: [
        CircleBackground(),
        OnboardingContentThirdPage(
          title: 'Are you ready?',
          description: "I am excited to answer your\ninquiries!Together,let's\nimprove our skills in Java.",
          imageTitle: 'CLARA',
          subImageTitle: 'AN AI JAVA CHATBOT',
        ),
      ],
    ),
  ];

  final List<String> _buttonTexts = [
    'Get Started',
    'Continue',
    "Let's create an account",
  ];

  // void _nextPage() {
  //   setState(() {
  //     _controller.nextPage(
  //       duration: const Duration(milliseconds: 500),
  //       curve: Curves.easeInOut,
  //     );
  //   });
  // }
  void _nextPage() async {
    if (_currentPage < _pages.length - 1) {
      setState(() {
        _controller.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasSeenOnboarding', false);

      Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthPage()));
    }
  }

  Widget _buildNextButton() {
    return SizedBox(
      height: 55,
      width: 210,
      child: TextButton(
        onPressed: () {
          _nextPage();
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(_buttonTexts[_currentPage]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFE5E5E5), // Change this color to the desired shade of grey
        ),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _pages[index];
                  },
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 17),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: _pages.length,
                    effect: const ExpandingDotsEffect(
                      spacing: 4.0,
                      dotWidth: 6.5,
                      dotHeight: 7.0,
                      dotColor: Colors.black,
                      activeDotColor: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (_currentPage < _pages.length - 1) // Only show button for first two pages
                    _buildNextButton(),
                ],
              ),
              if (_currentPage == _pages.length - 1) // Only show button for the third page
                _buildNextButton(),
              const SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }
}

class CircleBackground extends StatelessWidget {
  const CircleBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -200,
          right: -170,
          child: Container(
            width: 460,
            height: 510,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final String image, title, description, imageTitle, subImageTitle;

  const OnboardingContent({super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.imageTitle,
    required this.subImageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            const SizedBox(height: 50),
            Text(
              imageTitle,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              subImageTitle,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            if (image.isNotEmpty)
              Image.asset(
                image,
                height: 280,
              ),
          ],
        ),
        const SizedBox(height: 27),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(fontSize: 17),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingContentThirdPage extends StatelessWidget {
  final String title, description, imageTitle, subImageTitle;

  const OnboardingContentThirdPage({super.key,
    required this.title,
    required this.description,
    required this.imageTitle,
    required this.subImageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            const SizedBox(height: 200),
            Text(
              imageTitle,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              subImageTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10), // Updated SizedBox for the third page
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold), // Updated font size for the third page
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 18), // Updated font size for the third page
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:loggingg/screens/authpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  List<Widget> _pages = [
    OnboardingContentFirstPage(),
    OnboardingContentSecondPage(),
    OnboardingContentThirdPage(),
  ];

  List<String> _buttonTexts = [
    'Get Started',
    'Continue',
    "Let's create an account",
  ];

  void _nextPage() async {
    if (_currentPage < _pages.length - 1) {
      setState(() {
        _controller.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasSeenOnboarding', false);

      Navigator.push(context, MaterialPageRoute(builder: (context) => AuthPage()));
    }
  }

  Widget _buildNextButton() {
    double buttonWidth = MediaQuery.of(context).size.width * 0.8; // Adjust button width based on screen width

    return SizedBox(
      height: 55,
      width: buttonWidth,
      child: TextButton(
        onPressed: () {
          _nextPage();
        },
        child: Text(_buttonTexts[_currentPage]),
        style: TextButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFE5E5E5), // Change this color to the desired shade of grey
        ),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _pages[index];
                  },
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 17),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: _pages.length,
                    effect: const ExpandingDotsEffect(
                      spacing: 4.0,
                      dotWidth: 6.5,
                      dotHeight: 7.0,
                      dotColor: Colors.black,
                      activeDotColor: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (_currentPage < _pages.length - 1) // Only show button for first two pages
                    _buildNextButton(),
                ],
              ),
              if (_currentPage == _pages.length - 1) // Only show button for the third page
                _buildNextButton(),
              const SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }
}

class CircleBackground extends StatelessWidget {
  const CircleBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Positioned(
          top: -screenHeight * 0.3, // Adjust position based on screen height
          right: -screenWidth * 0.2, // Adjust position based on screen width
          child: Container(
            width: screenWidth * 0.9, // Adjust width based on screen width
            height: screenHeight * 0.8, // Adjust height based on screen height
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingContentFirstPage extends StatelessWidget {
  const OnboardingContentFirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imagePadding = screenWidth * 0.1; // 10% of screen width as padding

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(imagePadding),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Text(
                'CLARA',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'AN AI JAVA CHATBOT',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              FractionallySizedBox(
                widthFactor: 0.6, // 80% of screen width
                child: Image.asset(
                  'assets/Hello Robot.png',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Let's get started!",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold), // Updated font size for the third page
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Together, let's unleash the \n power of an AI in Java learning.",
                    style: TextStyle(fontSize: 18), // Updated font size for the third page
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingContentSecondPage extends StatelessWidget {
  const OnboardingContentSecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imagePadding = screenWidth * 0.1; // 10% of screen width as padding

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(imagePadding),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Text(
                'CLARA',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'AN AI JAVA CHATBOT',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              FractionallySizedBox(
                widthFactor: 0.6, // 80% of screen width
                child: Image.asset(
                  'assets/Chatbot.png',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "About Clara",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold), // Updated font size for the third page
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Clara is an AI Java chatbot that \n will answer your questions\nabout Java.",
                    style: TextStyle(fontSize: 18), // Updated font size for the third page
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingContentThirdPage extends StatelessWidget {
  const OnboardingContentThirdPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const CircleBackground(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const SizedBox(height: 200),
                Text(
                  'CLARA',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'AN AI JAVA CHATBOT',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10), // Updated SizedBox for the third page
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Are you ready?",
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold), // Updated font size for the third page
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "I am excited to answer your\ninquiries!Together,let's\nimprove our skills in Java.",
                        style: TextStyle(fontSize: 18), // Updated font size for the third page
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
